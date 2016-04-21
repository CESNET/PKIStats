<%-- 
    Document   : ldap
    Created on : 21.4.2016, 10:25:57
    Author     : jana
--%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>

        <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
        <script src="//code.jquery.com/jquery-1.10.2.js"></script>
        <script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
        <script src="ssscript.js"></script>
               
        <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css"> 
        <link rel="stylesheet" href="stylesss.css">
        <%@page contentType="text/html" pageEncoding="UTF-8"%>
        <jsp:useBean id="connector" class="com.cesnet.pki.ejbca.Connector" />
                
        <% String date = connector.getDate(); %>
        
        <script>
            var initialDate = '<%=date%>';
            date['Ldap'] = initialDate;
            json['Ldap'] = '{"organizations":[{"name":"Akademie muzickych umeni v Praze","count":"37"},{"name":"Astronomical Institute of the Czech Academy of Sciences","count":"5"},{"name":"BBMRI-ERIC","count":"11"},{"name":"BRAILCOM, o.p.s.","count":"1"},{"name":"Biology Centre CAS","count":"1"},{"name":"Brno University of Technology","count":"33"},{"name":"CESNET","count":"197"},{"name":"CESNET (CESNET)","count":"4"},{"name":"CESNET (CESNET, zajmove sdruzeni pravnickych osob)","count":"5"},{"name":"CESNET, association of legal entities","count":"1"},{"name":"CESNET, zajmove sdruzeni pravnickych osob","count":"98"},{"name":"CVUT (Czech Technical University in Prague)","count":"2"},{"name":"Centre of Administration and Operations of the ASCR, v. v. i.","count":"7"},{"name":"Centrum vyzkumu globalni zmeny AV CR, v. v. i.","count":"6"},{"name":"Ceska zemedelska univerzita v Praze","count":"2"},{"name":"Ceske vysoke uceni technicke v Praze","count":"127"},{"name":"Charles University in Prague","count":"114"},{"name":"Czech Technical University in Prague","count":"202"},{"name":"Czech University of Life Sciences Prague","count":"31"},{"name":"Fakultni nemocnice Hradec Kralove","count":"3"},{"name":"Fakultni nemocnice Ostrava","count":"1"},{"name":"Fakultni nemocnice Plzen","count":"5"},{"name":"Food Research Institute Prague","count":"1"},{"name":"Fyzikalni ustav AV CR, v. v. i.","count":"16"},{"name":"Fyziologicky ustav AV CR, v. v. i.","count":"2"},{"name":"Grantova agentura Ceske republiky","count":"1"},{"name":"Gymnazium Matyase Lercha, Brno, Zizkova 55, prispevkova organizace","count":"2"},{"name":"Gymnazium, Plzen, Mikulasske nam. 23","count":"2"},{"name":"Hospital Jihlava","count":"2"},{"name":"Institute of Chemical Technology Prague","count":"3"},{"name":"Institute of Experimental Botany AS CR, v. v. i.","count":"2"},{"name":"Institute of Molecular Genetics of the ASCR, v. v. i.","count":"11"},{"name":"Institute of Organic Chemistry and Biochemistry AS CR, v.v.i.","count":"4"},{"name":"Institute of Photonics and Electronics of the AS CR, v.v.i.","count":"1"},{"name":"Institute of Physics AS CR","count":"28"},{"name":"Institute of Physics of Materials AS CR, v. v. i.","count":"1"},{"name":"Institute of Physiology CAS","count":"1"},{"name":"Jihoceska univerzita v Ceskych Budejovicich","count":"20"},{"name":"Kerio Technologies s.r.o.","count":"12"},{"name":"Kerio Technologies sro","count":"6"},{"name":"MUP (Metropolitan University Prague)","count":"4"},{"name":"Masaryk University","count":"161"},{"name":"Masarykova univerzita","count":"135"},{"name":"Masarykuv onkologicky ustav","count":"2"},{"name":"Mendel University in Brno","count":"8"},{"name":"Mendelova univerzita v Brne","count":"17"},{"name":"Moravian Library","count":"2"},{"name":"Moravska zemska knihovna v Brne","count":"9"},{"name":"Narodni knihovna Ceske republiky","count":"5"},{"name":"Narodni technicka knihovna","count":"3"},{"name":"Narodni ustav dusevniho zdravi","count":"2"},{"name":"Nemocnice Jihlava, prispevkova organizace","count":"2"},{"name":"Ostravska univerzita v Ostrave","count":"24"},{"name":"Palacky University Olomouc","count":"38"},{"name":"Research Library in Olomouc","count":"1"},{"name":"SPS strojnicka a SOS prof. Svejcara, Plzen","count":"4"},{"name":"Silesian University in Opava","count":"9"},{"name":"Slezska univerzita v Opave","count":"16"},{"name":"Stredisko spolecnych cinnosti AV CR, v. v. i.","count":"108"},{"name":"Technical University of Liberec","count":"83"},{"name":"Technicka univerzita v Liberci","count":"42"},{"name":"The National Library of the Czech Republic","count":"3"},{"name":"UPCE (University of Pardubice)","count":"1"},{"name":"University Hospital Hradec Kralove","count":"6"},{"name":"University of Chemistry and Technology, Prague","count":"25"},{"name":"University of Economics, Prague","count":"271"},{"name":"University of Hradec Kralove","count":"3"},{"name":"University of Ostrava","count":"3"},{"name":"University of Pardubice","count":"22"},{"name":"University of South Bohemia in Ceske Budejovice","count":"47"},{"name":"University of Veterinary and Pharmaceutical Sciences Brno","count":"3"},{"name":"University of West Bohemia","count":"15"},{"name":"Univerzita Hradec Kralove","count":"13"},{"name":"Univerzita Karlova v Praze","count":"178"},{"name":"Univerzita Palackeho v Olomouci","count":"45"},{"name":"Univerzita Pardubice","count":"47"},{"name":"Univerzita Tomase Bati ve Zline","count":"35"},{"name":"Ustav anorganicke chemie AV CR, v. v. i.","count":"2"},{"name":"Ustav fotoniky a elektroniky AV CR, v. v. i.","count":"3"},{"name":"Ustav fyziky materialu AV CR, v. v. i.","count":"1"},{"name":"Ustav jaderne fyziky AV CR, v. v. i.","count":"9"},{"name":"Ustav teorie informace a automatizace AV CR, v. v. i.","count":"2"},{"name":"VOS a SPSE Plzen","count":"21"},{"name":"VSB-Technical University of Ostrava","count":"130"},{"name":"Veterinarni a farmaceuticka univerzita Brno","count":"16"},{"name":"Vseobecna fakultni nemocnice v Praze","count":"6"},{"name":"Vysoka skola banska - Technicka univerzita Ostrava","count":"77"},{"name":"Vysoka skola chemicko-technologicka v Praze","count":"27"},{"name":"Vysoka skola ekonomicka v Praze","count":"36"},{"name":"Vysoka skola polytechnicka Jihlava","count":"10"},{"name":"Vysoka skola umeleckoprumyslova v Praze","count":"22"},{"name":"Vysoke uceni technicke v Brne","count":"39"},{"name":"Vyssi odborna skola informacnich sluzeb, Praha 4, Pacovska 350","count":"1"},{"name":"Vyzkumny ustav geodeticky, topograficky a kartograficky, v. v. i.","count":"5"},{"name":"Vyzkumny ustav vodohospodarsky T. G. Masaryka, v. v. i.","count":"1"},{"name":"Zapadoceska univerzita v Plzni","count":"120"}]}';
            
            google.charts.setOnLoadCallback(function(){ drawChart('Ldap'); });
        </script>
        
    </head>
    <body style="background-color: #ccc">
        
        <h1 class="mainTitle">LDAP statistics</h1>
        <div id="css-table">            
