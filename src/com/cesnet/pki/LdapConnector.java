package com.cesnet.pki;

import com.cesnet.pki.ejbca.Connector;
import java.net.MalformedURLException;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.text.ParseException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Hashtable;
import java.util.Map;
import java.util.TreeMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.Context;
import javax.naming.NamingEnumeration;
import javax.naming.NamingException;
import javax.naming.directory.SearchControls;
import javax.naming.directory.SearchResult;
import javax.naming.ldap.InitialLdapContext;
import javax.naming.ldap.LdapContext;

public class LdapConnector extends Connector {

    private final String ldapSection = "ldap";

    private LdapContext ctx;
    private final String searchFilterAllCerts = "(&(objectClass=tcs2Order)(entryStatus=issued))";
    private final String searchFilterAllServerCerts = "(&(objectClass=tcs2ServerOrder)(entryStatus=issued))";
    private final String searchFilterAllClientCerts = "(&(objectClass=tcs2ClientOrder)(entryStatus=issued))";
   
    private final String searchFilter_ApiKey = "(&(tcs2ApiKey>=0)(tcs2RegistryOrgID>=0))";
    private final String searchFilter_OrgId = "(tcs2RegistryOrgID>=0)";
    private final String searchFilter_OrganizationName = "(&(entryStatus=active)(o>=0))";

    private final String searchBaseDN_Cert     = "ou=Organizations,o=TCS2,o=apps,dc=cesnet,dc=cz";
    private final String searchBaseDN_ApiKey = "ou=Organizations,o=TCS2,o=apps,dc=cesnet,dc=cz";
    
    private final String certificateAttribute = "tcs2Certificate";
    private final String registryOrgIdAttribute = "tcs2RegistryOrgID";

    private HashMap<Integer, HashSet<String>> organizationNames = new HashMap<>();
    
    public void generateValidCerts(String type) {
        super.generateValidCerts();

        try {
            
            switch (type) {
                case "server":
                    validCertificates = countValidCerts(searchFilterAllServerCerts);
                    break;
                case "client":
                    validCertificates = countValidCerts(searchFilterAllClientCerts);
                    break;
                case "all":
                    validCertificates = countValidCerts(searchFilterAllCerts);
                    break;
                default:
                    System.out.println("wrong input, you can write only server, client or all");
                    break;
            }
            
        }  catch (CertificateException | ParseException | NamingException ex) {
            Logger.getLogger(LdapConnector.class.getName()).log(Level.SEVERE, null, ex);
        }
    }


    /**
     * @return simple search control
     */
    private SearchControls getSimpleSearchControls() {
        SearchControls searchControls = new SearchControls();
        searchControls.setSearchScope(SearchControls.SUBTREE_SCOPE);
        searchControls.setTimeLimit(30000);
        //String[] attrIDs = {"tcs2Certificate"};
        //searchControls.setReturningAttributes(attrIDs);
        return searchControls;
    }

    /**
     * @throws NamingException if a naming exception is encountered
     * @throws MalformedURLException if no protocol is specified, or an unknown protocol is found, or spec is null 
     */
    @Override
    protected void connect() throws NamingException, MalformedURLException {

        Hashtable<String, String> env = new Hashtable<>();
        env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
        env.put(Context.PROVIDER_URL, properties.get(ldapSection, "providerUrl"));
        env.put(Context.SECURITY_AUTHENTICATION, "simple");
        env.put(Context.SECURITY_PRINCIPAL, properties.get(ldapSection, "principal"));
        env.put(Context.SECURITY_CREDENTIALS, properties.get(ldapSection, "credentials"));
        env.put("java.naming.ldap.attributes.binary", certificateAttribute);

        ctx = new InitialLdapContext(env, null);
    }

    /** 
     * @return Map of organization's id and api key
     * @throws NamingException if a naming exception is encountered
     * @throws MalformedURLException if no protocol is specified, or an unknown protocol is found, or spec is null
     */
    protected HashMap<Integer, String> findApiKeysForDigicert() throws NamingException, MalformedURLException {

        // connect to ldap
        connect();

        // create api key map
        HashMap<Integer, String> apiKeyMap = new HashMap<>();
        NamingEnumeration<SearchResult> namingEnum = ctx.search(searchBaseDN_ApiKey, searchFilter_ApiKey, getSimpleSearchControls());
        ctx.close();

        while (namingEnum.hasMore ()) {
            SearchResult result = (SearchResult) namingEnum.next ();

            if (getAttribute("tcs2ApiKey",result)!=null && getAttribute("tcs2ExtID",result)!=null) {

                Object apiKey = getAttribute("tcs2ApiKey",result);
                Object externId = getAttribute("tcs2ExtID",result);
                Object registryOrgId = getAttribute("tcs2RegistryOrgID",result);

                System.out.println("test\t" + registryOrgId);
                int organizationId = Integer.parseInt((String)externId);

                apiKeyMap.put(organizationId, (String)apiKey);
            }
        }
        namingEnum.close();

        return apiKeyMap;
    }

    /**
     * Counts number of valid certificates and organization names at given date from ini file
     * 
     * @param searchFilter search filter
     * @return map of organizations and number of their valid CAs
     * @throws NamingException if a naming exception is encountered
     * @throws CertificateException This exception indicates one of a variety of certificate problems
     * @throws ParseException if the beginning of the specified string cannot be parsed.
     */
    protected Map<String, Integer> countValidCerts(String searchFilter) throws CertificateException, ParseException, NamingException {
        // init variables
        X509Certificate decodedCert;
        String organization;
        Map<String, Integer> validCertsMap = new TreeMap<>();
        
        NamingEnumeration<SearchResult> namingEnum = ctx.search(searchBaseDN_Cert, searchFilter, getSimpleSearchControls());

        ctx.close();
        
        while (namingEnum.hasMore ()) {
            SearchResult result = (SearchResult) namingEnum.next ();

            if (getAttribute(certificateAttribute,result)!=null) {

                Object cert = getAttribute(certificateAttribute,result);

                decodedCert = decodeCertificate((byte[]) cert);
              
                organization = getOrganizationName(decodedCert);
                
                if (organization != null && isCertValidAtDay(decodedCert, referenceDate)) {
                    int count = validCertsMap.containsKey(organization) ? validCertsMap.get(organization) : 0;
                    validCertsMap.put(organization, count + 1);
                }
            }
        }
        
        namingEnum.close();
        return validCertsMap;
    }

    /**
     * @param attribute attribute name
     * @param result search result
     * @return attribute name object if exists. Else null.
     * @throws NamingException if a naming exception was encountered while retrieving the value. 
     * @throws NoSuchElementException if this attribute has no values.
     */
    private Object getAttribute(String attribute, SearchResult result) throws NamingException {
        if (result.getAttributes().get(attribute) != null) {
            return result.getAttributes().get(attribute).get();
        } else {
            return null;
        }
    }
}