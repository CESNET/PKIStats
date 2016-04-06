/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cesnet.pki;

import com.cesnet.pki.ejbca.Connector;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.net.UnknownServiceException;
import java.nio.charset.Charset;
import java.security.cert.CertificateException;
import java.sql.Date;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.NamingException;
import javax.xml.bind.DatatypeConverter;
import org.bouncycastle.cert.X509CertificateHolder;
import org.bouncycastle.cms.CMSException;
import org.bouncycastle.cms.CMSSignedData;
import org.bouncycastle.util.Store;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 *
 * @author jana
 */
public class DigicertConnector extends Connector {
    
    private final String digicertSection = "digicert";    
    
    private HashMap<Integer, String> organizationId_has_ApiKey;
    private HashMap<Integer, String> organizationId_has_name = new HashMap<>();    
    private HashMap<Integer, Integer> organization_has_numOfCAs = new HashMap<>();
    
    private final int LIMIT = 1000;
    private final String key = properties.get(digicertSection,"apiKey");
        
    private final String urlBase = "https://www.digicert.com/services/v2/";
    
    private final String urlListChildContainers = "container/"+ properties.get(digicertSection,"rootId") +"/children";
     
    private String date = properties.get("ejbca","CAvalidAtDate");
    
    @Override  
    public void generateValidCAs() {
        super.generateValidCAs();
        
        try {
            
            LdapConnector lc = new LdapConnector();
            organizationId_has_ApiKey = lc.findApiKeysForDigicert();
            
            getOrderId(0);
            
            printNumberOfCAs();
            
        } catch (MalformedURLException | CMSException | ParseException ex) {
            Logger.getLogger(DigicertConnector.class.getName()).log(Level.SEVERE, null, ex);
        } catch (JSONException | IOException | NamingException ex) {
            Logger.getLogger(DigicertConnector.class.getName()).log(Level.SEVERE, null, ex);
        }
        
    }    

