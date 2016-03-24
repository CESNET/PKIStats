package com.cesnet.pki;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Arrays;
import java.util.Hashtable;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.Context;
import javax.naming.NamingEnumeration;
import javax.naming.NamingException;
import javax.naming.directory.Attribute;
import javax.naming.directory.Attributes;
import javax.naming.directory.SearchControls;
import javax.naming.directory.SearchResult;
import javax.naming.ldap.InitialLdapContext;
import javax.naming.ldap.LdapContext;
import javax.xml.namespace.QName;
import javax.xml.ws.Service;
import org.ejbca.core.protocol.ws.EjbcaWS;
import org.ini4j.Ini;

public class LdapConnector {
    
    private final String INI_FILE = "/etc/ejbca.ini";    
    private final String ldapSection = "ldap";    
        
    private Ini properties;   
    private LdapContext ctx;
    
    String searchFilter = "(&(cn=Petr Rysavy) (telephoneNumber=606064946))";  
    String searchFilterAllCAs = "(&(objectClass=tcs2Order)(entryStatus=issued))";
    String searchFilterAllServerCAs = "(&(objectClass=tcs2ServerOrder)(entryStatus=issued))";
    String searchFilterAllClientCAs = "(&(objectClass=tcs2ClientOrder)(entryStatus=issued))";
    
    String searchBaseDN_CA = "ou=Organizations,o=TCS2,o=apps,dc=cesnet,dc=cz";
    String searchBaseDN = "ou=Persons,o=TCS2,o=apps,dc=cesnet,dc=cz";
    
    String paramCertificate = "tcs2Certificate"; 
    
    public void ldap() {
        try {
            
            loadIniFile();
                        
            connect();
                    
            NamingEnumeration<SearchResult> namingEnum = ctx.search(searchBaseDN, searchFilter, getSimpleSearchControls());
           
            ctx.close();
            
            while (namingEnum.hasMore ()) {
                SearchResult result = (SearchResult) namingEnum.next ();   
                
                Attributes attrs = result.getAttributes ();
                
                System.out.println(attrs);
            }
            
            namingEnum.close();
        } catch (NamingException ex) {
            Logger.getLogger(LdapConnector.class.getName()).log(Level.SEVERE, "je to tady...", ex);
        } catch (IOException ex) {
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
     * @throws MalformedURLException - if no protocol is specified, or an unknown protocol is found, or spec is null 
     */
    private void connect() throws NamingException  {
        
        Hashtable<String, String> env = new Hashtable<>();
        env.put(Context.INITIAL_CONTEXT_FACTORY,"com.sun.jndi.ldap.LdapCtxFactory");
        env.put(Context.PROVIDER_URL, properties.get(ldapSection, "providerUrl"));
        env.put(Context.SECURITY_AUTHENTICATION, "simple");
        env.put(Context.SECURITY_PRINCIPAL, properties.get(ldapSection, "principal"));
        env.put(Context.SECURITY_CREDENTIALS, properties.get(ldapSection, "credentials"));

        ctx = new InitialLdapContext(env, null);             
        
    }
    
    /**
     * loads options.ini and return its values
     * 
     * @return Ini from ini file 'options.ini'
     * @throws IOException if an error occurred when reading from the input stream
     * @throws FileNotFoundException - if the file does not exist, is a directory rather than a regular file, or for some other reason cannot be opened for reading
     */
    private Ini loadIniFile() throws IOException, FileNotFoundException {
        
        Ini ini = new Ini();
        ini.load(new FileInputStream(INI_FILE));        
                
        return ini;
    }
}