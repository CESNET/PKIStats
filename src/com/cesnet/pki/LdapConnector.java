package com.cesnet.pki;

import com.cesnet.pki.ejbca.Connector;
import java.net.MalformedURLException;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.text.ParseException;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.Context;
import javax.naming.NamingEnumeration;
import javax.naming.NamingException;
import javax.naming.directory.Attribute;
import javax.naming.directory.SearchControls;
import javax.naming.directory.SearchResult;
import javax.naming.ldap.InitialLdapContext;
import javax.naming.ldap.LdapContext;
import org.ejbca.core.protocol.ws.AuthorizationDeniedException_Exception;
import org.ejbca.core.protocol.ws.CADoesntExistsException_Exception;
import org.ejbca.core.protocol.ws.EjbcaException_Exception;

public class LdapConnector extends Connector {

    private final String ldapSection = "ldap";
        
    private LdapContext ctx;
    private final String searchFilterAllCAs = "(&(objectClass=tcs2Order)(entryStatus=issued))";
    private final String searchFilterAllServerCAs = "(&(objectClass=tcs2ServerOrder)(entryStatus=issued))";
    private final String searchFilterAllClientCAs = "(&(objectClass=tcs2ClientOrder)(entryStatus=issued))";
    private final String searchFilter_ApiKey = "(tcs2ApiKey>=0)";

    private final String searchBaseDN_CA_digicert = "ou=Organizations,o=TCS2,o=apps,dc=cesnet,dc=cz";
    private final String searchBaseDN_ApiKey      = "ou=Organizations,o=TCS2,o=apps,dc=cesnet,dc=cz";
    
    private final String certificateAttribute = "tcs2Certificate";

    @Override
    public void generateValidCAs() {
        super.generateValidCAs();
        
        try {   
            countValidCAs();
                        
        }  catch (CertificateException | AuthorizationDeniedException_Exception | EjbcaException_Exception | CADoesntExistsException_Exception | ParseException | NamingException ex) {
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

            if (result.getAttributes().get("tcs2ApiKey")!=null && result.getAttributes().get("tcs2ExtID")!=null) {
                
                Object apiKey = result.getAttributes().get("tcs2ApiKey").get();
                Object externId = result.getAttributes().get("tcs2ExtID").get();
                
                int organizationId = Integer.parseInt((String)externId);
                
                apiKeyMap.put(organizationId, (String)apiKey);
            }
        }        
        namingEnum.close();
        
        return apiKeyMap;
    }
    
    /**
     * counts number of valid CA and organization name at given date from ini file
     * 
     * @throws NamingException if a naming exception is encountered
     * @throws CertificateException This exception indicates one of a variety of certificate problems
     * @throws ParseException if the beginning of the specified string cannot be parsed.
     * @throws AuthorizationDeniedException_Exception an operation was attempted for which the user was not authorized
     * @throws EjbcaException_Exception an error caused by ejbca
     * @throws CADoesntExistsException_Exception if CA does not exists
     */
    @Override
    protected void countValidCAs() throws CertificateException, AuthorizationDeniedException_Exception, EjbcaException_Exception, CADoesntExistsException_Exception, ParseException, NamingException {
        // init variables
        X509Certificate CA;
        String organization;
        
        NamingEnumeration<SearchResult> namingEnum = ctx.search(searchBaseDN_CA_digicert, searchFilterAllCAs, getSimpleSearchControls());

        ctx.close();

        while (namingEnum.hasMore ()) {
            SearchResult result = (SearchResult) namingEnum.next ();

            if (result.getAttributes().get(certificateAttribute)!=null) {
                Attribute certificate = result.getAttributes().get(certificateAttribute);

                Object cert = certificate.get();

                CA = decodeCertificate((byte[]) cert);

                organization = getOrganizationName(CA);
                
                if (organization != null && isCaValidAtDay(CA, format.parse(properties.get("ejbca", "CAvalidAtDate")))) {
                    int count = validCAs.containsKey(organization) ? validCAs.get(organization) : 0;
                    validCAs.put(organization, count + 1);
                }
            }
        }        
        
        namingEnum.close();
    }
}