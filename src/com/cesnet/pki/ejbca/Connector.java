package com.cesnet.pki.ejbca;

import java.io.ByteArrayInputStream;
import java.io.FileInputStream;
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
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
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
   
    private final String INI_FILE = "options_public.ini";
    
    private EjbcaWS ejbcaws;
    private Properties p;
    private List<UserDataVOWS> UserDataList;
    private CertificateFactory certFactory;
    
    public static void main(String[] args) {
        Connector con = new Connector();
       
        try {  
            con.p = con.loadIniFile();        

            con.connectEjbCA();
            
            con.init();
            
            if (con.UserDataList != null){                
                con.countValidCAs();                
                
            } else {
                System.out.println("\tnebyl nalezen zadny zaznam");
            }
        
        } catch (MalformedURLException | IllegalQueryException_Exception | CertificateException | ParseException | AuthorizationDeniedException_Exception | EjbcaException_Exception ex) {
            Logger.getLogger(Connector.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IOException | InvalidNameException ex) {
            Logger.getLogger(Connector.class.getName()).log(Level.SEVERE, null, ex);
        }
        
    }
     
    /**
     * connect to EjbCA
     * 
     * @throws MalformedURLException 
     */
    private void connectEjbCA() throws MalformedURLException   {
        
        System.setProperty("javax.net.ssl.keyStore", p.getProperty("keyStore"));
        System.setProperty("javax.net.ssl.keyStorePassword", p.getProperty("keyStorePassword"));

        //System.setProperty("javax.net.ssl.trustStore","keystore.jks");
        //System.setProperty("javax.net.ssl.trustStorePassword","heslo"); 
                
        String urlstr = "https://ejbca.cesnet-ca.cz:8443/ejbca/ejbcaws/ejbcaws?wsdl";

        QName qname = new QName("http://ws.protocol.core.ejbca.org/", "EjbcaWSService");
        URL url = new URL(urlstr);
        Service service = Service.create(url, qname);

        ejbcaws = (EjbcaWS) service.getPort(new QName("http://ws.protocol.core.ejbca.org/", "EjbcaWSPort"), EjbcaWS.class);
         
    }
    
    /**
     * load options.ini and return its values
     * 
     * @return Properties from ini file 'options.ini'
     * @throws IOException if an error occurred when reading from the input stream.
     */
    private Properties loadIniFile() throws IOException  {
        
        Properties properties = new Properties();
        properties.load(new FileInputStream(INI_FILE));
        
        return properties;
    }

    /**
     * set up initial variables
     * 
     * @throws AuthorizationDeniedException_Exception from ejbcaws.findUser
     * @throws EjbcaException_Exception from ejbcaws.findUser
     * @throws IllegalQueryException_Exception from ejbcaws.findUser
     * @throws CertificateException if no Provider supports a CertificateFactorySpi implementation for the specified type.
     */
    private void init() throws AuthorizationDeniedException_Exception, EjbcaException_Exception, IllegalQueryException_Exception, CertificateException {
        
        // create user match from properties to find users
        UserMatch um = new UserMatch();

        um.setMatchtype(Integer.parseInt(p.getProperty("Matchtype")));
        um.setMatchwith(Integer.parseInt(p.getProperty("Matchwith")));
        um.setMatchvalue(p.getProperty("Matchvalue"));

        // init user data list
        UserDataList = ejbcaws.findUser(um);
        System.out.println("\tfound " + UserDataList.size() + " records\n");
        
        // init certificate factory
         certFactory = CertificateFactory.getInstance("X.509");   
                
    }
    
    /**
     * count and print number of valid CA and organization name at given date
     * 
     * @throws IllegalQueryException_Exception
     * @throws CertificateException
     * @throws ParseException
     * @throws AuthorizationDeniedException_Exception
     * @throws EjbcaException_Exception
     * @throws InvalidNameException 
     */
    private void countValidCAs() throws IllegalQueryException_Exception, CertificateException, ParseException, AuthorizationDeniedException_Exception, EjbcaException_Exception, InvalidNameException {
                
        // init variables
        SimpleDateFormat format = new SimpleDateFormat ("yyyy-MM-dd");
        
        Map<String, Integer> validCAs = new HashMap<>();
        
        X509Certificate CA;
        String organization;
        
        // traverses all the data and count valid CAs
        for (UserDataVOWS data : UserDataList) {                     
        //for (int i = 0; i < 5; i++) {   UserDataVOWS data = UserDataList.get(i); // for DEBUG
            
            String username = data.getUsername();
            List<Certificate> certifList = ejbcaws.findCerts(username, true);

            for (Certificate encodedCA : certifList) {  

                CA = decodeCertificate(encodedCA.getCertificateData());
                
                organization = getOrganizationName(CA);
                
                // if CA is valid, increment in map
                if (isCaValidAtDay(CA, format.parse(p.getProperty("CAvalidAtDate")))) { 
                    int count = validCAs.containsKey(organization) ? validCAs.get(organization) : 0;
                    validCAs.put(organization, count + 1);                
                }
            }
        }
        
        // print results
        System.out.println("Number of valid CA at " + p.getProperty("CAvalidAtDate") + " is:");
        for (Map.Entry entry : validCAs.entrySet()) {
            System.out.println(entry.getValue() + "\t" + entry.getKey() );
        }
        
    }
 
    /**
     * @param cert - certificate to parse
     * @return organization name parsed from DN
     * @throws InvalidNameException 
     */
    private String getOrganizationName(X509Certificate cert) throws InvalidNameException {
        String dn = (String)cert.getSubjectDN().getName();
                
        LdapName ldapDN = new LdapName(dn);                
        List<Rdn> listRdn = ldapDN.getRdns();

        return (String) listRdn.get(2).getValue();
    }
    
    /** 
     * @param source - encoded certificate
     * @return decoded generated certificate
     * @throws CertificateException 
     */
    private X509Certificate decodeCertificate(byte[] source) throws CertificateException {       
           
        source = DatatypeConverter.parseBase64Binary(new String(source, Charset.forName("UTF-8")));
        
        return (X509Certificate)certFactory.generateCertificate(new ByteArrayInputStream(source));
    }    
    
    
    /** 
     * @param cert - certificate with its validity
     * @param date - date to compare
     * @return if certificate is valid at given date
     */
    private boolean isCaValidAtDay(X509Certificate cert, Date date) {
        
        return date.after(cert.getNotBefore()) && date.before(cert.getNotAfter());
    }
    
    /**
     * only for printing data from UserDataVOWS
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

