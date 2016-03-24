package com.cesnet.pki.ejbca;

import com.cesnet.pki.LdapConnector;
import java.io.ByteArrayInputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigInteger;
import java.net.MalformedURLException;
import java.net.URL;
import java.nio.charset.Charset;
import java.security.cert.CertificateException;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
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
import javax.xml.bind.DatatypeConverter;
import javax.xml.namespace.QName;
import javax.xml.ws.Service;
import org.ejbca.core.protocol.ws.*;
import org.ini4j.Ini;

/**
 * 
 * @author jana kejvalova
 */
public class Connector {
   
    private final String INI_FILE = "/etc/ejbca.ini";    
    private final String ejbcaSection = "ejbca";    
    
    private final int MATCH_TYPE_BEGINSWITH = 1;
    private final int MATCH_WITH_USERNAME = 0;    
    private final int EJBCA_MAX_RETURN_VALUE = 100;
    private final int NOT_REVOKED = -1;
        
    private final SimpleDateFormat format = new SimpleDateFormat ("yyyy-MM-dd");
   
    private final String characters = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.-@";
    private final Map<String, Integer> validCAs = new TreeMap<>();
    private final HashSet<String> ExcludeOrgs = new HashSet<>();
    private final HashSet<String> ExcludeUsers = new HashSet<>();
    private final HashSet<UserDataVOWS> UserDataList = new HashSet<>();
    private EjbcaWS ejbcaws;
    private Ini properties;    
    private CertificateFactory certFactory;
    
    private String incrementalDate;
    
    public static void main(String[] args) throws ParseException {        
                
        //LdapConnector adAuthenticator = new LdapConnector();         
        //adAuthenticator.ldap();
        
        
        Connector con = new Connector(); 
        
            try {
            // init
            con.certFactory = CertificateFactory.getInstance("X.509");
            
            con.properties = con.loadIniFile();
            
            con.connectEjbCA();
            
            con.searchValidUsername();            
            
            con.countValidCAs(); 
        
            con.printResults();
        
        } catch (CertificateException | IOException | AuthorizationDeniedException_Exception | EjbcaException_Exception | IllegalQueryException_Exception | ParseException | InvalidNameException | CADoesntExistsException_Exception ex) {
            Logger.getLogger(Connector.class.getName()).log(Level.SEVERE, null, ex);
        }  
    }
    
    /**
     * 
     * @throws ParseException 
     */
    private void incrementDate() throws ParseException {
        
        Calendar c = Calendar.getInstance();
        c.setTime(format.parse(incrementalDate));
        c.add(Calendar.MONTH, 1);  // number of days/months to add
        incrementalDate = format.format(c.getTime());  // incrementalDate has a value of the new date
    }

