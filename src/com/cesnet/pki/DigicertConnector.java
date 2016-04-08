/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cesnet.pki;

import com.cesnet.pki.ejbca.Connector;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
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
import java.util.Scanner;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.InvalidNameException;
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
    
    private HashMap<Integer, String> organizationId_has_ApiKey;
    private HashMap<Integer, String> organizationId_has_name = new HashMap<>(); 
    private HashMap<Integer, Integer> organizationId_has_numOfCAs = new HashMap<>();
    private final int LIMIT = 1000;
    private final String key = properties.get(digicertSection,"apiKey");
        
    private final String urlBase = "https://www.digicert.com/services/v2/";
    
    protected String date = "2016-30-03";//properties.get("ejbca","CAvalidAtDate");
    
    @Override  
    public void generateValidCAs() {
        super.generateValidCAs();        
        
        try {
            
            LdapConnector lc = new LdapConnector();
            organizationId_has_ApiKey = lc.findApiKeysForDigicert();
            
            int offset = 0;            
            getOrderId(offset);
            
            System.out.println(date);   
            
            printNumberOfCAs();
            
            /////////////////
            // create JSON //
            /////////////////
            StringBuilder handmadeJSON = new StringBuilder();
            handmadeJSON.append("{");

            for (Map.Entry<Integer, Integer> entry : organizationId_has_numOfCAs.entrySet()) {         
                handmadeJSON.append("\"").append(organizationId_has_name.get(entry.getKey())).append("\":").append(entry.getValue()).append(",");
            }            
            
            handmadeJSON.deleteCharAt(handmadeJSON.length()-1);
            handmadeJSON.append("}");

            String json = handmadeJSON.toString();

        } catch ( CMSException | ParseException | IllegalArgumentException | CertificateException | JSONException | IOException | NamingException ex) {
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

        builder.delete(builder.length()-("-----END PKCS7-----".length()), builder.length()); // neather -----END PKCS7-----
        
        return builder.toString();
    }

    /**
     * @param offset positive integer identifying the number of records to skip
     * @throws IOException if an I/O error occurs while creating the input stream
     * @throws JSONException if the key is not found or if the value is not a JSONArray.
     */
    private void getOrderId(int offset) throws JSONException, IOException, CMSException, ParseException, MalformedURLException, ProtocolException, IllegalArgumentException, UnsupportedEncodingException, UnknownServiceException, CertificateException {
        
        JSONObject orders = callDigicert("order/certificate", offset);
        
        JSONArray jsonArray = orders.getJSONArray("orders");
        JSONObject pageInfo = (JSONObject)orders.get("page");

        System.out.println(pageInfo);
        
        for(int i=0; i<jsonArray.length(); i++) {
            JSONObject order = (JSONObject) jsonArray.get(i);
            
            String status = order.getString("status");
            
            if(!status.equals("rejected") && !status.equals("needs_approval") && !status.equals("pending")) {
            
                JSONObject certificate = (JSONObject)order.get("certificate");
                int certificateId = certificate.getInt("id");
                
                JSONObject container = (JSONObject)order.get("container");
                int parentId = container.getInt("id");
                
                JSONObject organization = (JSONObject)order.get("organization");
                
                if (organizationId_has_name.get(parentId)==null) {
                    organizationId_has_name.put(parentId, organization.getString("name"));
                }
                
                if (organizationId_has_ApiKey.get(parentId)!=null) { // because of Univerzita Jana Evangelisty Purkyne
                
                    decodeCA(certificateId, parentId, organizationId_has_ApiKey.get(parentId));
                }
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
        for (Map.Entry<Integer, Integer> entry : organizationId_has_numOfCAs.entrySet()) {    //original        
            
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
    private void decodeCA(int certificateId, int parentId, String apiKey) throws MalformedURLException, ProtocolException, IllegalArgumentException, UnsupportedEncodingException, IOException, UnknownServiceException, CMSException, ParseException, CertificateException {        
        
        String certificate = callDigicert("certificate/" + certificateId + "/download/format/p7b", apiKey);
                      
        byte[] source = DatatypeConverter.parseBase64Binary(new String(certificate.getBytes(), Charset.forName("UTF-8")));
        CMSSignedData signature = new CMSSignedData(source);
        Store cs = signature.getCertificates();
        
        ArrayList<X509CertificateHolder> listCertData = new ArrayList(cs.getMatches(null));
        
        for (X509CertificateHolder holder : listCertData) {
               
            X509Certificate CA = new JcaX509CertificateConverter().getCertificate(holder);

            if (isCaValidAtDay(CA, format.parse(date))) {
                int value = 0;
                if (organizationId_has_numOfCAs.get(parentId) != null) {
                    value = organizationId_has_numOfCAs.get(parentId);
                }
                organizationId_has_numOfCAs.put(parentId, value+1);
             }            
        }
    }
    
}