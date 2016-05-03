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
import java.security.cert.X509Certificate;
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
    
    private HashSet<X509Certificate> LDAP_data = new HashSet<>();
    private HashSet<X509Certificate> DIGICERT_data = new HashSet<>();
        
    
    public void conputeDifference() {
        
        try {
            initGeneratedData("data.properties", "dataLdap.properties");

            System.out.println(ANSI_PURPLE + "how much digicert contains ldap");
            X_contains_Y(DIGICERT_data, LDAP_data);
            
            System.out.println(ANSI_BLUE + "how much ldap contains digicert");
            X_contains_Y(LDAP_data, DIGICERT_data);
            
        } catch (InvalidNameException ex) {
            Logger.getLogger(Diff.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    /**
     * computes how much data from dataX is also in dataY
     * 
     * @param dataX pro vsechna tato data
     * @param dataY toto neobsahuje dataX
     * @throws InvalidNameException 
     */
    private void X_contains_Y(HashSet<X509Certificate> dataX, HashSet<X509Certificate> dataY) throws InvalidNameException {
        int count = 0;
        int xContainsY = 0;
        HashMap<String, Integer> missing = new HashMap<>();
        
        for (X509Certificate cert : dataX) {

            if (!dataY.contains(cert)) {
//                System.out.println("\t\t\t\t\t>> "+count+" <<");
                count++;

                String dn = cert.getSubjectDN().getName();
                LdapName ldapDN = new LdapName(dn);
                List<Rdn> listRdn = ldapDN.getRdns();

                String o = null;                    

                for (Rdn rdn : listRdn) {
//                    System.out.println(rdn);
                    if ("O".equals(rdn.getType())) {
                        o = (String) rdn.getValue();
                    }
                }

                int value = 0;
                if (missing.get(o) != null) {
                    value = missing.get(o);
                }
                missing.put(o, value+1);

            } else {
                xContainsY++;
            }
        }
        
        System.out.println("contains" + xContainsY + "\t("+count+")" + "\tsize:  " + dataX.size());
        System.out.println(missing);
        System.out.println(getJSON(missing)+"\n");
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
    
}
