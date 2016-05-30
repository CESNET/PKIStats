/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cesnet.pki;

import com.cesnet.pki.ejbca.Connector;
import static com.cesnet.pki.ejbca.Connector.ANSI_GREEN;
import static com.cesnet.pki.ejbca.Connector.ANSI_RED;
import static com.cesnet.pki.ejbca.Connector.ANSI_BLUE;
import static com.cesnet.pki.ejbca.Connector.ANSI_PURPLE;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.security.Principal;
import java.security.cert.X509Certificate;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.naming.InvalidNameException;
import javax.naming.ldap.LdapName;
import javax.naming.ldap.Rdn;

/**
 *
 * @author jana
 */
public class Diff extends Connector {
    
    private int LIMIT = 5;
    
    private boolean printDetails = false;
    
    private HashSet<X509Certificate> LDAP_data = new HashSet<>();
    private HashSet<X509Certificate> DIGICERT_data = new HashSet<>();
    
    private HashMap<String, List<X509Certificate>> issuerDNs;
    
    public void computeDifference(String type) {
        
        initGeneratedData("data.properties", "dataLdap.properties");
        
        try {
            System.out.println(ANSI_PURPLE + "how much DIGICERT contains ldap");
            System.out.println(ANSI_PURPLE + "===============================");
            issuerDNs = new HashMap<>();
            
            clasify(DIGICERT_data, LDAP_data, type);
            
            print(issuerDNs, LIMIT);
            System.out.println(ANSI_PURPLE + "===============================");
                        
            System.out.println(ANSI_BLUE + "how much LDAP contains digicert");
            System.out.println(ANSI_BLUE + "===============================");
            issuerDNs = new HashMap<>();
            
            clasify(LDAP_data, DIGICERT_data, type);
            
            print(issuerDNs, LIMIT);
            System.out.println(ANSI_BLUE + "===============================");
        } catch (InvalidNameException ex) {
            Logger.getLogger(Diff.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    /**
     * computes how much data from dataX is also in dataY
     * 
     * @param dataX data ktera se prochazi
     * @param dataY data, ktera chybi v dataX
     * @throws InvalidNameException if a syntax violation is detected.
     */
    private void X_contains_Y(HashSet<X509Certificate> dataX, HashSet<X509Certificate> dataY) throws InvalidNameException {
        int extraCount = 0;
        int xContainsY = 0;
        HashMap<String, Integer> missing = new HashMap<>();
        
        for (X509Certificate cert : dataX) {
            
            if (dataY.contains(cert)) {
                xContainsY++;
            } else {
                extraCount++;
                
                if (printDetails) {System.out.println("\n\t"+extraCount + ".");}                
                if (printDetails) {System.out.println("====SERIAL NUMBER====\n"+cert.getSerialNumber());}
                
                // organization name
                String o = getAttribute("O", cert.getSubjectDN());
                int value = 0;
                if (missing.get(o) != null) {
                    value = missing.get(o);
                }
                missing.put(o, value+1);
                
                // ISSUER DN                
                if (printDetails) {System.out.println("=====ISSUER DN=====");}
                if (printDetails) {printAllAttributes(cert.getIssuerDN());}
                String cn = getAttribute("CN", cert.getIssuerDN());
                
                List<X509Certificate> certs = new ArrayList<>();
                
                if (issuerDNs.get(cn) != null) {
                    certs = issuerDNs.get(cn);
                }
                certs.add(cert);
                issuerDNs.put(cn, certs);   
                
                // SUBJECT DN   
                if (printDetails) {System.out.println("=====SUBJECT DN=====");}
                if (printDetails) {printAllAttributes(cert.getSubjectDN());}                
            }
        }
        
        System.out.println("contains\t" + xContainsY + "\t extra ("+extraCount+")" + "\tsize:  " + dataX.size());
        if (printDetails) {System.out.println(missing);}
        System.out.println(getJSON(missing)+"\n");
        
    }
    
    /**
     * computes how much data from dataX is also in dataY
     * 
     * @param dataX data ktera se prochazi
     * @param dataY data, ktera chybi v dataX
     * @throws InvalidNameException if a syntax violation is detected.
     */
    private void clasifyType(HashSet<X509Certificate> dataX, HashSet<X509Certificate> dataY, Boolean isClient) throws InvalidNameException {
        int extraCount = 0;
        int xContainsY = 0;
        int dataSize = 0;
        
        HashMap<String, Integer> missing = new HashMap<>();
        
        for (X509Certificate cert : dataX) {
                        
            String cn = getAttribute("CN", cert.getIssuerDN());
            
            // distinguish whether the type of certificate is client or server
            if (isClient==cn.contains("Personal")) {
                dataSize++;
                if (dataY.contains(cert)) {
                    xContainsY++;
                } else {
                    extraCount++;
                    
                    // find the organization name                   
                    String o = getAttribute("O", cert.getIssuerDN());                    
                    
                    // add to map
                    int value = 0;
                    if (missing.get(o) != null) {
                        value = missing.get(o);
                    }
                    missing.put(o, value+1);
                                        
                    // ISSUER DN
                    cn = getAttribute("CN", cert.getIssuerDN());
                    
                    List<X509Certificate> certs = new ArrayList<>();
                    if (issuerDNs.get(cn) != null) {
                        certs = issuerDNs.get(cn);
                    }
                    certs.add(cert);
                    issuerDNs.put(cn, certs);  
                    }
            } 
        }
        
        System.out.println("contains\t" + xContainsY + "\t extra ("+extraCount+")" + "\tsize:  " + dataSize);
        System.out.println(missing);
        System.out.println(getJSON(missing));
    }
    
    /**
     * init global variables
     */
    private void initGeneratedData(String digicertFileName, String ldapFileName) {
        
        DIGICERT_data = load(digicertFileName);
        LDAP_data = load(ldapFileName);
    }

    /**
     * load generated data of organization ids and validation dates
     * 
     * @param ldapFileName the file to be opened for reading.
     * @return generated data if exists. Else returns new empty HashMap
     */
    private HashSet<X509Certificate> load(String fileName) {
        
        HashSet<X509Certificate> data = new HashSet<>();
        HashMap<Integer, CertificateData> preparedData = new HashMap<>();
        
        try (ObjectInputStream ois = new ObjectInputStream(new FileInputStream(fileName))) {
            Object readObject = ois.readObject();
            if(readObject != null) {
                if (readObject instanceof HashSet) {
                data.addAll((Collection<? extends X509Certificate>) readObject);
                } else if (readObject instanceof HashMap) {
                    preparedData.putAll((Map<? extends Integer, ? extends CertificateData>) readObject);
                    
                    for (Map.Entry<Integer, CertificateData> entry : preparedData.entrySet()) {
                        data.add(entry.getValue().certificate);
                    }
                }
            }
            System.out.println(ANSI_GREEN + "Great :) Data already exist. The size is " + data.size());
        
        } catch (IOException | ClassNotFoundException e) {
            // data do not exist yet
            System.out.println(ANSI_RED + "Data do not exist yet...");
        }
        
        return data;
    }

    private void print(HashMap<String, List<X509Certificate>> map, int maximum) {
        
        for (Map.Entry<String, List<X509Certificate>> entry : map.entrySet()) {
        
            System.out.println(ANSI_YELLOW+"    "+entry.getKey() + "\t\t(" +entry.getValue().size()+")");
            List<X509Certificate> lc = entry.getValue();

            for (int i = 0; i< lc.size() ; i++) {
                if (i >= maximum) {
                    System.out.println("  ...and " + (lc.size()-maximum) + " more");
                    break;
                }
                X509Certificate cc = lc.get(i);
                System.out.println(ANSI_YELLOW + (i+1) + ".\t" + ANSI_RESET + cc.getSerialNumber() + "\t" + cc.getSubjectDN());
            }
        }
    }

    private String getAttribute(String attribute, Principal principal) throws InvalidNameException {
        String dn = principal.getName();
        LdapName ldapDN = new LdapName(dn);
        List<Rdn> listRdns = ldapDN.getRdns();

        String val = null;

        for (Rdn rdn : listRdns) {
            if (attribute.equals("all")) {
                if (printDetails) {System.out.println(rdn);}
            } else if (attribute.equals(rdn.getType())) {
                val = (String) rdn.getValue();
            }
        }
        return val;
    }

    private void printAllAttributes(Principal principal) throws InvalidNameException {
        String dn = principal.getName();
        LdapName ldapDN = new LdapName(dn);
        List<Rdn> listRdns = ldapDN.getRdns();

        for (Rdn rdn : listRdns) {
            System.out.println(rdn);            
        }
    }

    private void clasify(HashSet<X509Certificate> dataX, HashSet<X509Certificate> dataY, String type) throws InvalidNameException {
        switch (type) {
            case "server":
                clasifyType(dataX, dataY, false);
                break;
            case "client":
                clasifyType(dataX, dataY, true);
                break;
            case "all":
                X_contains_Y(dataX, dataY);
                break;
            default:
                System.out.println("wrong input (allowed only 'server', 'client' or 'all'");
                break;                
        }
    }

}
