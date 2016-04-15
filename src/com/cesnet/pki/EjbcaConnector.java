package com.cesnet.pki;

import com.cesnet.pki.ejbca.Connector;
import java.net.MalformedURLException;
import java.net.URL;
import java.nio.charset.Charset;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.InvalidNameException;
import javax.xml.bind.DatatypeConverter;
import javax.xml.namespace.QName;
import javax.xml.ws.Service;
import org.ejbca.core.protocol.ws.AuthorizationDeniedException_Exception;
import org.ejbca.core.protocol.ws.CADoesntExistsException_Exception;
import org.ejbca.core.protocol.ws.Certificate;
import org.ejbca.core.protocol.ws.EjbcaException_Exception;
import org.ejbca.core.protocol.ws.EjbcaWS;
import org.ejbca.core.protocol.ws.IllegalQueryException_Exception;
import org.ejbca.core.protocol.ws.UserDataVOWS;
import org.ejbca.core.protocol.ws.UserMatch;

/**
 *
 * @author jana
 */
public class EjbcaConnector extends Connector {

    private final String ejbcaSection = "ejbca";    

    private final int MATCH_TYPE_BEGINSWITH = 1;
    private final int MATCH_WITH_USERNAME = 0;    
    private final int EJBCA_MAX_RETURN_VALUE = 100;
    private final int NOT_REVOKED = -1;

    private final String characters = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.-@";
    private final HashSet<String> ExcludeOrgs = new HashSet<>();
    private final HashSet<String> ExcludeUsers = new HashSet<>();
    private final HashSet<UserDataVOWS> UserDataList = new HashSet<>();
    private EjbcaWS ejbcaws;

    @Override
    public void generateValidCAs() {
        super.generateValidCAs();

        try {
            // init
            ExcludeOrgs.addAll(Arrays.asList(properties.get(ejbcaSection,"ExcludeOrgs").split(",")));
            ExcludeUsers.addAll(Arrays.asList(properties.get(ejbcaSection,"ExcludeUsers").split(",")));

            searchValidUsername();

            countValidCAs(); 


        } catch (CertificateException | AuthorizationDeniedException_Exception | EjbcaException_Exception | IllegalQueryException_Exception | ParseException | InvalidNameException | CADoesntExistsException_Exception ex) {
            Logger.getLogger(Connector.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * calls method for traversing all records and save rest 
     * 
     * @throws AuthorizationDeniedException_Exception an operation was attempted for which the user was not authorized
     * @throws EjbcaException_Exception an error caused by ejbca
     * @throws IllegalQueryException_Exception if a given query was not legal 
     * @throws CertificateException This exception indicates one of a variety of certificate problems   
     * @throws ParseException if the beginning of the specified string cannot be parsed.
     * @throws InvalidNameException This exception indicates that the name being specified does not conform to the naming syntax of a naming system
     * @throws CADoesntExistsException_Exception if CA does not exists
     */
    private void searchValidUsername() throws AuthorizationDeniedException_Exception, EjbcaException_Exception, IllegalQueryException_Exception, CertificateException, ParseException, InvalidNameException, CADoesntExistsException_Exception {

        UserDataList.addAll(searchValidUsernameBy100(new StringBuilder(), new ArrayList<>()));
    }

    /**
     * iterates records by alphabet and save results to UserDataList (ejbcaws.findUser returns max 100 records)
     * 
     * @throws AuthorizationDeniedException_Exception an operation was attempted for which the user was not authorized
     * @throws EjbcaException_Exception an error caused by ejbca
     * @throws IllegalQueryException_Exception if a given query was not legal 
     * @throws CertificateException This exception indicates one of a variety of certificate problems
     * @throws ParseException if the beginning of the specified string cannot be parsed.
     * @throws InvalidNameException This exception indicates that the name being specified does not conform to the naming syntax of a naming system
     * @throws CADoesntExistsException_Exception if CA does not exists
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
     * @throws MalformedURLException if no protocol is specified, or an unknown protocol is found, or spec is null 
     */
    @Override
    protected void connect() throws MalformedURLException {

        System.setProperty("javax.net.ssl.keyStore", properties.get(ejbcaSection, "keyStore"));
        System.setProperty("javax.net.ssl.keyStorePassword", properties.get(ejbcaSection, "keyStorePassword"));

        QName qname = new QName(properties.get(ejbcaSection, "serviceURI"), properties.get(ejbcaSection, "serviceLocalPart"));
        URL url = new URL(properties.get(ejbcaSection, "url"));
        Service service = Service.create(url, qname);

        ejbcaws = (EjbcaWS) service.getPort(new QName(properties.get(ejbcaSection, "portURI"), properties.get(ejbcaSection, "portLocalPart")), EjbcaWS.class);
    }

    /**
     * sets up UserDataList by match from ini file
     * 
     * @return size of created UserDataList
     * @throws AuthorizationDeniedException_Exception an operation was attempted for which the user was not authorized
     * @throws EjbcaException_Exception an error caused by ejbca
     * @throws IllegalQueryException_Exception if a given query was not legal 
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
     * @param matchValue The matchvalue to set for finding users
     * @return size of created UserDataList
     * @throws AuthorizationDeniedException_Exception an operation was attempted for which the user was not authorized
     * @throws EjbcaException_Exception an error caused by ejbca
     * @throws IllegalQueryException_Exception if a given query was not legal 
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
     * @throws CertificateException This exception indicates one of a variety of certificate problems
     * @throws ParseException if the beginning of the specified string cannot be parsed.
     * @throws AuthorizationDeniedException_Exception an operation was attempted for which the user was not authorized
     * @throws EjbcaException_Exception an error caused by ejbca
     * @throws InvalidNameException This exception indicates that the name being specified does not conform to the naming syntax of a naming system
     * @throws CADoesntExistsException_Exception if CA does not exists
     */
    @Override
    protected void countValidCAs() throws CertificateException, ParseException, AuthorizationDeniedException_Exception, EjbcaException_Exception, InvalidNameException, CADoesntExistsException_Exception {

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

            // findCerts(String username, boolean onlyValid)
            List<Certificate> certifList = ejbcaws.findCerts(username, false);

            for (Certificate encodedCA : certifList) {

                byte[] sourceBase64 = encodedCA.getCertificateData();
                byte[] source = DatatypeConverter.parseBase64Binary(new String(sourceBase64, Charset.forName("UTF-8")));
                
                CA = decodeCertificate(source);

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
}