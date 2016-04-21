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
            
            json['Client'] = '{"organizations":{"Astronomical Institute of the Czech Academy of Sciences":[{"name":"Astronomical Institute of the Czech Academy of Sciences","count":"5"}],"BBMRI-ERIC":[{"name":"BBMRI-ERIC","count":"7"}],"Biology Centre CAS":[{"name":"Biology Centre CAS","count":"1"}],"Brno University of Technology":[{"name":"Brno University of Technology","count":"19"}],"CESNET":[{"name":"CESNET","count":"153"}],"Charles University in Prague":[{"name":"Charles University in Prague","count":"84"}],"Czech Technical University in Prague":[{"name":"Czech Technical University in Prague","count":"89"}],"Hospital Jihlava":[{"name":"Hospital Jihlava","count":"2"}],"Institute of Chemical Technology Prague":[{"name":"Institute of Chemical Technology Prague","count":"2"}],"Institute of Experimental Botany AS CR, v. v. i.":[{"name":"Institute of Experimental Botany AS CR, v. v. i.","count":"2"}],"Institute of Molecular Genetics of the ASCR, v. v. i.":[{"name":"Institute of Molecular Genetics of the ASCR, v. v. i.","count":"1"}],"Institute of Organic Chemistry and Biochemistry AS CR, v.v.i.":[{"name":"Institute of Organic Chemistry and Biochemistry AS CR, v.v.i.","count":"4"}],"Institute of Photonics and Electronics of the AS CR, v.v.i.":[{"name":"Institute of Photonics and Electronics of the AS CR, v.v.i.","count":"1"}],"Institute of Physics AS CR":[{"name":"Institute of Physics AS CR","count":"5"}],"Institute of Physics of Materials AS CR, v. v. i.":[{"name":"Institute of Physics of Materials AS CR, v. v. i.","count":"1"}],"Masaryk University":[{"name":"Masaryk University","count":"108"}],"Palacky University Olomouc":[{"name":"Palacky University Olomouc","count":"37"}],"Silesian University in Opava":[{"name":"Silesian University in Opava","count":"6"}],"Stredisko spolecnych cinnosti AV CR, v. v. i.":[{"name":"Stredisko spolecnych cinnosti AV CR, v. v. i.","count":"1"}],"Technical University of Liberec":[{"name":"Technical University of Liberec","count":"79"}],"University Hospital Hradec Kralove":[{"name":"University Hospital Hradec Kralove","count":"6"}],"University of Chemistry and Technology, Prague":[{"name":"University of Chemistry and Technology, Prague","count":"2"}],"University of Economics, Prague":[{"name":"University of Economics, Prague","count":"268"}],"University of Hradec Kralove":[{"name":"University of Hradec Kralove","count":"1"}],"University of Ostrava":[{"name":"University of Ostrava","count":"3"}],"University of Pardubice":[{"name":"University of Pardubice","count":"22"}],"University of South Bohemia in Ceske Budejovice":[{"name":"University of South Bohemia in Ceske Budejovice","count":"36"}],"University of West Bohemia":[{"name":"University of West Bohemia","count":"13"}],"VSB-Technical University of Ostrava":[{"name":"VSB-Technical University of Ostrava","count":"108"}]}}';
            json['Ldap'] = '{"organizations":{"Akademie muzickych umeni v Praze":[{"name":"Akademie muzickych umeni v Praze","count":"37"}],"Astronomical Institute of the Czech Academy of Sciences":[{"name":"Astronomical Institute of the Czech Academy of Sciences","count":"5"}],"BBMRI-ERIC":[{"name":"BBMRI-ERIC","count":"11"}],"BRAILCOM, o.p.s.":[{"name":"BRAILCOM, o.p.s.","count":"1"}],"Biology Centre CAS":[{"name":"Biology Centre CAS","count":"1"}],"Brno University of Technology":[{"name":"Brno University of Technology","count":"33"}],"CESNET":[{"name":"CESNET","count":"197"}],"CESNET (CESNET)":[{"name":"CESNET (CESNET)","count":"4"}],"CESNET (CESNET, zajmove sdruzeni pravnickych osob)":[{"name":"CESNET (CESNET, zajmove sdruzeni pravnickych osob)","count":"5"}],"CESNET, association of legal entities":[{"name":"CESNET, association of legal entities","count":"1"}],"CESNET, zajmove sdruzeni pravnickych osob":[{"name":"CESNET, zajmove sdruzeni pravnickych osob","count":"98"}],"CVUT (Czech Technical University in Prague)":[{"name":"CVUT (Czech Technical University in Prague)","count":"2"}],"Centre of Administration and Operations of the ASCR, v. v. i.":[{"name":"Centre of Administration and Operations of the ASCR, v. v. i.","count":"7"}],"Centrum vyzkumu globalni zmeny AV CR, v. v. i.":[{"name":"Centrum vyzkumu globalni zmeny AV CR, v. v. i.","count":"6"}],"Ceska zemedelska univerzita v Praze":[{"name":"Ceska zemedelska univerzita v Praze","count":"2"}],"Ceske vysoke uceni technicke v Praze":[{"name":"Ceske vysoke uceni technicke v Praze","count":"127"}],"Charles University in Prague":[{"name":"Charles University in Prague","count":"114"}],"Czech Technical University in Prague":[{"name":"Czech Technical University in Prague","count":"202"}],"Czech University of Life Sciences Prague":[{"name":"Czech University of Life Sciences Prague","count":"31"}],"Fakultni nemocnice Hradec Kralove":[{"name":"Fakultni nemocnice Hradec Kralove","count":"3"}],"Fakultni nemocnice Ostrava":[{"name":"Fakultni nemocnice Ostrava","count":"1"}],"Fakultni nemocnice Plzen":[{"name":"Fakultni nemocnice Plzen","count":"5"}],"Food Research Institute Prague":[{"name":"Food Research Institute Prague","count":"1"}],"Fyzikalni ustav AV CR, v. v. i.":[{"name":"Fyzikalni ustav AV CR, v. v. i.","count":"16"}],"Fyziologicky ustav AV CR, v. v. i.":[{"name":"Fyziologicky ustav AV CR, v. v. i.","count":"2"}],"Grantova agentura Ceske republiky":[{"name":"Grantova agentura Ceske republiky","count":"1"}],"Gymnazium Matyase Lercha, Brno, Zizkova 55, prispevkova organizace":[{"name":"Gymnazium Matyase Lercha, Brno, Zizkova 55, prispevkova organizace","count":"2"}],"Gymnazium, Plzen, Mikulasske nam. 23":[{"name":"Gymnazium, Plzen, Mikulasske nam. 23","count":"2"}],"Hospital Jihlava":[{"name":"Hospital Jihlava","count":"2"}],"Institute of Chemical Technology Prague":[{"name":"Institute of Chemical Technology Prague","count":"3"}],"Institute of Experimental Botany AS CR, v. v. i.":[{"name":"Institute of Experimental Botany AS CR, v. v. i.","count":"2"}],"Institute of Molecular Genetics of the ASCR, v. v. i.":[{"name":"Institute of Molecular Genetics of the ASCR, v. v. i.","count":"11"}],"Institute of Organic Chemistry and Biochemistry AS CR, v.v.i.":[{"name":"Institute of Organic Chemistry and Biochemistry AS CR, v.v.i.","count":"4"}],"Institute of Photonics and Electronics of the AS CR, v.v.i.":[{"name":"Institute of Photonics and Electronics of the AS CR, v.v.i.","count":"1"}],"Institute of Physics AS CR":[{"name":"Institute of Physics AS CR","count":"28"}],"Institute of Physics of Materials AS CR, v. v. i.":[{"name":"Institute of Physics of Materials AS CR, v. v. i.","count":"1"}],"Institute of Physiology CAS":[{"name":"Institute of Physiology CAS","count":"1"}],"Jihoceska univerzita v Ceskych Budejovicich":[{"name":"Jihoceska univerzita v Ceskych Budejovicich","count":"20"}],"Kerio Technologies s.r.o.":[{"name":"Kerio Technologies s.r.o.","count":"12"}],"Kerio Technologies sro":[{"name":"Kerio Technologies sro","count":"6"}],"MUP (Metropolitan University Prague)":[{"name":"MUP (Metropolitan University Prague)","count":"4"}],"Masaryk University":[{"name":"Masaryk University","count":"161"}],"Masarykova univerzita":[{"name":"Masarykova univerzita","count":"135"}],"Masarykuv onkologicky ustav":[{"name":"Masarykuv onkologicky ustav","count":"2"}],"Mendel University in Brno":[{"name":"Mendel University in Brno","count":"8"}],"Mendelova univerzita v Brne":[{"name":"Mendelova univerzita v Brne","count":"17"}],"Moravian Library":[{"name":"Moravian Library","count":"2"}],"Moravska zemska knihovna v Brne":[{"name":"Moravska zemska knihovna v Brne","count":"9"}],"Narodni knihovna Ceske republiky":[{"name":"Narodni knihovna Ceske republiky","count":"5"}],"Narodni technicka knihovna":[{"name":"Narodni technicka knihovna","count":"3"}],"Narodni ustav dusevniho zdravi":[{"name":"Narodni ustav dusevniho zdravi","count":"2"}],"Nemocnice Jihlava, prispevkova organizace":[{"name":"Nemocnice Jihlava, prispevkova organizace","count":"2"}],"Ostravska univerzita v Ostrave":[{"name":"Ostravska univerzita v Ostrave","count":"24"}],"Palacky University Olomouc":[{"name":"Palacky University Olomouc","count":"38"}],"Research Library in Olomouc":[{"name":"Research Library in Olomouc","count":"1"}],"SPS strojnicka a SOS prof. Svejcara, Plzen":[{"name":"SPS strojnicka a SOS prof. Svejcara, Plzen","count":"4"}],"Silesian University in Opava":[{"name":"Silesian University in Opava","count":"9"}],"Slezska univerzita v Opave":[{"name":"Slezska univerzita v Opave","count":"16"}],"Stredisko spolecnych cinnosti AV CR, v. v. i.":[{"name":"Stredisko spolecnych cinnosti AV CR, v. v. i.","count":"108"}],"Technical University of Liberec":[{"name":"Technical University of Liberec","count":"83"}],"Technicka univerzita v Liberci":[{"name":"Technicka univerzita v Liberci","count":"42"}],"The National Library of the Czech Republic":[{"name":"The National Library of the Czech Republic","count":"3"}],"UPCE (University of Pardubice)":[{"name":"UPCE (University of Pardubice)","count":"1"}],"University Hospital Hradec Kralove":[{"name":"University Hospital Hradec Kralove","count":"6"}],"University of Chemistry and Technology, Prague":[{"name":"University of Chemistry and Technology, Prague","count":"25"}],"University of Economics, Prague":[{"name":"University of Economics, Prague","count":"271"}],"University of Hradec Kralove":[{"name":"University of Hradec Kralove","count":"3"}],"University of Ostrava":[{"name":"University of Ostrava","count":"3"}],"University of Pardubice":[{"name":"University of Pardubice","count":"22"}],"University of South Bohemia in Ceske Budejovice":[{"name":"University of South Bohemia in Ceske Budejovice","count":"47"}],"University of Veterinary and Pharmaceutical Sciences Brno":[{"name":"University of Veterinary and Pharmaceutical Sciences Brno","count":"3"}],"University of West Bohemia":[{"name":"University of West Bohemia","count":"15"}],"Univerzita Hradec Kralove":[{"name":"Univerzita Hradec Kralove","count":"13"}],"Univerzita Karlova v Praze":[{"name":"Univerzita Karlova v Praze","count":"178"}],"Univerzita Palackeho v Olomouci":[{"name":"Univerzita Palackeho v Olomouci","count":"45"}],"Univerzita Pardubice":[{"name":"Univerzita Pardubice","count":"47"}],"Univerzita Tomase Bati ve Zline":[{"name":"Univerzita Tomase Bati ve Zline","count":"35"}],"Ustav anorganicke chemie AV CR, v. v. i.":[{"name":"Ustav anorganicke chemie AV CR, v. v. i.","count":"2"}],"Ustav fotoniky a elektroniky AV CR, v. v. i.":[{"name":"Ustav fotoniky a elektroniky AV CR, v. v. i.","count":"3"}],"Ustav fyziky materialu AV CR, v. v. i.":[{"name":"Ustav fyziky materialu AV CR, v. v. i.","count":"1"}],"Ustav jaderne fyziky AV CR, v. v. i.":[{"name":"Ustav jaderne fyziky AV CR, v. v. i.","count":"9"}],"Ustav teorie informace a automatizace AV CR, v. v. i.":[{"name":"Ustav teorie informace a automatizace AV CR, v. v. i.","count":"2"}],"VOS a SPSE Plzen":[{"name":"VOS a SPSE Plzen","count":"21"}],"VSB-Technical University of Ostrava":[{"name":"VSB-Technical University of Ostrava","count":"130"}],"Veterinarni a farmaceuticka univerzita Brno":[{"name":"Veterinarni a farmaceuticka univerzita Brno","count":"16"}],"Vseobecna fakultni nemocnice v Praze":[{"name":"Vseobecna fakultni nemocnice v Praze","count":"6"}],"Vysoka skola banska - Technicka univerzita Ostrava":[{"name":"Vysoka skola banska - Technicka univerzita Ostrava","count":"77"}],"Vysoka skola chemicko-technologicka v Praze":[{"name":"Vysoka skola chemicko-technologicka v Praze","count":"27"}],"Vysoka skola ekonomicka v Praze":[{"name":"Vysoka skola ekonomicka v Praze","count":"36"}],"Vysoka skola polytechnicka Jihlava":[{"name":"Vysoka skola polytechnicka Jihlava","count":"10"}],"Vysoka skola umeleckoprumyslova v Praze":[{"name":"Vysoka skola umeleckoprumyslova v Praze","count":"22"}],"Vysoke uceni technicke v Brne":[{"name":"Vysoke uceni technicke v Brne","count":"39"}],"Vyssi odborna skola informacnich sluzeb, Praha 4, Pacovska 350":[{"name":"Vyssi odborna skola informacnich sluzeb, Praha 4, Pacovska 350","count":"1"}],"Vyzkumny ustav geodeticky, topograficky a kartograficky, v. v. i.":[{"name":"Vyzkumny ustav geodeticky, topograficky a kartograficky, v. v. i.","count":"5"}],"Vyzkumny ustav vodohospodarsky T. G. Masaryka, v. v. i.":[{"name":"Vyzkumny ustav vodohospodarsky T. G. Masaryka, v. v. i.","count":"1"}],"Zapadoceska univerzita v Plzni":[{"name":"Zapadoceska univerzita v Plzni","count":"120"}]}}';
            json['Server'] = '{"organizations":{"Akademie muzickych umeni v Praze":[{"name":"Akademie muzickych umeni v Praze","count":"37"}],"BBMRI-ERIC":[{"name":"BBMRI-ERIC","count":"4"}],"BRAILCOM, o.p.s.":[{"name":"BRAILCOM, o.p.s.","count":"1"}],"Brno University of Technology":[{"name":"Brno University of Technology","count":"14"}],"CESNET":[{"name":"CESNET","count":"44"}],"CESNET (CESNET)":[{"name":"CESNET (CESNET)","count":"4"}],"CESNET (CESNET, zajmove sdruzeni pravnickych osob)":[{"name":"CESNET (CESNET, zajmove sdruzeni pravnickych osob)","count":"5"}],"CESNET, association of legal entities":[{"name":"CESNET, association of legal entities","count":"1"}],"CESNET, zajmove sdruzeni pravnickych osob":[{"name":"CESNET, zajmove sdruzeni pravnickych osob","count":"98"}],"CVUT (Czech Technical University in Prague)":[{"name":"CVUT (Czech Technical University in Prague)","count":"2"}],"Centre of Administration and Operations of the ASCR, v. v. i.":[{"name":"Centre of Administration and Operations of the ASCR, v. v. i.","count":"7"}],"Centrum vyzkumu globalni zmeny AV CR, v. v. i.":[{"name":"Centrum vyzkumu globalni zmeny AV CR, v. v. i.","count":"6"}],"Ceska zemedelska univerzita v Praze":[{"name":"Ceska zemedelska univerzita v Praze","count":"2"}],"Ceske vysoke uceni technicke v Praze":[{"name":"Ceske vysoke uceni technicke v Praze","count":"127"}],"Charles University in Prague":[{"name":"Charles University in Prague","count":"30"}],"Czech Technical University in Prague":[{"name":"Czech Technical University in Prague","count":"113"}],"Czech University of Life Sciences Prague":[{"name":"Czech University of Life Sciences Prague","count":"31"}],"Fakultni nemocnice Hradec Kralove":[{"name":"Fakultni nemocnice Hradec Kralove","count":"3"}],"Fakultni nemocnice Ostrava":[{"name":"Fakultni nemocnice Ostrava","count":"1"}],"Fakultni nemocnice Plzen":[{"name":"Fakultni nemocnice Plzen","count":"5"}],"Food Research Institute Prague":[{"name":"Food Research Institute Prague","count":"1"}],"Fyzikalni ustav AV CR, v. v. i.":[{"name":"Fyzikalni ustav AV CR, v. v. i.","count":"16"}],"Fyziologicky ustav AV CR, v. v. i.":[{"name":"Fyziologicky ustav AV CR, v. v. i.","count":"2"}],"Grantova agentura Ceske republiky":[{"name":"Grantova agentura Ceske republiky","count":"1"}],"Gymnazium Matyase Lercha, Brno, Zizkova 55, prispevkova organizace":[{"name":"Gymnazium Matyase Lercha, Brno, Zizkova 55, prispevkova organizace","count":"2"}],"Gymnazium, Plzen, Mikulasske nam. 23":[{"name":"Gymnazium, Plzen, Mikulasske nam. 23","count":"2"}],"Institute of Chemical Technology Prague":[{"name":"Institute of Chemical Technology Prague","count":"1"}],"Institute of Molecular Genetics of the ASCR, v. v. i.":[{"name":"Institute of Molecular Genetics of the ASCR, v. v. i.","count":"10"}],"Institute of Physics AS CR":[{"name":"Institute of Physics AS CR","count":"23"}],"Institute of Physiology CAS":[{"name":"Institute of Physiology CAS","count":"1"}],"Jihoceska univerzita v Ceskych Budejovicich":[{"name":"Jihoceska univerzita v Ceskych Budejovicich","count":"20"}],"Kerio Technologies s.r.o.":[{"name":"Kerio Technologies s.r.o.","count":"12"}],"Kerio Technologies sro":[{"name":"Kerio Technologies sro","count":"6"}],"MUP (Metropolitan University Prague)":[{"name":"MUP (Metropolitan University Prague)","count":"4"}],"Masaryk University":[{"name":"Masaryk University","count":"53"}],"Masarykova univerzita":[{"name":"Masarykova univerzita","count":"135"}],"Masarykuv onkologicky ustav":[{"name":"Masarykuv onkologicky ustav","count":"2"}],"Mendel University in Brno":[{"name":"Mendel University in Brno","count":"8"}],"Mendelova univerzita v Brne":[{"name":"Mendelova univerzita v Brne","count":"17"}],"Moravian Library":[{"name":"Moravian Library","count":"2"}],"Moravska zemska knihovna v Brne":[{"name":"Moravska zemska knihovna v Brne","count":"9"}],"Narodni knihovna Ceske republiky":[{"name":"Narodni knihovna Ceske republiky","count":"5"}],"Narodni technicka knihovna":[{"name":"Narodni technicka knihovna","count":"3"}],"Narodni ustav dusevniho zdravi":[{"name":"Narodni ustav dusevniho zdravi","count":"2"}],"Nemocnice Jihlava, prispevkova organizace":[{"name":"Nemocnice Jihlava, prispevkova organizace","count":"2"}],"Ostravska univerzita v Ostrave":[{"name":"Ostravska univerzita v Ostrave","count":"24"}],"Palacky University Olomouc":[{"name":"Palacky University Olomouc","count":"1"}],"Research Library in Olomouc":[{"name":"Research Library in Olomouc","count":"1"}],"SPS strojnicka a SOS prof. Svejcara, Plzen":[{"name":"SPS strojnicka a SOS prof. Svejcara, Plzen","count":"4"}],"Silesian University in Opava":[{"name":"Silesian University in Opava","count":"3"}],"Slezska univerzita v Opave":[{"name":"Slezska univerzita v Opave","count":"16"}],"Stredisko spolecnych cinnosti AV CR, v. v. i.":[{"name":"Stredisko spolecnych cinnosti AV CR, v. v. i.","count":"107"}],"Technical University of Liberec":[{"name":"Technical University of Liberec","count":"4"}],"Technicka univerzita v Liberci":[{"name":"Technicka univerzita v Liberci","count":"42"}],"The National Library of the Czech Republic":[{"name":"The National Library of the Czech Republic","count":"3"}],"UPCE (University of Pardubice)":[{"name":"UPCE (University of Pardubice)","count":"1"}],"University of Chemistry and Technology, Prague":[{"name":"University of Chemistry and Technology, Prague","count":"23"}],"University of Economics, Prague":[{"name":"University of Economics, Prague","count":"3"}],"University of Hradec Kralove":[{"name":"University of Hradec Kralove","count":"2"}],"University of South Bohemia in Ceske Budejovice":[{"name":"University of South Bohemia in Ceske Budejovice","count":"11"}],"University of Veterinary and Pharmaceutical Sciences Brno":[{"name":"University of Veterinary and Pharmaceutical Sciences Brno","count":"3"}],"University of West Bohemia":[{"name":"University of West Bohemia","count":"2"}],"Univerzita Hradec Kralove":[{"name":"Univerzita Hradec Kralove","count":"13"}],"Univerzita Karlova v Praze":[{"name":"Univerzita Karlova v Praze","count":"178"}],"Univerzita Palackeho v Olomouci":[{"name":"Univerzita Palackeho v Olomouci","count":"45"}],"Univerzita Pardubice":[{"name":"Univerzita Pardubice","count":"47"}],"Univerzita Tomase Bati ve Zline":[{"name":"Univerzita Tomase Bati ve Zline","count":"35"}],"Ustav anorganicke chemie AV CR, v. v. i.":[{"name":"Ustav anorganicke chemie AV CR, v. v. i.","count":"2"}],"Ustav fotoniky a elektroniky AV CR, v. v. i.":[{"name":"Ustav fotoniky a elektroniky AV CR, v. v. i.","count":"3"}],"Ustav fyziky materialu AV CR, v. v. i.":[{"name":"Ustav fyziky materialu AV CR, v. v. i.","count":"1"}],"Ustav jaderne fyziky AV CR, v. v. i.":[{"name":"Ustav jaderne fyziky AV CR, v. v. i.","count":"9"}],"Ustav teorie informace a automatizace AV CR, v. v. i.":[{"name":"Ustav teorie informace a automatizace AV CR, v. v. i.","count":"2"}],"VOS a SPSE Plzen":[{"name":"VOS a SPSE Plzen","count":"21"}],"VSB-Technical University of Ostrava":[{"name":"VSB-Technical University of Ostrava","count":"22"}],"Veterinarni a farmaceuticka univerzita Brno":[{"name":"Veterinarni a farmaceuticka univerzita Brno","count":"16"}],"Vseobecna fakultni nemocnice v Praze":[{"name":"Vseobecna fakultni nemocnice v Praze","count":"6"}],"Vysoka skola banska - Technicka univerzita Ostrava":[{"name":"Vysoka skola banska - Technicka univerzita Ostrava","count":"77"}],"Vysoka skola chemicko-technologicka v Praze":[{"name":"Vysoka skola chemicko-technologicka v Praze","count":"27"}],"Vysoka skola ekonomicka v Praze":[{"name":"Vysoka skola ekonomicka v Praze","count":"36"}],"Vysoka skola polytechnicka Jihlava":[{"name":"Vysoka skola polytechnicka Jihlava","count":"10"}],"Vysoka skola umeleckoprumyslova v Praze":[{"name":"Vysoka skola umeleckoprumyslova v Praze","count":"22"}],"Vysoke uceni technicke v Brne":[{"name":"Vysoke uceni technicke v Brne","count":"39"}],"Vyssi odborna skola informacnich sluzeb, Praha 4, Pacovska 350":[{"name":"Vyssi odborna skola informacnich sluzeb, Praha 4, Pacovska 350","count":"1"}],"Vyzkumny ustav geodeticky, topograficky a kartograficky, v. v. i.":[{"name":"Vyzkumny ustav geodeticky, topograficky a kartograficky, v. v. i.","count":"5"}],"Vyzkumny ustav vodohospodarsky T. G. Masaryka, v. v. i.":[{"name":"Vyzkumny ustav vodohospodarsky T. G. Masaryka, v. v. i.","count":"1"}],"Zapadoceska univerzita v Plzni":[{"name":"Zapadoceska univerzita v Plzni","count":"120"}]}}';
        </script>
        
        <title>Ldap detail</title>
    </head>
    <body style="background-color: #ccc">
        <h1 class="mainTitle">Certificate classification by type</h1>
        <div id="css-table">
            <div class="collumn fullScreen">
                <div class="inline">
<!--------------------------------------------------------------------------------------------------->
                <div class="thirdScreen">                    
                    <h2 class="title" style="margin-top: 0;">LDAP's all CAs</h2>
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
<!--------------------------------------------------------------------------------------------------->
                <div class="thirdScreen" style="background: #ccc;">
                    <h2 class="title" style="margin-top: 0;">Client</h2>
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
<!--------------------------------------------------------------------------------------------------->
                <div class="thirdScreen">
                    <h2 class="title" style="margin-top: 0;">Server</h2>
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
<!--------------------------------------------------------------------------------------------------->
<!--------------------------------------------------------------------------------------------------->
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
