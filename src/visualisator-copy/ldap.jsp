<%-- 
    Document   : ldap
    Created on : 14.4.2016, 13:00:32
    Author     : jana
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>

        <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
        <script src="//code.jquery.com/jquery-1.10.2.js"></script>
        <script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
        <script src="ldapssscript.js"></script>
        <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css"> 
        <link rel="stylesheet" href="stylesss.css">
        <jsp:useBean id="connector" class="com.cesnet.pki.ejbca.Connector" />
                        
        <% String date = connector.getDate(); %>
        
        <script>
            var initialDate = '<%=date%>';
            date['Client'] = initialDate;
            date['Ldap'] = initialDate;
            date['Server'] = initialDate;
            
            json['Client'] = '{"Astronomical Institute of the Czech Academy of Sciences":5,"BBMRI-ERIC":7,"Biology Centre CAS":1,"Brno University of Technology":19,"CESNET":153,"Charles University in Prague":84,"Czech Technical University in Prague":89,"Hospital Jihlava":2,"Institute of Chemical Technology Prague":2,"Institute of Experimental Botany AS CR, v. v. i.":2,"Institute of Molecular Genetics of the ASCR, v. v. i.":1,"Institute of Organic Chemistry and Biochemistry AS CR, v.v.i.":4,"Institute of Photonics and Electronics of the AS CR, v.v.i.":1,"Institute of Physics AS CR":5,"Institute of Physics of Materials AS CR, v. v. i.":1,"Masaryk University":108,"Palacky University Olomouc":37,"Silesian University in Opava":6,"Stredisko spolecnych cinnosti AV CR, v. v. i.":1,"Technical University of Liberec":79,"University Hospital Hradec Kralove":6,"University of Chemistry and Technology, Prague":2,"University of Economics, Prague":268,"University of Hradec Kralove":1,"University of Ostrava":3,"University of Pardubice":22,"University of South Bohemia in Ceske Budejovice":36,"University of West Bohemia":13,"VSB-Technical University of Ostrava":108}';
            json['Ldap'] = '{"Akademie muzickych umeni v Praze":37,"Astronomical Institute of the Czech Academy of Sciences":5,"BBMRI-ERIC":11,"BRAILCOM, o.p.s.":1,"Biology Centre CAS":1,"Brno University of Technology":33,"CESNET":197,"CESNET (CESNET)":4,"CESNET (CESNET, zajmove sdruzeni pravnickych osob)":5,"CESNET, association of legal entities":1,"CESNET, zajmove sdruzeni pravnickych osob":98,"CVUT (Czech Technical University in Prague)":2,"Centre of Administration and Operations of the ASCR, v. v. i.":7,"Centrum vyzkumu globalni zmeny AV CR, v. v. i.":6,"Ceska zemedelska univerzita v Praze":2,"Ceske vysoke uceni technicke v Praze":127,"Charles University in Prague":114,"Czech Technical University in Prague":202,"Czech University of Life Sciences Prague":31,"Fakultni nemocnice Hradec Kralove":3,"Fakultni nemocnice Ostrava":1,"Fakultni nemocnice Plzen":5,"Food Research Institute Prague":1,"Fyzikalni ustav AV CR, v. v. i.":16,"Fyziologicky ustav AV CR, v. v. i.":2,"Grantova agentura Ceske republiky":1,"Gymnazium Matyase Lercha, Brno, Zizkova 55, prispevkova organizace":2,"Gymnazium, Plzen, Mikulasske nam. 23":2,"Hospital Jihlava":2,"Institute of Chemical Technology Prague":3,"Institute of Experimental Botany AS CR, v. v. i.":2,"Institute of Molecular Genetics of the ASCR, v. v. i.":11,"Institute of Organic Chemistry and Biochemistry AS CR, v.v.i.":4,"Institute of Photonics and Electronics of the AS CR, v.v.i.":1,"Institute of Physics AS CR":28,"Institute of Physics of Materials AS CR, v. v. i.":1,"Institute of Physiology CAS":1,"Jihoceska univerzita v Ceskych Budejovicich":20,"Kerio Technologies s.r.o.":12,"Kerio Technologies sro":6,"MUP (Metropolitan University Prague)":4,"Masaryk University":161,"Masarykova univerzita":135,"Masarykuv onkologicky ustav":2,"Mendel University in Brno":8,"Mendelova univerzita v Brne":17,"Moravian Library":2,"Moravska zemska knihovna v Brne":9,"Narodni knihovna Ceske republiky":5,"Narodni technicka knihovna":3,"Narodni ustav dusevniho zdravi":2,"Nemocnice Jihlava, prispevkova organizace":2,"Ostravska univerzita v Ostrave":24,"Palacky University Olomouc":38,"Research Library in Olomouc":1,"SPS strojnicka a SOS prof. Svejcara, Plzen":4,"Silesian University in Opava":9,"Slezska univerzita v Opave":16,"Stredisko spolecnych cinnosti AV CR, v. v. i.":108,"Technical University of Liberec":83,"Technicka univerzita v Liberci":42,"The National Library of the Czech Republic":3,"UPCE (University of Pardubice)":1,"University Hospital Hradec Kralove":6,"University of Chemistry and Technology, Prague":25,"University of Economics, Prague":271,"University of Hradec Kralove":3,"University of Ostrava":3,"University of Pardubice":22,"University of South Bohemia in Ceske Budejovice":47,"University of Veterinary and Pharmaceutical Sciences Brno":3,"University of West Bohemia":15,"Univerzita Hradec Kralove":13,"Univerzita Karlova v Praze":178,"Univerzita Palackeho v Olomouci":45,"Univerzita Pardubice":47,"Univerzita Tomase Bati ve Zline":35,"Ustav anorganicke chemie AV CR, v. v. i.":2,"Ustav fotoniky a elektroniky AV CR, v. v. i.":3,"Ustav fyziky materialu AV CR, v. v. i.":1,"Ustav jaderne fyziky AV CR, v. v. i.":9,"Ustav teorie informace a automatizace AV CR, v. v. i.":2,"VOS a SPSE Plzen":21,"VSB-Technical University of Ostrava":130,"Veterinarni a farmaceuticka univerzita Brno":16,"Vseobecna fakultni nemocnice v Praze":6,"Vysoka skola banska - Technicka univerzita Ostrava":77,"Vysoka skola chemicko-technologicka v Praze":27,"Vysoka skola ekonomicka v Praze":36,"Vysoka skola polytechnicka Jihlava":10,"Vysoka skola umeleckoprumyslova v Praze":22,"Vysoke uceni technicke v Brne":39,"Vyssi odborna skola informacnich sluzeb, Praha 4, Pacovska 350":1,"Vyzkumny ustav geodeticky, topograficky a kartograficky, v. v. i.":5,"Vyzkumny ustav vodohospodarsky T. G. Masaryka, v. v. i.":1,"Zapadoceska univerzita v Plzni":120}';
            json['Server'] = '{"Akademie muzickych umeni v Praze":37,"BBMRI-ERIC":4,"BRAILCOM, o.p.s.":1,"Brno University of Technology":14,"CESNET":44,"CESNET (CESNET)":4,"CESNET (CESNET, zajmove sdruzeni pravnickych osob)":5,"CESNET, association of legal entities":1,"CESNET, zajmove sdruzeni pravnickych osob":98,"CVUT (Czech Technical University in Prague)":2,"Centre of Administration and Operations of the ASCR, v. v. i.":7,"Centrum vyzkumu globalni zmeny AV CR, v. v. i.":6,"Ceska zemedelska univerzita v Praze":2,"Ceske vysoke uceni technicke v Praze":127,"Charles University in Prague":30,"Czech Technical University in Prague":113,"Czech University of Life Sciences Prague":31,"Fakultni nemocnice Hradec Kralove":3,"Fakultni nemocnice Ostrava":1,"Fakultni nemocnice Plzen":5,"Food Research Institute Prague":1,"Fyzikalni ustav AV CR, v. v. i.":16,"Fyziologicky ustav AV CR, v. v. i.":2,"Grantova agentura Ceske republiky":1,"Gymnazium Matyase Lercha, Brno, Zizkova 55, prispevkova organizace":2,"Gymnazium, Plzen, Mikulasske nam. 23":2,"Institute of Chemical Technology Prague":1,"Institute of Molecular Genetics of the ASCR, v. v. i.":10,"Institute of Physics AS CR":23,"Institute of Physiology CAS":1,"Jihoceska univerzita v Ceskych Budejovicich":20,"Kerio Technologies s.r.o.":12,"Kerio Technologies sro":6,"MUP (Metropolitan University Prague)":4,"Masaryk University":53,"Masarykova univerzita":135,"Masarykuv onkologicky ustav":2,"Mendel University in Brno":8,"Mendelova univerzita v Brne":17,"Moravian Library":2,"Moravska zemska knihovna v Brne":9,"Narodni knihovna Ceske republiky":5,"Narodni technicka knihovna":3,"Narodni ustav dusevniho zdravi":2,"Nemocnice Jihlava, prispevkova organizace":2,"Ostravska univerzita v Ostrave":24,"Palacky University Olomouc":1,"Research Library in Olomouc":1,"SPS strojnicka a SOS prof. Svejcara, Plzen":4,"Silesian University in Opava":3,"Slezska univerzita v Opave":16,"Stredisko spolecnych cinnosti AV CR, v. v. i.":107,"Technical University of Liberec":4,"Technicka univerzita v Liberci":42,"The National Library of the Czech Republic":3,"UPCE (University of Pardubice)":1,"University of Chemistry and Technology, Prague":23,"University of Economics, Prague":3,"University of Hradec Kralove":2,"University of South Bohemia in Ceske Budejovice":11,"University of Veterinary and Pharmaceutical Sciences Brno":3,"University of West Bohemia":2,"Univerzita Hradec Kralove":13,"Univerzita Karlova v Praze":178,"Univerzita Palackeho v Olomouci":45,"Univerzita Pardubice":47,"Univerzita Tomase Bati ve Zline":35,"Ustav anorganicke chemie AV CR, v. v. i.":2,"Ustav fotoniky a elektroniky AV CR, v. v. i.":3,"Ustav fyziky materialu AV CR, v. v. i.":1,"Ustav jaderne fyziky AV CR, v. v. i.":9,"Ustav teorie informace a automatizace AV CR, v. v. i.":2,"VOS a SPSE Plzen":21,"VSB-Technical University of Ostrava":22,"Veterinarni a farmaceuticka univerzita Brno":16,"Vseobecna fakultni nemocnice v Praze":6,"Vysoka skola banska - Technicka univerzita Ostrava":77,"Vysoka skola chemicko-technologicka v Praze":27,"Vysoka skola ekonomicka v Praze":36,"Vysoka skola polytechnicka Jihlava":10,"Vysoka skola umeleckoprumyslova v Praze":22,"Vysoke uceni technicke v Brne":39,"Vyssi odborna skola informacnich sluzeb, Praha 4, Pacovska 350":1,"Vyzkumny ustav geodeticky, topograficky a kartograficky, v. v. i.":5,"Vyzkumny ustav vodohospodarsky T. G. Masaryka, v. v. i.":1,"Zapadoceska univerzita v Plzni":120}';
        </script>
        
        <title>Ldap detail</title>
    </head>
    <body>
        <div id="css-table">