<!--------------------------------------------------------------------------------------------------->
            <div class="collumn fullScreen">
                <div class="title">
                    <h2 style="margin-top: 0;"><a href="ldapDetail.jsp">LDAP</a></h2>
                    <!--<input type="file" id="filesLdap"/>--> 
                    <button type="button">Browse...</button>
                    <span id="btnReadFileLdap">
                        <button type="button">update page</button>
                    </span>
                </div>
                <div class="selectPart">
                    <br>
                    <a href="#" onClick ="exportCSV('Ldap', 'ldap_' + '<%=date%>')">Export to CSV</a>
                    <br>
                    <div>
                        <p class="labelSelectBox"> Displayed organisations </p>
                        <p class="labelSelectBox"> Hidden organisations </p>
                    </div>
                    <br>
                    <div class="selectDiv">

                        <select class="center" name="selectedDatas[]" id="MasterSelectBoxLdap" multiple="multiple" style="height: 200px"></select>

                        <div class="arrows">
                            <button id="btnAddLdap" type="button">&gt;</button><br>
                            <button id="btnRemoveLdap" type="button">&lt;</button>
                        </div>

                        <select class="center" name="hiddenDatas[]" id="PairedSelectBoxLdap" multiple="multiple" style="height: 200px"></select>
                    </div>

                    <div class="labelSelectBox">
                        <label>sort:</label><br>
                        <form id="MasterLdap">
                            <input type="radio" name="MasterLdap" value="MasterLdapAbc" onchange="sortMasterByName('Ldap')" checked> by alphabeth<br>
                            <input type="radio" name="MasterLdap" value="MasterLdapNum" onchange="sortMasterByValue('Ldap')"> by number of CAs<br>
                        </form>
                    </div>
                    <div class="labelSelectBox">
                        <label>sort:</label><br>
                        <form id="PairedLdap">
                            <input type="radio" name="PairedLdap" value="PairedLdapAbc" onchange="sortPairedByName('Ldap')" checked> by alphabet<br>
                            <input type="radio" name="PairedLdap" value="PairedLdapNum" onchange="sortPairedByValue('Ldap')" > by number of CAs<br> 
                        </form>
                    </div>
                </div>
                <br><br><br><br><br>

                <div class="sliderDiv">

                    <p>Your slider has a value of <span id="sliderValueLdap"></span></p>
                    <button id="btnSliderLdap" type="button">Set minimum number of valid CAss</button>
                    
                    <div id="sliderLdap" class="slider"></div>

                </div>
                <br>

                <div id="chartVerticalLdap"></div> 

                <div><br></div> 
                <div id="chartHorizontalLdap"></div> 
                <div><br></div> 
                <div id="tableLdap"></div>
            </div>
<!--------------------------------------------------------------------------------------------------->
        </div>
    </body>
</html>