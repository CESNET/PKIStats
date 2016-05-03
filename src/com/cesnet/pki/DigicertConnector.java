/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cesnet.pki;

import com.cesnet.pki.ejbca.Connector;
import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.net.UnknownServiceException;
import java.nio.charset.Charset;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.TreeMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.NamingException;
import javax.xml.bind.DatatypeConverter;
import org.bouncycastle.cert.X509CertificateHolder;
import org.bouncycastle.cert.jcajce.JcaX509CertificateConverter;
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
    private final String urlBase = "https://www.digicert.com/services/v2/";
    private final int API_KEY = 0;
    private final int ORG_NAME = 1;
    private final int ORG_CS_NAME = 2;
    private final int ORG_EN_NAME = 3;
    
    private final int LIMIT = 1000;
    private final String key = properties.get(digicertSection,"apiKey");

    private HashMap<Integer, String[]> parentInfo;
    private HashMap<Integer, Integer> parentId_has_numOfCerts = new HashMap<>();
    
    private HashMap<Integer, CertificateData> cache = new HashMap<>();

    @Override  
    public void generateValidCerts() {
        super.generateValidCerts();
        
        // choose json language
        int lang = ORG_EN_NAME;
        
        try {
            // get api keys to all organizations
            LdapConnector lc = new LdapConnector();
            parentInfo = lc.findApiKeysForDigicert();            
                    
            // init
            cache = loadGeneratedData();
            
            validCertificates = new TreeMap<>();
            
            // count valid certificates
            int offset = 0;
            countValidCerts(offset);
            
            for (Map.Entry<Integer, Integer> entry : parentId_has_numOfCerts.entrySet()) {

                int parentId = entry.getKey();
                String organizationName = parentInfo.get(parentId)[lang];

                validCertificates.put(organizationName, entry.getValue());
            }
    
            // save cache
            saveGeneratedData(cache);
        
        } catch ( IOException | NamingException | JSONException | IllegalArgumentException | CMSException | ParseException | CertificateException ex) {
            Logger.getLogger(DigicertConnector.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
        
    /**
     * Calls digicert by specific url with given offset
     * 
     * @param urlSuffix remaining String to parse as a URL (url starts with https://www.digicert.com/services/v2/)
     * @param offset positive integer identifying the number of records to skip. If negative or equal zero offset is ignored.
     * @return JSONObject of requested data
     * @throws MalformedURLException if no protocol is specified, or an unknown protocol is found, or spec is null
     * @throws IOException if an I/O error occurs while creating the input stream
     * @throws JSONException if there is a syntax error in the source string or a duplicated key
     */
    private JSONObject callDigicert(String urlSuffix, int offset) throws MalformedURLException, IOException, JSONException {
        
        String urlAdress = urlBase + urlSuffix;        
        
        if (offset > 0) {
            urlAdress += "?offset=" + offset;
        }        
        
        URL url = new URL(urlAdress);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();

        conn.setRequestMethod("GET");
        conn.setRequestProperty("X-DC-DEVKEY", key);
        conn.setRequestProperty("Accept", "application/json");
        conn.setDoOutput(true);

        String rawJson;
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"))) {
            rawJson = reader.readLine();
        }
        return new JSONObject(rawJson);
    }
    
    /**
     * Calls digicert by specific url with given api key
     * 
     * @param urlSuffix the String to parse as a URL
     * @param apiKey api key
     * @return String of certificate base64 encoded data
     * @throws MalformedURLException if no protocol is specified, or an unknown protocol is found, or spec is null
     * @throws ProtocolException if the method cannot be reset or if the requested method isn't valid for HTTP
     * @throes SecurityException if a security manager is set and the method is "TRACE", but the "allowHttpTrace" NetPermission is not granted
     * @throws IllegalArgumentException if Input-buffer size is less or equal zero
     * @throws UnsupportedEncodingException if the named charset is not supported
     * @throws IOException if an I/O error occurs while creating the input stream
     * @throws UnknownServiceException if the protocol does not support input
     */    
    private String callDigicert(String urlSuffix, String apiKey) throws MalformedURLException, ProtocolException, SecurityException, IllegalArgumentException, UnsupportedEncodingException, IOException, UnknownServiceException {

        StringBuilder builder = new StringBuilder();
        String currentLine;

        URL url = new URL(urlBase + urlSuffix);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();

        conn.setRequestMethod("GET");
        conn.setRequestProperty("X-DC-DEVKEY", apiKey);
        conn.setRequestProperty("Accept", "*/*");
        conn.setDoOutput(true);

        try (BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"))) {
            while((currentLine = reader.readLine()) != null) {
                builder.append(currentLine);
            }
        } catch(Exception e) {
            System.out.println("apiKey\t" + apiKey);
            System.out.println(e.getMessage());
            return null;
        }
        
        builder.delete(0, "-----BEGIN PKCS7-----".length()); // we do not want first line (-----BEGIN PKCS7-----)
        builder.delete(builder.length()-("-----END PKCS7-----".length()), builder.length()); // neather -----END PKCS7-----

        return builder.toString();
    }

    /**
     * @param offset positive integer identifying the number of records to skip
     * @throws JSONException if the key is not found or if the value is not a JSONArray.
     * @throws IOException if an I/O error occurs while creating the input stream
     * @throws CMSException
     * @throws ParseException if the beginning of the specified string cannot be parsed
     * @throws MalformedURLException if no protocol is specified, or an unknown protocol is found, or spec is null
     * @throws ProtocolException if the method cannot be reset or if the requested method isn't valid for HTTP
     * @throws IllegalArgumentException if Input-buffer size is less or equal zero
     * @throws UnsupportedEncodingException if the named charset is not supported
     * @throws UnknownServiceException if the protocol does not support input
     * @throws CertificateException this exception indicates one of a variety of certificate problems
     */
    private void countValidCerts(int offset) throws JSONException, IOException, CMSException, ParseException, MalformedURLException, ProtocolException, IllegalArgumentException, UnsupportedEncodingException, UnknownServiceException, CertificateException {
       
        JSONObject orders = callDigicert("order/certificate", offset);

        JSONArray jsonArray = orders.getJSONArray("orders");
        JSONObject pageInfo = (JSONObject)orders.get("page");

        System.out.println(pageInfo);

        for(int i=0; i<jsonArray.length(); i++) {
            JSONObject order = (JSONObject) jsonArray.get(i);

            String status = order.getString("status");

            // if status is one of processing, issued, revoked, canceled or needs_approval
            if(!status.equals("rejected") && !status.equals("needs_approval") && !status.equals("pending")) {
    
                // if the result is in the cache
                if (cache.containsKey(order.getInt("id"))) {                     
                    
                    JSONObject container = order.getJSONObject("container");
                    int parentId = container.getInt("id");
                  
                    // get certificate validation
                    CertificateData data = cache.get(order.getInt("id"));                    
                    
                    if (isCertValidAtDay(data.certificate, referenceDate)) {
                        
                        int value = 0;
                        if (parentId_has_numOfCerts.get(parentId) != null) {
                            value = parentId_has_numOfCerts.get(parentId);
                        }
                        parentId_has_numOfCerts.put(parentId, value+1);
                    }
                    
                // compute result
                } else {
                               
                    JSONObject certificate = order.getJSONObject("certificate");
                    int certificateId = certificate.getInt("id");

                    JSONObject container = order.getJSONObject("container");
                    int parentId = container.getInt("id");
                    
                    if (parentInfo.containsKey(parentId)) { // because of CESNET NREN
                        decodeCertificate(order.getInt("id"), certificateId, parentId, container.getString("name"), parentInfo.get(parentId)[API_KEY]);
                    } else {
                        System.out.println("ldap doesn't know id: " + parentId);
                        System.out.println(order);
                    }
                }
            }
        }

        int countResults = pageInfo.getInt("total");
        offset+=LIMIT;
        
        if (countResults > offset) {
            countValidCerts(offset);
        }        
    }

    /**
     * downloads and decodes given certificate, updates HashMap of results
     * 
     * @param certificateId certificate id
     * @param parentId id of parent organization
     * @param apiKey api key to access downloading certificate
     * @throws MalformedURLException if no protocol is specified, or an unknown protocol is found, or spec is null
     * @throws ProtocolException if the method cannot be reset or if the requested method isn't valid for HTTP
     * @throws IllegalArgumentException if Input-buffer size is less or equal zero
     * @throws UnsupportedEncodingException if the named charset is not supported
     * @throws IOException if an I/O error occurs while creating the input stream
     * @throws UnknownServiceException if the protocol does not support input
     * @throws ParseException if the beginning of the specified string cannot be parsed
     * @throws CMSException master exception type for all exceptions caused in OpenCms
     * @throws CertificateException this exception indicates one of a variety of certificate problems
     */
    private void decodeCertificate(int orderId, int certificateId, int parentId, String parentName, String apiKey) throws MalformedURLException, ProtocolException, IllegalArgumentException, UnsupportedEncodingException, IOException, UnknownServiceException, CMSException, ParseException, CertificateException, JSONException {
        
        String certificate = callDigicert("certificate/" + certificateId + "/download/format/p7b", apiKey);

        if (certificate == null) {
            System.out.println("certificate is null");
            System.out.println("orderId:\t"+ orderId + "\tcertificateId:\t" + certificateId + "\tparentId:\t" + parentId + "\tparentName:\t"+parentName + "\tApiKey:\t"+apiKey);
        } else {
            
            byte[] source = DatatypeConverter.parseBase64Binary(new String(certificate.getBytes(Charset.forName("UTF-8"))));
            CMSSignedData signature = new CMSSignedData(source);
            Store cs = signature.getCertificates();

            ArrayList<X509CertificateHolder> listCertData = new ArrayList(cs.getMatches(null));

            // we want only first certificate
            X509Certificate cert = new JcaX509CertificateConverter().getCertificate(listCertData.get(0));

            CertificateData data = new CertificateData(cert, orderId, parentId, parentName);

            // store found certificate in HashMap
            cache.put(orderId, data);

            if (isCertValidAtDay(cert, referenceDate)) {
                int value = 0;
                if (parentId_has_numOfCerts.get(parentId) != null) {
                    value = parentId_has_numOfCerts.get(parentId);
                }
                parentId_has_numOfCerts.put(parentId, value+1);
            }
        }
    }
    
    /**
     * saves once generated data of organization ids and validation dates
     * 
     * @param data to by saved
     * @throws IOException if an I/O error occurs while writing stream header
     */
    private void saveGeneratedData(HashMap<Integer, CertificateData> data) throws IOException {
        try (ObjectOutputStream oos = new ObjectOutputStream (new FileOutputStream("data.properties"))) {
            oos.writeObject(data);
        }
    }
    
    /**
     * load generated data of organization ids and validation dates
     * 
     * @return generated data if exists. Else returns new empty HashMap
     */
    private HashMap<Integer, CertificateData> loadGeneratedData() {
        HashMap<Integer, CertificateData> data = new HashMap<>();
        
        try (ObjectInputStream ois = new ObjectInputStream(new FileInputStream("data.properties"))) {
            Object readMap = ois.readObject();
            if(readMap != null && readMap instanceof HashMap) {
                data.putAll((Map<? extends Integer, ? extends CertificateData>) readMap);
            }           
        } catch (IOException | ClassNotFoundException e) {
            // data do not exist yet            
            System.out.println(ANSI_RED + "Data do not exist yet...");
        }
        System.out.println(ANSI_GREEN + "Great :) Data already exist. The size is " + data.size());
        
        return data;
    }
}