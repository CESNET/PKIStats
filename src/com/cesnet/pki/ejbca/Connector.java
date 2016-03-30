package com.cesnet.pki.ejbca;

import com.cesnet.pki.EjbcaConnector;
import com.cesnet.pki.LdapConnector;
import java.io.ByteArrayInputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.security.cert.CertificateException;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.InvalidNameException;
import javax.naming.ldap.LdapName;
import javax.naming.ldap.Rdn;
import org.ejbca.core.protocol.ws.AuthorizationDeniedException_Exception;
import org.ejbca.core.protocol.ws.CADoesntExistsException_Exception;
import org.ejbca.core.protocol.ws.EjbcaException_Exception;
import org.ini4j.Ini;

/**
 * 
 * @author jana kejvalova
 */
public class Connector {
    
    protected final String INI_FILE = "/etc/ejbca.ini";
    
    protected final SimpleDateFormat format = new SimpleDateFormat ("yyyy-MM-dd");
    protected final Map<String, Integer> validCAs = new TreeMap<>();
    protected Ini properties;;
    protected CertificateFactory certFactory;
     
    public static void main(String[] args) {
               
        //(total time: 2 minutes 8 seconds)
        
        System.out.println("EJBCA:");
        EjbcaConnector ejbcaCon = new EjbcaConnector();
        ejbcaCon.ejbca();
        
        System.out.println("=======================");
        
        System.out.println("LDAP:");
        LdapConnector ldapCon = new LdapConnector();
        ldapCon.ldap();
                
    }    

    public Connector() {
        try {
            
            this.certFactory = CertificateFactory.getInstance("X.509");
            this.properties = loadIniFile();
            
        } catch (CertificateException | IOException ex) {
            Logger.getLogger(Connector.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    protected void connect() throws Exception {}    
    protected void countValidCAs()  throws Exception {}
    
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
    
    /**
     * @param cert - certificate to parse
     * @return organization name parsed from DN if exists, else null
     * @throws InvalidNameException - if a syntax violation is detected. 
     */
    protected String getOrganizationName(X509Certificate cert) throws InvalidNameException {
        String dn = (String)cert.getSubjectDN().getName();

        LdapName ldapDN = new LdapName(dn);
        List<Rdn> listRdn = ldapDN.getRdns();

        for (Rdn rdn : listRdn) {
            if ("O".equals(rdn.getType())) {
                return (String) rdn.getValue();
            }
        }
        return null;
    }

    /** 
     * @param source - encoded certificate
     * @return decoded generated certificate
     * @throws CertificateException - This exception indicates one of a variety of certificate problems 
     */
    protected X509Certificate decodeCertificate(byte[] source) throws CertificateException {
      
        return (X509Certificate)certFactory.generateCertificate(new ByteArrayInputStream(source));
    }

    /**
     * Checks if CA is valid at given date. It does not check revocation status.
     * 
     * @param cert - certificate with its validity
     * @param date - date to compare
     * @return true if certificate is valid at given date
     * @throws AuthorizationDeniedException_Exception - an operation was attempted for which the user was not authorized
     * @throws EjbcaException_Exception - an error caused by ejbca
     * @throws CADoesntExistsException_Exception - if CA does not exists
     */
    protected boolean isCaValidAtDay(X509Certificate cert, Date date) throws AuthorizationDeniedException_Exception, EjbcaException_Exception, CADoesntExistsException_Exception {

        return (date.after(cert.getNotBefore()) && date.before(cert.getNotAfter()));
    }

    /**
     * prints number of valid CA at specific date for each organization
     */
    protected void printResults() {
        // print results
        System.out.println("Number of valid CA at " + properties.get("ejbca", "CAvalidAtDate") + " is:");

        for (Map.Entry entry : validCAs.entrySet()) {
            System.out.println(entry.getValue() + "\t" + entry.getKey() );
        }
    }
}