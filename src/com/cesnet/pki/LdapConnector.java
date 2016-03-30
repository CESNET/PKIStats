package com.cesnet.pki;

import com.cesnet.pki.ejbca.Connector;
import java.net.MalformedURLException;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.text.ParseException;
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

    LdapContext ctx;
    String searchFilterAllCAs = "(&(objectClass=tcs2Order)(entryStatus=issued))";
    String searchFilterAllServerCAs = "(&(objectClass=tcs2ServerOrder)(entryStatus=issued))";
    String searchFilterAllClientCAs = "(&(objectClass=tcs2ClientOrder)(entryStatus=issued))";

    String searchBaseDN_CA = "ou=Organizations,o=TCS2,o=apps,dc=cesnet,dc=cz";

    String certificateAttribute = "tcs2Certificate";

    public void ldap() {
        
        try {
            
            connect();
            
            countValidCAs();
            
            printResults();
            
        }  catch (CertificateException | AuthorizationDeniedException_Exception | EjbcaException_Exception | CADoesntExistsException_Exception | ParseException | MalformedURLException | NamingException ex) {
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
     * @throws NamingException - if a naming exception is encountered
     * @throws MalformedURLException - if no protocol is specified, or an unknown protocol is found, or spec is null 
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
    
    
    @Override
    protected void countValidCAs() throws NamingException, CertificateException, AuthorizationDeniedException_Exception, EjbcaException_Exception, CADoesntExistsException_Exception, ParseException {
        // init variables
        X509Certificate CA;
        String organization;
        
        NamingEnumeration<SearchResult> namingEnum = ctx.search(searchBaseDN_CA, searchFilterAllCAs, getSimpleSearchControls());

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