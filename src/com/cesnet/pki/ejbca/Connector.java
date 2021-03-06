package com.cesnet.pki.ejbca;

import com.cesnet.pki.Diff;
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
import java.text.Normalizer;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.InvalidNameException;
import javax.naming.ldap.LdapName;
import javax.naming.ldap.Rdn;
import org.ini4j.Ini;

/**
 * 
 * @author jana kejvalova
 */
public class Connector {

    private final String INI_FILE = "/etc/ejbca.ini";

    protected final SimpleDateFormat format = new SimpleDateFormat ("yyyy-MM-dd");
    protected Map<String, Integer> validCertificates = new TreeMap<>();
    protected HashSet<X509Certificate> cacheCertificates = new HashSet<>();
    protected Ini properties;
    protected CertificateFactory certFactory;
    private String compareDate;    
    protected Date referenceDate;

    protected final int NOT_BEFORE = 0;
    protected final int NOT_AFTER = 1;
        
    public static final int ORG_NAME = 0;
    public static final int ORG_CS_NAME = 1;
    public static final int ORG_EN_NAME = 2;
    
    public static final String ANSI_RESET   = "\u001B[0m";
    public static final String ANSI_BLACK   = "\u001B[30m";
    public static final String ANSI_RED     = "\u001B[31m";
    public static final String ANSI_GREEN   = "\u001B[32m";
    public static final String ANSI_YELLOW  = "\u001B[33m";
    public static final String ANSI_BLUE    = "\u001B[34m";
    public static final String ANSI_PURPLE  = "\u001B[35m";
    public static final String ANSI_CYAN    = "\u001B[36m";
    public static final String ANSI_WHITE   = "\u001B[37m";
    
    public static void main(String[] args) throws ParseException {
        Connector c = new Connector();
        /*  
        System.out.println(ANSI_GREEN+"EJBCA:");
        System.out.println(c.getJSON("ejbca"));
        
        System.out.println("=======================");

        System.out.println(ANSI_BLUE+"LDAP:");
        System.out.println(c.getJSON("ldap"));
       
        System.out.println("=======================");
             
        System.out.println(ANSI_PURPLE+"DIGICERT:");
        System.out.println(c.getJSON("digicert"));
        */

               System.out.println(c.getJSON("digicert"));

        Diff d = new Diff();
    System.out.println("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");

        System.out.println(ANSI_CYAN+"\t  LDAP ALL:\n"+ANSI_CYAN+"========================");        
        System.out.println(c.getJSON("ldap"));
        System.out.println(ANSI_CYAN+"========================");
        d.computeDifference("all");
//
//    System.out.println("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
//        
//        System.out.println(ANSI_CYAN+"\tLDAP SERVER:\n"+ANSI_CYAN+"========================");        
//        System.out.println(c.getLdapJSON("server"));
//        System.out.println(ANSI_CYAN+"========================");
//        d.computeDifference("server");
//        
//    System.out.println("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
//
//        System.out.println(ANSI_CYAN+"\tLDAP CLIENT:\n"+ANSI_CYAN+"========================");        
//        System.out.println(c.getLdapJSON("client"));
//        System.out.println(ANSI_CYAN+"========================");
//        d.computeDifference("client");
    }
    
