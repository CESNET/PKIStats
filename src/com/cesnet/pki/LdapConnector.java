package com.cesnet.pki;

import com.cesnet.pki.ejbca.Connector;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectOutputStream;
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
    
    private final int ORG_NAME = 0;
    private final int ORG_CS_NAME = 1;
    private final int ORG_EN_NAME = 2;

    private final String searchFilterAllCerts = "(&(objectClass=tcs2Order)(entryStatus=issued))";
    private final String searchFilterAllServerCerts = "(&(objectClass=tcs2ServerOrder)(entryStatus=issued))";
    private final String searchFilterAllClientCerts = "(&(objectClass=tcs2ClientOrder)(entryStatus=issued))";
    private final String searchFilterCesnetOrgDN = "(&(entryStatus=active)(objectClass=tcs2Organization))";
    private final String searchFilterOrganizations = "(&(tcs2ExtID>=0)(tcs2CesnetOrgDN~=dc=cz))";
    private final String searchFilterOrgName = "(o>=0)";   
    private final String searchFilter_ApiKey = "(&(tcs2ApiKey>=0)(tcs2ExtID>=0))";

    private final String searchBaseDN_TCS2   = "ou=Organizations,o=TCS2,o=apps,dc=cesnet,dc=cz";
    
    private final String certificateAttribute = "tcs2Certificate";    
    
    private HashSet<X509Certificate> certData = new HashSet<>();

    private Map<String, String[]> organizationNames = new HashMap<>();
    
    public void generateValidCerts(String type) {
        super.generateValidCerts();

        try {
            
            organizationNames = findOrganizationNames();
            
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
            
            // save certificates (for easy access from other java class Diff.java)
            saveGeneratedData(certData);
            
        }  catch (CertificateException | ParseException | NamingException | IOException ex) {
            Logger.getLogger(LdapConnector.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * saves once generated data of organization ids and validation dates
     * 
     * @param data to by saved
     * @throws IOException if an I/O error occurs while writing stream header
     */
    private void saveGeneratedData(HashSet<X509Certificate> data) throws IOException {
        try (ObjectOutputStream oos = new ObjectOutputStream (new FileOutputStream("dataLdap.properties"))) {
            oos.writeObject(data);
        }
    }    

    /**
     * @return simple search control
     */
    private SearchControls getSimpleSearchControls() {
        SearchControls searchControls = new SearchControls();
        searchControls.setSearchScope(SearchControls.SUBTREE_SCOPE);
        searchControls.setTimeLimit(30000);
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
     * @return Map of organization's id, organization's names and api key
     * @throws NamingException if a naming exception is encountered
     * @throws MalformedURLException if no protocol is specified, or an unknown protocol is found, or spec is null
     */
    protected HashMap<Integer, String[]> findApiKeysForDigicert() throws NamingException, MalformedURLException {

        // connect to ldap
        connect();

        String orgName = null, orgNameCs = null, orgNameEn = null;
        String apiKey;
        int organizationId;
        
        // create api key map
        HashMap<Integer, String[]> map = new HashMap<>();
        
        NamingEnumeration<SearchResult> namingEnum = ctx.search(searchBaseDN_TCS2, searchFilter_ApiKey, getSimpleSearchControls());
        
        while (namingEnum.hasMore ()) {
            SearchResult result = namingEnum.next ();
                                
            apiKey = (String) getAttribute("tcs2ApiKey",result);
            String externId = (String) getAttribute("tcs2ExtID",result);                
            organizationId = Integer.parseInt(externId);

            String orgDN = (String) getAttribute("tcs2CesnetOrgDN", result);    

            NamingEnumeration<SearchResult> namingEnum2 = ctx.search(orgDN, searchFilterOrgName, getSimpleSearchControls());                

            // it should has only one result
            SearchResult result2 = namingEnum2.next ();
            namingEnum2.close();

            // it always has all three attribute
            orgName = (String) getAttribute("o", result2);
            orgNameCs = (String) getAttribute("o;lang-cs", result2);
            orgNameEn = (String) getAttribute("o;lang-en", result2);

            map.put(organizationId, new String[]{apiKey, orgName,orgNameCs,orgNameEn});
            
        }
        
        ctx.close();
        namingEnum.close();
        
        return map;
    }
    
    /**
     * find name of all organization in Ldap
     * 
     * @return TreeMap of extern id and trilingual organization name
     * @throws NamingException 
     */
    protected Map<String, String[]> findOrganizationNames() throws NamingException {
        
        String orgName, orgNameCs, orgNameEn;
                
        Map<String, String[]> orgDN_has_name = new TreeMap<>();
        NamingEnumeration<SearchResult> namingEnum = ctx.search(searchBaseDN_TCS2, searchFilterOrganizations, getSimpleSearchControls());
         
        while (namingEnum.hasMore ()) {
            SearchResult result = namingEnum.next ();

            String externId = (String) getAttribute("tcs2ExtID",result);
            String orgDN = (String) getAttribute("tcs2CesnetOrgDN", result);

            NamingEnumeration<SearchResult> namingEnum2 = ctx.search(orgDN, searchFilterOrgName, getSimpleSearchControls());

            // it should has only one result
            SearchResult result2 = namingEnum2.next ();
            namingEnum2.close();

            // it always has all three attribute
            orgName = (String) getAttribute("o", result2);
            orgNameCs = (String) getAttribute("o;lang-cs", result2);
            orgNameEn = (String) getAttribute("o;lang-en", result2);

            orgDN_has_name.put(externId, new String[]{orgName,orgNameCs,orgNameEn});
                
        }
        namingEnum.close();
        
        return orgDN_has_name;
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
        Map<String, Integer> validCertsMap = new TreeMap<>();
        X509Certificate decodedCert;
        String organization;
        
        NamingEnumeration<SearchResult> namingEnum = ctx.search(searchBaseDN_TCS2, searchFilter, getSimpleSearchControls());
        
        while (namingEnum.hasMore ()) {
            SearchResult result = namingEnum.next ();
            
            if (getAttribute(certificateAttribute,result)!=null) {

                Object cert = getAttribute(certificateAttribute,result);

                decodedCert = decodeCertificate((byte[]) cert);
                
                // store found certificate in HashSet
                certData.add(decodedCert);
                
                // find search context to obtain parameter tcs2ExtID
                String dc = result.getName();
                int idx = dc.lastIndexOf(',')+1;
                // select only part of DC
                dc = dc.substring(idx);
                
                NamingEnumeration<SearchResult> namingEnum2 = ctx.search(dc+","+searchBaseDN_TCS2, searchFilterCesnetOrgDN, getSimpleSearchControls());
                SearchResult result2 = namingEnum2.next ();

                String externId = (String) getAttribute("tcs2ExtID",result2);
                
                organization = getOrganizationNameFromLdap(externId, ORG_NAME);

                if (isCertValidAtDay(decodedCert, referenceDate)) {
                    int count = validCertsMap.containsKey(organization) ? validCertsMap.get(organization) : 0;
                    validCertsMap.put(organization, count + 1);
                }
            }
        }
        ctx.close();
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

    /** 
     * @param orgId organization ID
     * @param lang id of constant language
     * @return returns organization name in required language if exists. Else null.
     */
    private String getOrganizationNameFromLdap(String orgId, int lang) {
        
        if (orgId == null) {
            return null;
        }
        
        if (organizationNames.containsKey(orgId)) {
            if (organizationNames.get(orgId)[lang] != null) {
                return organizationNames.get(orgId)[lang];
            } else { // always has three names (never else)
                System.out.println("nema jazyk s id " + lang);
                return firstNonNull(organizationNames.get(orgId));
            }
        }
        return null;
    }
}