    private JSONObject callDigicert(String urlSuffix, int offset) throws MalformedURLException, IOException, JSONException {
        URL url = new URL(urlBase + urlSuffix + "?offset=" + offset);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        
        conn.setRequestMethod("GET");            
        conn.setRequestProperty("X-DC-DEVKEY", key);
        conn.setRequestProperty("Accept", "application/json");
        conn.setDoOutput(true);
        
        BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));           
             
        String rawJson = reader.readLine();
        
        return new JSONObject(rawJson);           
    }
    

    /**
     * call digicert by specific url with given api key
     * 
     * @param offset positive integer identifying the number of records to skip
     * @throws MalformedURLException if no protocol is specified, or an unknown protocol is found, or spec is null
     * @throws ProtocolException if the method cannot be reset or if the requested method isn't valid for HTTP
     * @throes SecurityException if a security manager is set and the method is "TRACE", but the "allowHttpTrace" NetPermission is not granted
     * @throws IllegalArgumentException if Input-buffer size is less or equal zero
     * @throws UnsupportedEncodingException if the named charset is not supported
     * @throws IOException if an I/O error occurs while creating the input stream
     * @throws UnknownServiceException if the protocol does not support input
     */
    private String callDigicert(String urlSuffix, String apiKey) throws IOException, UnknownServiceException, IllegalArgumentException,MalformedURLException,ProtocolException,SecurityException, UnsupportedEncodingException {
        
        StringBuilder builder = new StringBuilder();
        String currentLine;
        
        URL url = new URL(urlBase + urlSuffix);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();

        conn.setRequestMethod("GET");            
        conn.setRequestProperty("X-DC-DEVKEY", apiKey);
        conn.setRequestProperty("Accept", "*/*");
        conn.setDoOutput(true);
        
        BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));           
        
        currentLine = reader.readLine(); // we do not want first line (-----BEGIN PKCS7-----)
        
        while((currentLine = reader.readLine()) != null) {
            builder.append(currentLine);
        }

        builder.delete(builder.length()-19, builder.length()); // neather -----END PKCS7-----
        
        return builder.toString();
    }

    /**
     * @param offset positive integer identifying the number of records to skip
     * @throws IOException if an I/O error occurs while creating the input stream
     * @throws JSONException if the key is not found or if the value is not a JSONArray.
     */
    private void getOrderId(int offset) throws JSONException, IOException, CMSException, ParseException {
        
        JSONObject orders = callDigicert("order/certificate", offset);
        
        JSONArray jsonArray = orders.getJSONArray("orders");
        JSONObject pageInfo = (JSONObject)orders.get("page");

        for(int i=0; i<jsonArray.length(); i++) {
            JSONObject order = (JSONObject) jsonArray.get(i);
            
            String status = order.getString("status");

            if(status.equals("issued")) {
                            
                JSONObject certificate = (JSONObject)order.get("certificate");
                int certificateId = certificate.getInt("id");
                
                JSONObject container = (JSONObject)order.get("container");
                int parentId = container.getInt("id");
                
                if (organizationId_has_name.get(parentId)==null) {
                    organizationId_has_name.put(parentId, container.getString("name"));
                }
                
                if (organizationId_has_ApiKey.get(parentId)!=null) { // because of Univerzita Jana Evangelisty Purkyne
                
                    decodeCA(certificateId, parentId, organizationId_has_ApiKey.get(parentId));
                }
                
/*
//              CODE WITHOUT ACCESSING CERTIFICATE
                
                JSONObject container = (JSONObject)order.get("container");
                int parentId = container.getInt("id");

                JSONObject certificate = (JSONObject)order.get("certificate");
                String validTill = certificate.getString("valid_till");
                String dateCreated = order.getString("date_created").substring(0,10);

                int certificateId = certificate.getInt("id");
                
                if (organizationId_has_name.get(parentId)==null) {
                    organizationId_has_name.put(parentId, container.getString("name"));
                }
                
                
                if (format.parse(validTill).after(format.parse(date)) && format.parse(dateCreated).before(format.parse(date))) {
                    
                    count++;
                    
                    int value = 0;
                    if (organization_has_numOfCAs.get(parentId) != null) {                
                        value = organization_has_numOfCAs.get(parentId);                
                    }
                    organization_has_numOfCAs.put(parentId, value+1);                    
                }
*/                
            }
        }
        
        int countResults = pageInfo.getInt("total");
        offset+=LIMIT;
        
        if (countResults > offset) {
            getOrderId(offset);
        }    
    }

    /**
     * prints results
     */
    private void printNumberOfCAs() {
        for (Map.Entry<Integer, Integer> entry : organization_has_numOfCAs.entrySet()) {            
            
            System.out.println(entry.getValue() + "\t" + organizationId_has_name.get(entry.getKey()));
        }
    }

    /**
     * 
     * @param certificateId
     * @param parentId
     * @param apiKey
     * @throws MalformedURLException if no protocol is specified, or an unknown protocol is found, or spec is null
     * @throws ProtocolException if the method cannot be reset or if the requested method isn't valid for HTTP
     * @throws IllegalArgumentException if Input-buffer size is less or equal zero
     * @throws UnsupportedEncodingException if the named charset is not supported
     * @throws IOException if an I/O error occurs while creating the input stream
     * @throws UnknownServiceException if the protocol does not support input
     * @throws ParseException if the beginning of the specified string cannot be parsed
     * @throws CMSException
     */
    private void decodeCA(int certificateId, int parentId, String apiKey) throws MalformedURLException, ProtocolException, IllegalArgumentException, UnsupportedEncodingException, IOException, UnknownServiceException, CMSException, ParseException {        
        
        String certificate = callDigicert("certificate/" + certificateId + "/download/format/p7b", apiKey);
                      
        byte[] source = DatatypeConverter.parseBase64Binary(new String(certificate.getBytes(), Charset.forName("UTF-8")));
                
        CMSSignedData data = new CMSSignedData(source);
                
        Store store = data.getCertificates();
        
        ArrayList<X509CertificateHolder> listCertData = new ArrayList(store.getMatches(null));
        
        for (X509CertificateHolder holder : listCertData) {
                        
            if (holder.isValidOn(format.parse(date))) {
                
                int value = 0;
                if (organization_has_numOfCAs.get(parentId) != null) {                
                    value = organization_has_numOfCAs.get(parentId);                
                }
                organization_has_numOfCAs.put(parentId, value+1);
            }
        }
    }
    
}