    /**
     * 
     * @return validCAs converted to JSON
     */
    public String getJSON() {
        
        // compute valid CAs
        try {
            // init
            certFactory = CertificateFactory.getInstance("X.509");
            
            properties = loadIniFile();
            
            connectEjbCA();
            
            searchValidUsername();
            
            countValidCAs();
                       
        } catch (CertificateException | IOException | AuthorizationDeniedException_Exception | EjbcaException_Exception | IllegalQueryException_Exception | ParseException | InvalidNameException | CADoesntExistsException_Exception ex) {
            Logger.getLogger(Connector.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        // create JSON alphabeticaly ordered
        StringBuilder handmadeJSON = new StringBuilder();
        handmadeJSON.append("{");
        
        for (Map.Entry<String, Integer> entry : validCAs.entrySet()) {
            handmadeJSON.append("\"");
            handmadeJSON.append(entry.getKey());
            handmadeJSON.append("\":");
            handmadeJSON.append(entry.getValue());
            handmadeJSON.append(",");
        }
        
        handmadeJSON.deleteCharAt(handmadeJSON.length()-1);
        handmadeJSON.append("}");
        
        return handmadeJSON.toString();
    }
    
    
    public String getDate() {
        return properties.get(ejbcaSection, "CAvalidAtDate");
    }
    
    /**
     * calls method for traversing all records and save rest 
     * 
     * @throws AuthorizationDeniedException_Exception - an operation was attempted for which the user was not authorized
     * @throws EjbcaException_Exception - an error caused by ejbca
     * @throws IllegalQueryException_Exception - if a given query was not legal 
     * @throws CertificateException - This exception indicates one of a variety of certificate problems   
     * @throws ParseException - if the beginning of the specified string cannot be parsed.
     * @throws InvalidNameException - This exception indicates that the name being specified does not conform to the naming syntax of a naming system
     * @throws CADoesntExistsException_Exception - if CA does not exists
     */
    private void searchValidUsername() throws AuthorizationDeniedException_Exception, EjbcaException_Exception, IllegalQueryException_Exception, CertificateException, ParseException, InvalidNameException, CADoesntExistsException_Exception {
        
        UserDataList.addAll(searchValidUsernameBy100(new StringBuilder(), new ArrayList<>()));        
    }
    
    /**
     * iterates records by alphabet and save results to UserDataList (ejbcaws.findUser returns max 100 records)     *  
     * 
     * @throws AuthorizationDeniedException_Exception - an operation was attempted for which the user was not authorized
     * @throws EjbcaException_Exception - an error caused by ejbca
     * @throws IllegalQueryException_Exception - if a given query was not legal 
     * @throws CertificateException - This exception indicates one of a variety of certificate problems   
     * @throws ParseException - if the beginning of the specified string cannot be parsed.
     * @throws InvalidNameException - This exception indicates that the name being specified does not conform to the naming syntax of a naming system
     * @throws CADoesntExistsException_Exception - if CA does not exists
     */  
    private List<UserDataVOWS> searchValidUsernameBy100(StringBuilder stringBuilder, List<UserDataVOWS> list) throws AuthorizationDeniedException_Exception, EjbcaException_Exception, IllegalQueryException_Exception, CertificateException, ParseException, InvalidNameException, CADoesntExistsException_Exception {
        
    for (char c : characters.toCharArray()) {            
            
            stringBuilder.append(c);

            List<UserDataVOWS> remainingData = getUserData(stringBuilder.toString());

            // maximum amount of records was found
            if (remainingData.size() > EJBCA_MAX_RETURN_VALUE) {
                
                list = searchValidUsernameBy100(stringBuilder, list);
                
                stringBuilder.deleteCharAt(stringBuilder.length()-1);
                
                continue;
            } else if (!remainingData.isEmpty()) {
            
                // move data from remainingData to list
                list.addAll(remainingData);
                remainingData.clear();

                UserDataList.addAll(list);
            }
            
            stringBuilder.deleteCharAt(stringBuilder.length()-1);   
        }        
        
        return list;    
    } 
     
    /**
     * connects to EjbCA
     * 
     * @throws MalformedURLException - if no protocol is specified, or an unknown protocol is found, or spec is null 
     */
    private void connectEjbCA() throws MalformedURLException  {
        
        System.setProperty("javax.net.ssl.keyStore", properties.get(ejbcaSection, "keyStore"));
        System.setProperty("javax.net.ssl.keyStorePassword", properties.get(ejbcaSection, "keyStorePassword"));

        QName qname = new QName(properties.get(ejbcaSection, "serviceURI"), properties.get(ejbcaSection, "serviceLocalPart"));
        URL url = new URL(properties.get(ejbcaSection, "url"));
        Service service = Service.create(url, qname);

        ejbcaws = (EjbcaWS) service.getPort(new QName(properties.get(ejbcaSection, "portURI"), properties.get(ejbcaSection, "portLocalPart")), EjbcaWS.class);
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
        
        ExcludeOrgs.addAll(Arrays.asList(ini.get(ejbcaSection,"ExcludeOrgs").split(",")));
        ExcludeUsers.addAll(Arrays.asList(ini.get(ejbcaSection,"ExcludeUsers").split(",")));
                
        return ini;
    }
    
    /**
     * sets up UserDataList by match from ini file
     * 
     * @return size of created UserDataList
     * @throws AuthorizationDeniedException_Exception - an operation was attempted for which the user was not authorized
     * @throws EjbcaException_Exception - an error caused by ejbca
     * @throws IllegalQueryException_Exception - if a given query was not legal 
     */
    private int initUserData() throws AuthorizationDeniedException_Exception, EjbcaException_Exception, IllegalQueryException_Exception {
        
        // create user match from properties to find users
        UserMatch um = new UserMatch();

        um.setMatchtype(Integer.parseInt(properties.get(ejbcaSection, "Matchtype")));
        um.setMatchwith(Integer.parseInt(properties.get(ejbcaSection, "Matchwith")));
        um.setMatchvalue(properties.get(ejbcaSection, "Matchvalue"));

        // init user data list
        //UserDataList = ejbcaws.findUser(um);      
        
        return UserDataList.size();
    }
    
    /**
     * returns user data by given matchvalue
     * 
     * @param matchValue - The matchvalue to set for finding users
     * @return size of created UserDataList
     * @throws AuthorizationDeniedException_Exception - an operation was attempted for which the user was not authorized
     * @throws EjbcaException_Exception - an error caused by ejbca
     * @throws IllegalQueryException_Exception - if a given query was not legal 
     */
    private List<UserDataVOWS> getUserData(String matchValue) throws AuthorizationDeniedException_Exception, EjbcaException_Exception, IllegalQueryException_Exception {
        
        // create user match from properties to find users
        UserMatch um = new UserMatch();

        um.setMatchtype(MATCH_TYPE_BEGINSWITH);
        um.setMatchwith(MATCH_WITH_USERNAME);
        um.setMatchvalue(matchValue);

        // init user data list
        return ejbcaws.findUser(um);     
    }
    
    /**
     * counts number of valid CA and organization name at given date
     * 
     * @throws CertificateException - This exception indicates one of a variety of certificate problems
     * @throws ParseException - if the beginning of the specified string cannot be parsed.
     * @throws AuthorizationDeniedException_Exception - an operation was attempted for which the user was not authorized
     * @throws EjbcaException_Exception - an error caused by ejbca
     * @throws InvalidNameException - This exception indicates that the name being specified does not conform to the naming syntax of a naming system
     * @throws CADoesntExistsException_Exception - if CA does not exists
     */
    private void countValidCAs() throws CertificateException, ParseException, AuthorizationDeniedException_Exception, EjbcaException_Exception, InvalidNameException, CADoesntExistsException_Exception{
                
        // init variables               
        X509Certificate CA;
        String organization;       

        // traverses all the current data and count valid CAs
        for (UserDataVOWS data : UserDataList) {                     
        //for (int i = 0; i < 5; i++) {   UserDataVOWS data = UserDataList.get(i); // for DEBUG

            String username = data.getUsername();                
            
            // do not use CA from excluded username
            if (ExcludeUsers.contains(username)) {                    
                break;
            }
            
            List<Certificate> certifList = ejbcaws.findCerts(username, false);

            for (Certificate encodedCA : certifList) {  
                
                CA = decodeCertificate(encodedCA.getCertificateData());             
          
                organization = getOrganizationName(CA);
               
                // do not use CA from excluded organization
                if (ExcludeOrgs.contains(organization)) {                    
                    break;
                }
                                
                // if CA contains organization and is valid, increment in map
                if (organization != null && isCaValidAtDay(CA, format.parse(properties.get(ejbcaSection, "CAvalidAtDate")))) {
                    int count = validCAs.containsKey(organization) ? validCAs.get(organization) : 0;
                    validCAs.put(organization, count + 1);                     
                }                
            }
        }
    }

    /**
     * @param cert - certificate to parse
     * @return organization name parsed from DN if exists, else null
     * @throws InvalidNameException - if a syntax violation is detected. 
     */
    private String getOrganizationName(X509Certificate cert) throws InvalidNameException {
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
    private X509Certificate decodeCertificate(byte[] source) throws CertificateException {       
           
        source = DatatypeConverter.parseBase64Binary(new String(source, Charset.forName("UTF-8")));
        
        return (X509Certificate)certFactory.generateCertificate(new ByteArrayInputStream(source));
    }    
    
    /**
     * Checks if CA is valid at given date. It does check revocation status.
     * 
     * @param cert - certificate with its validity
     * @param date - date to compare
     * @return true if certificate is valid at given date
     * @throws AuthorizationDeniedException_Exception - an operation was attempted for which the user was not authorized
     * @throws EjbcaException_Exception - an error caused by ejbca
     * @throws CADoesntExistsException_Exception - if CA does not exists
     */
    private boolean isCaValidAtDay(X509Certificate cert, Date date) throws AuthorizationDeniedException_Exception, EjbcaException_Exception, CADoesntExistsException_Exception {
  
        RevokeStatus status = ejbcaws.checkRevokationStatus(cert.getIssuerDN().toString(), cert.getSerialNumber().toString(16));

        Date revocationDate = status.getRevocationDate().toGregorianCalendar().getTime();

        return ((status.getReason() == NOT_REVOKED || date.before(revocationDate)) && date.after(cert.getNotBefore()) && date.before(cert.getNotAfter()));
    }
    
    /**
     * prints number of valid CA at specific date for each organization
     */
    private void printResults() {
        // print results
        System.out.println("Number of valid CA at " + properties.get(ejbcaSection, "CAvalidAtDate") + " is:");
        
        for (Map.Entry entry : validCAs.entrySet()) {
            System.out.println(entry.getValue() + "\t" + entry.getKey() );
        }
    }
    
    /**
     * saves JSON to file with name 'evaluatedDate'.json
     * @param json - results of searching
     */
    private void saveJsonResultsToFile(String json) {
        
        try(PrintWriter out = new PrintWriter(incrementalDate + ".json")){
            out.println( json );
            System.out.println("saved " + incrementalDate + ".json");
        } catch (FileNotFoundException ex) {
            Logger.getLogger(Connector.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    /**
     * prints all data from UserDataVOWS
     * 
     * @param data 
     */
    private void printAllUserDataVOWS(UserDataVOWS data) {
        String CaName = data.getCaName();
        String certificateProfileName = data.getCertificateProfileName();
        BigInteger certificateSerialNumber = data.getCertificateSerialNumber();
        String email = data.getEmail();
        String endEntityProfileName = data.getEndEntityProfileName();
        String endTime = data.getEndTime();
        String hardTokenIssuuerName = data.getHardTokenIssuerName();
        String password = data.getPassword(); 
        String startTime = data.getStartTime();
        int status = data.getStatus();
        String subjectAltName = data.getSubjectAltName();
        String subjectDN = data.getSubjectDN();
        String tokenType = data.getTokenType();
        String username = data.getUsername();
        
        System.out.println("\nCaName \t\t\t" + CaName);
        System.out.println("certificateProfileName \t" + certificateProfileName);
        System.out.println("certificateSerialNumber " + certificateSerialNumber);
        System.out.println("email \t\t\t" + email);
        System.out.println("endEntityProfileName \t" + endEntityProfileName);
        System.out.println("endTime \t\t" + endTime);
        System.out.println("hardTokenIssuuerName \t" + hardTokenIssuuerName);
        System.out.println("password \t\t...");
        System.out.println("startTime \t\t" + startTime);
        System.out.println("status \t\t\t" + status);
        System.out.println("subjectAltName \t\t" + subjectAltName);
        System.out.println("subjectDN \t\t" + subjectDN);
        System.out.println("tokenType \t\t" + tokenType);
        System.out.println("username \t\t" + username);
    }
}
