package com.cesnet.pki.ejbca;

import com.cesnet.pki.DigicertConnector_backup;
import com.cesnet.pki.DigicertConnector;
import com.cesnet.pki.EjbcaConnector;
import com.cesnet.pki.LdapConnector;
import java.io.ByteArrayInputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.PrintWriter;
import java.security.cert.CertificateException;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
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
    
    private final String INI_FILE = "/etc/ejbca.ini";
    
    protected final SimpleDateFormat format = new SimpleDateFormat ("yyyy-MM-dd");
    protected Map<String, Integer> validCAs = new TreeMap<>();
    protected Ini properties;;
    protected CertificateFactory certFactory;
     
    public static void main(String[] args) {
        
        Connector c = new Connector();
                
        System.out.println("EJBCA:");
        EjbcaConnector ejbcaCon = new EjbcaConnector();
        ejbcaCon.generateValidCAs();
        c.printResults(ejbcaCon.validCAs);
        
        System.out.println("=======================");
       
        System.out.println("LDAP:");
        LdapConnector ldapCon = new LdapConnector();
        ldapCon.generateValidCAs();
        c.printResults(ldapCon.validCAs);
       
        System.out.println("=======================");
              
        System.out.println("DIGICERT:");
        DigicertConnector digicertCon = new DigicertConnector();
        digicertCon.generateValidCAs();
        
    }    

    public Connector() {
        try {
            
            this.certFactory = CertificateFactory.getInstance("X.509");
            this.properties = loadIniFile();
            
        } catch (CertificateException | IOException ex) {
            Logger.getLogger(Connector.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
        
    protected void generateValidCAs() {
        try {            
            connect();
        } catch (Exception ex) {
            Logger.getLogger(Connector.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    protected void connect() throws Exception {}    
    protected void countValidCAs()  throws Exception {}
    
    /**
     * @param select parameter which JSON do you want. Allowed input are "ejbca" or "ldap"
     * @return validCAs converted to JSON
     */
    public String getJSON(String select) {
        
        Map<String, Integer> completeMap = new TreeMap<>();
                
        // init
        switch (select) {
            case "ejbca":
                EjbcaConnector ejbcaCon = new EjbcaConnector();
                ejbcaCon.generateValidCAs();
                validCAs = ejbcaCon.validCAs;
                break;
            case "ldap":
                LdapConnector ldapCon = new LdapConnector();
                ldapCon.generateValidCAs();
                validCAs = ldapCon.validCAs;
                break;           
            default:
                System.out.println("wrong input, you can write only ejbca or ldap");
                break;
        }
        
        // create JSON alphabeticaly ordered
        StringBuilder handmadeJSON = new StringBuilder();
        handmadeJSON.append("{");

        for (Map.Entry<String, Integer> entry : completeMap.entrySet()) {
            handmadeJSON.append("\"").append(entry.getKey()).append("\":").append(entry.getValue()).append(",");
        }

        handmadeJSON.deleteCharAt(handmadeJSON.length()-1);
        handmadeJSON.append("}");

        return handmadeJSON.toString();
    }
    
    /**
     * saves JSON to file with given name .json
     * @param json results of searching
     * @param fileName given file name
     */
    protected void saveJsonResultsToFile(String json, String fileName) {
        
        try(PrintWriter out = new PrintWriter(fileName + ".json")){
            out.println( json );            
        } catch (FileNotFoundException ex) {
            Logger.getLogger(Connector.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    /** 
     * @return date from ini file
     */
    public String getDate() {
        return properties.get("ejbca", "CAvalidAtDate");
    }
    
    /**
     * loads options.ini and return its values
     * 
     * @return Ini from ini file 'options.ini'
     * @throws IOException if an error occurred when reading from the input stream
     * @throws FileNotFoundException if the file does not exist, is a directory rather than a regular file, or for some other reason cannot be opened for reading
     */
    private Ini loadIniFile() throws IOException, FileNotFoundException {

        Ini ini = new Ini();
        ini.load(new FileInputStream(INI_FILE));

        return ini;
    }
    
    /**
     * @param cert certificate to parse
     * @return organization name parsed from DN if exists, else null
     * @throws InvalidNameException if a syntax violation is detected. 
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
     * @param source encoded certificate
     * @return decoded generated certificate
     * @throws CertificateException This exception indicates one of a variety of certificate problems 
     */
    protected X509Certificate decodeCertificate(byte[] source) throws CertificateException {
      
        System.out.println(new String(source));
        
        return (X509Certificate)certFactory.generateCertificate(new ByteArrayInputStream(source));
    }

    /**
     * Checks if CA is valid at given date. It does not check revocation status.
     * 
     * @param cert certificate with its validity
     * @param date date to compare
     * @return true if certificate is valid at given date
     * @throws AuthorizationDeniedException_Exception an operation was attempted for which the user was not authorized
     * @throws EjbcaException_Exception an error caused by ejbca
     * @throws CADoesntExistsException_Exception if CA does not exists
     */
    protected boolean isCaValidAtDay(X509Certificate cert, Date date) throws AuthorizationDeniedException_Exception, EjbcaException_Exception, CADoesntExistsException_Exception {

        return (date.after(cert.getNotBefore()) && date.before(cert.getNotAfter()));
    }

    /**
     * prints number of valid CA at specific date for each organization
     * 
     * @param map which map should be printed
     */
    protected void printResults(Map<String, Integer> map) {
        // print results
        System.out.println("Number of valid CA at " + properties.get("ejbca", "CAvalidAtDate") + " is:");

        for (Map.Entry entry : map.entrySet()) {
            System.out.println(entry.getValue() + "\t" + entry.getKey() );
        }
    }
            
    /**
     * @param incrementalDate date to increment
     * @return increment date in format yyyy-MM-dd
     * @throws ParseException if the beginning of the specified string cannot be parsed.
     */
    private String incrementDate(String incrementalDate) throws ParseException  {

        Calendar c = Calendar.getInstance();
        c.setTime(format.parse(incrementalDate));
        c.add(Calendar.MONTH, 1); // number of days/months to add
        return incrementalDate = format.format(c.getTime()); // incrementalDate has a value of the new date
    }
}