    public Connector() {
        try {
            
            this.certFactory = CertificateFactory.getInstance("X.509");
            this.properties = loadIniFile();
            this.referenceDate = format.parse(properties.get("ejbca", "CAvalidAtDate"));
            
        } catch (CertificateException | IOException | ParseException ex) {
            Logger.getLogger(Connector.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    protected void generateValidCerts() {
        try {
            System.out.println(new java.util.Date());
            connect();
        } catch (Exception ex) {
            Logger.getLogger(Connector.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    protected void connect() throws Exception {}
    protected void countValidCerts()  throws Exception {}
    
    /**
     * @param select parameter which JSON do you want. Allowed input are "ejbca", "ldap" or "digicert"\n
     *        all cases returns all valid CAs
     * @return validCertificates converted to JSON
     */
    private String getJSON(String select) {

        Map<String, Integer> completeMap = new TreeMap<>();

        // init
        switch (select) {
            case "ejbca":
                EjbcaConnector ejbcaCon = new EjbcaConnector();
                ejbcaCon.generateValidCerts();
                completeMap = ejbcaCon.validCertificates;
                break;
            case "ldap":
                LdapConnector ldapCon = new LdapConnector();
                ldapCon.generateValidCerts("all");
                completeMap = ldapCon.validCertificates;
                break;
            case "digicert":
                DigicertConnector digicertCon = new DigicertConnector();
                digicertCon.generateValidCerts();
                completeMap = digicertCon.validCertificates;
                break;
            default:
                System.out.println("wrong input, you can write only ejbca, ldap or digicert");
                break;
        }

        return getJSON(completeMap);
    }
    
    private String getJSONldap(String select) {
        
        return getJSONldap(select);        
    }
    
    /**
     * @param map to convert
     * @return given map converted to JSON
     */
    public String getJSON(Map<String, Integer> map) {
        
        // create JSON
        StringBuilder handmadeJSON = new StringBuilder();
        handmadeJSON.append("{\"organizations\":[");

        for (Map.Entry<String, Integer> entry : map.entrySet()) {
            handmadeJSON.append("{\"name\":\"").append(entry.getKey()).append("\",\"count\":\"").append(entry.getValue()).append("\"},");
        }

        handmadeJSON.deleteCharAt(handmadeJSON.length()-1);
        handmadeJSON.append("]}");

        return handmadeJSON.toString();
    }
    /**
     * returns JSON from ldap
     * 
     * @param select parameter which Ldap JSON do you want. Allowed input are "server", "client" or "all"
     * @return validCertificates converted to JSON
     */
    public String getLdapJSON(String select) {

        LdapConnector ldapCon = new LdapConnector();
        ldapCon.generateValidCerts(select);
        Map<String, Integer> completeMap = ldapCon.validCertificates;            

        return getJSON(completeMap);
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
        return properties.get("ejbca", "CertValidAtDate");
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
    protected String getOrganizationNameFromCertificate(X509Certificate cert) throws InvalidNameException {
        String dn = cert.getSubjectDN().getName();

        LdapName ldapDN = new LdapName(dn);
        List<Rdn> listRdn = ldapDN.getRdns();

        for (Rdn rdn : listRdn) {
            if ("O".equals(rdn.getType())) {
                String organizationName = (String) rdn.getValue();
                return stripAccents(organizationName);
            }
        }
        return null;
    }

    /**
     * Removes diacritics (~= accents) from a string. The case will not be altered. For instance, 'à' will be replaced by 'a'.
     * 
     * @param s string to normalize
     * @return string without accents
     */
    private String stripAccents(String s) {
        s = Normalizer.normalize(s, Normalizer.Form.NFD);
        s = s.replaceAll("[\\p{InCombiningDiacriticalMarks}]", "");
        return s;
    }
    
    /** 
     * @param source encoded certificate
     * @return decoded generated certificate
     * @throws CertificateException This exception indicates one of a variety of certificate problems 
     */
    protected X509Certificate decodeCertificate(byte[] source) throws CertificateException {

        return (X509Certificate)certFactory.generateCertificate(new ByteArrayInputStream(source));
    }

    /**
     * Checks if certificate is valid at given date. It does not check revocation status.
     * 
     * @param cert certificate with its validity
     * @param date date to compare
     * @return true if certificate is valid at given date
     */
    protected boolean isCertValidAtDay(X509Certificate cert, Date date) {

        return (date.after(cert.getNotBefore()) && date.before(cert.getNotAfter()));
    }
 
    /**
     * prints number of valid certificate at specific date for each organization
     * 
     * @param map which map should be printed
     */
    protected void printResults(Map<String, Integer> map) {
        // print results
        System.out.println("Number of valid cerfificates at " + compareDate + " is:");

        for (Map.Entry entry : map.entrySet()) {
            System.out.println(entry.getValue() + "\t" + entry.getKey() );
        }
    }

    /**
     * @param incrementalDate date to increment
     * @return increment date in format yyyy-MM-dd
     * @throws ParseException if the beginning of the specified string cannot be parsed.
     */
    protected String incrementDate(String incrementalDate) throws ParseException  {

        Calendar c = Calendar.getInstance();
        c.setTime(format.parse(incrementalDate));
        c.add(Calendar.MONTH, 1); // number of days/months to add
        return incrementalDate = format.format(c.getTime()); // incrementalDate has a value of the new date
    }
        
    /**
     * Returns the first value in the array which is not null.
     * If all the values are null or the array is null
     * or empty then null is returned.
     *
     * @param <T> the component type of the array
     * @param values  the values to test, may be {@code null} or empty
     * @return the first value from {@code values} which is not {@code null}, or {@code null} if there are no non-null values
     */
    protected <T> T firstNonNull(T... values) {
        if (values != null) {
            for (T val : values) {
                if (val != null) {
                    return val;
                }
            }
        }
        return null;
    }
}