package com.cesnet.pki.ejbca;

import java.io.ByteArrayInputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
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
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Properties;
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

/**
 * 
 * @author jana kejvalova
 */
public class Connector {
   
    private final String INI_FILE = "/etc/ejbca.ini";    
    
    private final int MATCH_TYPE_BEGINSWITH = 1;
    private final int MATCH_WITH_USERNAME = 0;    
    private final int EJBCA_MAX_RETURN_VALUE = 100;
    private final int NOT_REVOKED = -1;
        
    private final SimpleDateFormat format = new SimpleDateFormat ("yyyy-MM-dd");
   
    private final String characters = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.-@";
    private final Map<String, Integer> validCAs = new TreeMap<>();
    private final HashSet<String> ExcludeOrgs = new HashSet<>();
    private final HashSet<String> ExcludeUsers = new HashSet<>();
    private EjbcaWS ejbcaws;
    private Properties p;    
    private List<UserDataVOWS> UserDataList;
    private CertificateFactory certFactory;
    
    public static void main(String[] args) {        
        Connector con = new Connector();                
          
        try {
            // init
            con.certFactory = CertificateFactory.getInstance("X.509");
            
            con.p = con.loadIniFile();
            
            con.connectEjbCA();
            
            con.searchValidUsername();
            
            con.printResults();
           
        } catch (CertificateException | IOException | AuthorizationDeniedException_Exception | EjbcaException_Exception | IllegalQueryException_Exception | ParseException | InvalidNameException | CADoesntExistsException_Exception ex) {
            Logger.getLogger(Connector.class.getName()).log(Level.SEVERE, null, ex);
        }
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
            
            p = loadIniFile();
            
            connectEjbCA();
            
            searchValidUsername();
                       
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
        return p.getProperty("CAvalidAtDate");
    }
    
    /**
     * calls method for traversing all records
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
        
        UserDataList = searchValidUsernameBy100(new StringBuilder(), new ArrayList<>());
        
        // count valid CAs for remaining data (less than 100 records)
        countValidCAs(); 
    }
    
    /**
     * iterates records by alphabet (ejbcaws.findUser returns max 100 records)
     * after 100 records found, calls countValidCAs()
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
            }
            
            // move data from remainingData to list
            list.addAll(remainingData);
            remainingData.clear();
                       
            // maximum number of UserDataVOWS objects the ejbca returns is 100
            if (list.size() > EJBCA_MAX_RETURN_VALUE) {
                
                //copy and delete data after index 100
                remainingData.addAll(list.subList(EJBCA_MAX_RETURN_VALUE, list.size()));
                list.subList(EJBCA_MAX_RETURN_VALUE, list.size()).clear();
                                
                UserDataList = list;
             
                countValidCAs();   
                
                list = remainingData;
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
        
        System.setProperty("javax.net.ssl.keyStore", p.getProperty("keyStore"));
        System.setProperty("javax.net.ssl.keyStorePassword", p.getProperty("keyStorePassword"));

        QName qname = new QName(p.getProperty("serviceURI"), p.getProperty("serviceLocalPart"));
        URL url = new URL(p.getProperty("url"));
        Service service = Service.create(url, qname);

        ejbcaws = (EjbcaWS) service.getPort(new QName(p.getProperty("portURI"), p.getProperty("portLocalPart")), EjbcaWS.class);
    }
    
    /**
     * loads options.ini and return its values
     * 
     * @return Properties from ini file 'options.ini'
     * @throws IOException if an error occurred when reading from the input stream
     * @throws FileNotFoundException - if the file does not exist, is a directory rather than a regular file, or for some other reason cannot be opened for reading
     */
    private Properties loadIniFile() throws IOException, FileNotFoundException {
        
        Properties properties = new Properties();
        properties.load(new FileInputStream(INI_FILE));
        
        ExcludeOrgs.addAll(Arrays.asList(properties.getProperty("ExcludeOrgs").split(",")));
        ExcludeUsers.addAll(Arrays.asList(properties.getProperty("ExcludeUsers").split(",")));
                
        return properties;
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

        um.setMatchtype(Integer.parseInt(p.getProperty("Matchtype")));
        um.setMatchwith(Integer.parseInt(p.getProperty("Matchwith")));
        um.setMatchvalue(p.getProperty("Matchvalue"));

        // init user data list
        UserDataList = ejbcaws.findUser(um);      
        
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
                if (organization != null && isCaValidAtDay(CA, format.parse(p.getProperty("CAvalidAtDate")))) { 
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
     * @param cert - certificate with its validity
     * @param date - date to compare
     * @return true if certificate is valid at given date     *  
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
        System.out.println("Number of valid CA at " + p.getProperty("CAvalidAtDate") + " is:");
        
        for (Map.Entry entry : validCAs.entrySet()) {
            System.out.println(entry.getValue() + "\t" + entry.getKey() );
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
