/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cesnet.pki;

import java.io.Serializable;
import java.security.cert.X509Certificate;

/**
 *
 * @author jana
 */
public class CertificateData implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    X509Certificate certificate;
    int parentId;
    int orderId;
    String parentName;

    CertificateData(X509Certificate cert, int orderId, int parentId, String parentName) {
        this.certificate = cert;
        this.orderId = orderId;
        this.parentId = parentId;
        this.parentName = parentName;        
    }   
}