<!--------------------------------------------------------------------------------------------------->
            <div class="collumn fullScreen">
                <div class="center">
                    <h1>LDAP valid CAs</h1>                    
                </div>
                <br>
                <br>
                
                <div class="inline">
                <div class="thirdScreen">
                    <h2>Server</h2>
                    <div>
                        <p class="labelSelectBox"> Displayed organisations </p>
                        <p class="labelSelectBox"> Hidden organisations </p>
                    </div>
                    <br>
                    <div class="selectDiv">

                        <select class="center" name="selectedDatas[]" id="MasterSelectBoxServer" multiple="multiple" style="height: 200px"></select>

                        <div class="arrows">
                            <button id="btnAddServer" type="button">&gt;</button><br>
                            <button id="btnRemoveServer" type="button">&lt;</button>
                        </div>

                        <select class="center" name="hiddenDatas[]" id="PairedSelectBoxServer" multiple="multiple" style="height: 200px"></select>
                    </div>
                    <div class="labelSelectBox">
                        <label>sort:</label><br>
                        <form id="MasterServer">
                            <input type="radio" name="MasterServer" value="MasterServerAbc" onchange="sortMasterByName('Server')" checked> by alphabeth<br>
                            <input type="radio" name="MasterServer" value="MasterServerNum" onchange="sortMasterByValue('Server')"> by number of CAs<br>
                        </form>
                    </div>
                    <div class="labelSelectBox">
                        <label>sort:</label><br>
                        <form id="PairedServer">
                            <input type="radio" name="PairedServer" value="PairedServerAbc" onchange="sortPairedByName('Server')" checked> by alphabet<br>
                            <input type="radio" name="PairedServer" value="PairedServerNum" onchange="sortPairedByValue('Server')" > by number of CAs<br> 
                        </form>
                    </div>
                    <div class="sliderDiv">

                        <p>Your slider has a value of <span id="sliderValueServer"></span></p>
                        <button id="btnSliderServer" type="button">Set minimum number of valid CAss</button>

                        <div id="sliderServer" class="slider"></div>

                    </div>
                </div> 
                    
                <div class="thirdScreen" style="background: #ccc;">
                    <h2>Client</h2>
                    <div>
                        <p class="labelSelectBox"> Displayed organisations </p>
                        <p class="labelSelectBox"> Hidden organisations </p>
                    </div>
                    <br>
                    <div class="selectDiv">

                        <select class="center" name="selectedDatas[]" id="MasterSelectBoxClient" multiple="multiple" style="height: 200px"></select>

                        <div class="arrows">
                            <button id="btnAddClient" type="button">&gt;</button><br>
                            <button id="btnRemoveClient" type="button">&lt;</button>
                        </div>

                        <select class="center" name="hiddenDatas[]" id="PairedSelectBoxClient" multiple="multiple" style="height: 200px"></select>
                    </div>
                    <div class="labelSelectBox">
                        <label>sort:</label><br>
                        <form id="MasterClient">
                            <input type="radio" name="MasterClient" value="MasterClientAbc" onchange="sortMasterByName('Client')" checked> by alphabeth<br>
                            <input type="radio" name="MasterClient" value="MasterClientNum" onchange="sortMasterByValue('Client')"> by number of CAs<br>
                        </form>
                    </div>
                    <div class="labelSelectBox">
                        <label>sort:</label><br>
                        <form id="PairedClient">
                            <input type="radio" name="PairedClient" value="PairedClientAbc" onchange="sortPairedByName('Client')" checked> by alphabet<br>
                            <input type="radio" name="PairedClient" value="PairedClientNum" onchange="sortPairedByValue('Client')" > by number of CAs<br> 
                        </form>
                    </div>
                    <div class="sliderDiv">

                        <p>Your slider has a value of <span id="sliderValueClient"></span></p>
                        <button id="btnSliderClient" type="button">Set minimum number of valid CAss</button>

                        <div id="sliderClient" class="slider"></div>

                    </div>
                </div> 
                    
                <div class="thirdScreen">
                    <h2>LDAP</h2>
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
                    <div class="sliderDiv">

                        <p>Your slider has a value of <span id="sliderValueLdap"></span></p>
                        <button id="btnSliderLdap" type="button">Set minimum number of valid CAss</button>

                        <div id="sliderLdap" class="slider"></div>

                    </div>
                </div>
                </div>
                
                <br><br><br><br><br>

                
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
