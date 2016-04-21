<%--
    Document   : newjsp
    Created on : 11.3.2016, 17:05:38
    Author     : anonym
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
            date['Digicert'] = initialDate;
            date['Ldap'] = initialDate;
            date['Ejbca'] = initialDate;
            
            json['Digicert'] = '{"organizations":[{"name":"Akademie múzických umění v Praze","count":"37"},{"name":"Astronomický ústav AV ČR, v. v. i.","count":"14"},{"name":"BBMRI-ERIC","count":"11"},{"name":"BRAILCOM, o.p.s.","count":"1"},{"name":"Biologické centrum AV ČR, v. v. i.","count":"4"},{"name":"CESNET, zájmové sdružení právnických osob","count":"510"},{"name":"Centrum výzkumu globální změny AV ČR, v. v. i.","count":"6"},{"name":"Fakultní nemocnice Brno","count":"3"},{"name":"Fakultní nemocnice Hradec Králové","count":"17"},{"name":"Fakultní nemocnice Ostrava","count":"6"},{"name":"Fakultní nemocnice Plzeň","count":"7"},{"name":"Food Research Institute Prague","count":"1"},{"name":"Fyzikální ústav AV ČR, v. v. i.","count":"45"},{"name":"Fyziologický ústav AV ČR, v. v. i.","count":"5"},{"name":"Grantová agentura České republiky","count":"1"},{"name":"Gymnázium Matyáše Lercha, Brno, Žižkova 55, příspěvková organizace","count":"9"},{"name":"Gymnázium, Plzeň, Mikulášské nám. 23","count":"2"},{"name":"Hasičský záchranný sbor Olomouckého kraje","count":"2"},{"name":"Institute of Chemical Process Fundamentals of the CAS, v. v. i.","count":"3"},{"name":"Institute of Experimental Botany AS CR, v. v. i.","count":"5"},{"name":"Institute of Geology of the CAS, v. v. i.","count":"1"},{"name":"Institute of Mathematics CAS","count":"3"},{"name":"Institute of Molecular Genetics of the ASCR, v. v. i.","count":"14"},{"name":"Jihoceska vedecka knihovna v Ceskych Budejovicich","count":"3"},{"name":"Jihočeská univerzita v Českých Budějovicích","count":"72"},{"name":"Kerio Technologies s.r.o.","count":"22"},{"name":"Masarykova univerzita","count":"327"},{"name":"Masarykův onkologický ústav","count":"2"},{"name":"Mendelova univerzita v Brně","count":"25"},{"name":"Metropolitan University Prague","count":"4"},{"name":"Ministerstvo školství, mládeže a tělovýchovy","count":"62"},{"name":"Moravská zemská knihovna v Brně","count":"11"},{"name":"Nemocnice Jihlava, příspěvková organizace","count":"19"},{"name":"NÁRODNÍ MUZEUM","count":"3"},{"name":"Národní knihovna České republiky","count":"8"},{"name":"Národní technická knihovna","count":"5"},{"name":"Národní ústav duševního zdraví","count":"2"},{"name":"Ostravská univerzita v Ostravě","count":"28"},{"name":"Plzeňský kraj","count":"1"},{"name":"SPŠ strojnická a SOŠ prof. Švejcara, Plzeň","count":"5"},{"name":"Slezská univerzita v Opavě","count":"25"},{"name":"Studijní a vědecká knihovna v Hradci Králové","count":"4"},{"name":"Středisko služeb školám, Plzeň, Částkova 78","count":"1"},{"name":"Středisko společných činností AV ČR, v. v. i.","count":"120"},{"name":"Střední škola informatiky a právních studií, o.p.s.","count":"1"},{"name":"Technická univerzita v Liberci","count":"149"},{"name":"Univerzita Hradec Králové","count":"16"},{"name":"Univerzita Jana Amose Komenského Praha s.r.o.","count":"4"},{"name":"Univerzita Karlova v Praze","count":"391"},{"name":"Univerzita Palackého v Olomouci","count":"97"},{"name":"Univerzita Pardubice","count":"74"},{"name":"Univerzita Tomáše Bati ve Zlíně","count":"38"},{"name":"Ustav jaderne fyziky AV CR, v. v. i.","count":"11"},{"name":"VOŠ a SPŠE Plzeň","count":"25"},{"name":"Veterinární a farmaceutická univerzita Brno","count":"23"},{"name":"Vysoká škola báňská - Technická univerzita Ostrava","count":"231"},{"name":"Vysoká škola chemicko-technologická v Praze","count":"55"},{"name":"Vysoká škola ekonomická v Praze","count":"319"},{"name":"Vysoká škola evropských a regionálních studií, o.p.s.","count":"2"},{"name":"Vysoká škola polytechnická Jihlava","count":"11"},{"name":"Vysoká škola technická a ekonomická v Českých Budějovicích","count":"11"},{"name":"Vysoká škola uměleckoprůmyslová v Praze","count":"25"},{"name":"Vysoké učení technické v Brně","count":"74"},{"name":"Vyšší odborná škola informačních služeb, Praha 4, Pacovská 350","count":"1"},{"name":"Výzkumný ústav geodetický, topografický a kartografický, v. v. i.","count":"5"},{"name":"Výzkumný ústav vodohospodářský T. G. Masaryka, v. v. i.","count":"1"},{"name":"Vědecká knihovna v Olomouci","count":"2"},{"name":"Všeobecná fakultní nemocnice v Praze","count":"7"},{"name":"Západočeská univerzita v Plzni","count":"138"},{"name":"Ústav anorganické chemie AV ČR, v. v. i.","count":"2"},{"name":"Ústav fotoniky a elektroniky AV ČR, v. v. i.","count":"15"},{"name":"Ústav fyziky materiálů AV ČR, v. v. i.","count":"3"},{"name":"Ústav geoniky AV ČR, v. v. i.","count":"5"},{"name":"Ústav organické chemie a biochemie AV ČR, v. v. i.","count":"15"},{"name":"Ústav přístrojové techniky AV ČR, v. v. i.","count":"2"},{"name":"Ústav teorie informace a automatizace AV ČR, v. v. i.","count":"5"},{"name":"Ústav zemědělské ekonomiky a informací","count":"4"},{"name":"Česká zemědělská univerzita v Praze","count":"34"},{"name":"České vysoké učení technické v Praze","count":"354"}]}';
            json['Ldap'] = '{"organizations":[{"name":"Akademie muzickych umeni v Praze","count":"37"},{"name":"Astronomical Institute of the Czech Academy of Sciences","count":"5"},{"name":"BBMRI-ERIC","count":"11"},{"name":"BRAILCOM, o.p.s.","count":"1"},{"name":"Biology Centre CAS","count":"1"},{"name":"Brno University of Technology","count":"33"},{"name":"CESNET","count":"197"},{"name":"CESNET (CESNET)","count":"4"},{"name":"CESNET (CESNET, zajmove sdruzeni pravnickych osob)","count":"5"},{"name":"CESNET, association of legal entities","count":"1"},{"name":"CESNET, zajmove sdruzeni pravnickych osob","count":"98"},{"name":"CVUT (Czech Technical University in Prague)","count":"2"},{"name":"Centre of Administration and Operations of the ASCR, v. v. i.","count":"7"},{"name":"Centrum vyzkumu globalni zmeny AV CR, v. v. i.","count":"6"},{"name":"Ceska zemedelska univerzita v Praze","count":"2"},{"name":"Ceske vysoke uceni technicke v Praze","count":"127"},{"name":"Charles University in Prague","count":"114"},{"name":"Czech Technical University in Prague","count":"202"},{"name":"Czech University of Life Sciences Prague","count":"31"},{"name":"Fakultni nemocnice Hradec Kralove","count":"3"},{"name":"Fakultni nemocnice Ostrava","count":"1"},{"name":"Fakultni nemocnice Plzen","count":"5"},{"name":"Food Research Institute Prague","count":"1"},{"name":"Fyzikalni ustav AV CR, v. v. i.","count":"16"},{"name":"Fyziologicky ustav AV CR, v. v. i.","count":"2"},{"name":"Grantova agentura Ceske republiky","count":"1"},{"name":"Gymnazium Matyase Lercha, Brno, Zizkova 55, prispevkova organizace","count":"2"},{"name":"Gymnazium, Plzen, Mikulasske nam. 23","count":"2"},{"name":"Hospital Jihlava","count":"2"},{"name":"Institute of Chemical Technology Prague","count":"3"},{"name":"Institute of Experimental Botany AS CR, v. v. i.","count":"2"},{"name":"Institute of Molecular Genetics of the ASCR, v. v. i.","count":"11"},{"name":"Institute of Organic Chemistry and Biochemistry AS CR, v.v.i.","count":"4"},{"name":"Institute of Photonics and Electronics of the AS CR, v.v.i.","count":"1"},{"name":"Institute of Physics AS CR","count":"28"},{"name":"Institute of Physics of Materials AS CR, v. v. i.","count":"1"},{"name":"Institute of Physiology CAS","count":"1"},{"name":"Jihoceska univerzita v Ceskych Budejovicich","count":"20"},{"name":"Kerio Technologies s.r.o.","count":"12"},{"name":"Kerio Technologies sro","count":"6"},{"name":"MUP (Metropolitan University Prague)","count":"4"},{"name":"Masaryk University","count":"161"},{"name":"Masarykova univerzita","count":"135"},{"name":"Masarykuv onkologicky ustav","count":"2"},{"name":"Mendel University in Brno","count":"8"},{"name":"Mendelova univerzita v Brne","count":"17"},{"name":"Moravian Library","count":"2"},{"name":"Moravska zemska knihovna v Brne","count":"9"},{"name":"Narodni knihovna Ceske republiky","count":"5"},{"name":"Narodni technicka knihovna","count":"3"},{"name":"Narodni ustav dusevniho zdravi","count":"2"},{"name":"Nemocnice Jihlava, prispevkova organizace","count":"2"},{"name":"Ostravska univerzita v Ostrave","count":"24"},{"name":"Palacky University Olomouc","count":"38"},{"name":"Research Library in Olomouc","count":"1"},{"name":"SPS strojnicka a SOS prof. Svejcara, Plzen","count":"4"},{"name":"Silesian University in Opava","count":"9"},{"name":"Slezska univerzita v Opave","count":"16"},{"name":"Stredisko spolecnych cinnosti AV CR, v. v. i.","count":"108"},{"name":"Technical University of Liberec","count":"83"},{"name":"Technicka univerzita v Liberci","count":"42"},{"name":"The National Library of the Czech Republic","count":"3"},{"name":"UPCE (University of Pardubice)","count":"1"},{"name":"University Hospital Hradec Kralove","count":"6"},{"name":"University of Chemistry and Technology, Prague","count":"25"},{"name":"University of Economics, Prague","count":"271"},{"name":"University of Hradec Kralove","count":"3"},{"name":"University of Ostrava","count":"3"},{"name":"University of Pardubice","count":"22"},{"name":"University of South Bohemia in Ceske Budejovice","count":"47"},{"name":"University of Veterinary and Pharmaceutical Sciences Brno","count":"3"},{"name":"University of West Bohemia","count":"15"},{"name":"Univerzita Hradec Kralove","count":"13"},{"name":"Univerzita Karlova v Praze","count":"178"},{"name":"Univerzita Palackeho v Olomouci","count":"45"},{"name":"Univerzita Pardubice","count":"47"},{"name":"Univerzita Tomase Bati ve Zline","count":"35"},{"name":"Ustav anorganicke chemie AV CR, v. v. i.","count":"2"},{"name":"Ustav fotoniky a elektroniky AV CR, v. v. i.","count":"3"},{"name":"Ustav fyziky materialu AV CR, v. v. i.","count":"1"},{"name":"Ustav jaderne fyziky AV CR, v. v. i.","count":"9"},{"name":"Ustav teorie informace a automatizace AV CR, v. v. i.","count":"2"},{"name":"VOS a SPSE Plzen","count":"21"},{"name":"VSB-Technical University of Ostrava","count":"130"},{"name":"Veterinarni a farmaceuticka univerzita Brno","count":"16"},{"name":"Vseobecna fakultni nemocnice v Praze","count":"6"},{"name":"Vysoka skola banska - Technicka univerzita Ostrava","count":"77"},{"name":"Vysoka skola chemicko-technologicka v Praze","count":"27"},{"name":"Vysoka skola ekonomicka v Praze","count":"36"},{"name":"Vysoka skola polytechnicka Jihlava","count":"10"},{"name":"Vysoka skola umeleckoprumyslova v Praze","count":"22"},{"name":"Vysoke uceni technicke v Brne","count":"39"},{"name":"Vyssi odborna skola informacnich sluzeb, Praha 4, Pacovska 350","count":"1"},{"name":"Vyzkumny ustav geodeticky, topograficky a kartograficky, v. v. i.","count":"5"},{"name":"Vyzkumny ustav vodohospodarsky T. G. Masaryka, v. v. i.","count":"1"},{"name":"Zapadoceska univerzita v Plzni","count":"120"}]}';
            json['Ejbca'] = '{"organizations":[{"name":"Academy of Arts Architecture and Design Prague","count":"1"},{"name":"Academy of Performing Arts in Prague","count":"1"},{"name":"Academy of Sciences Library","count":"1"},{"name":"Anglo-Czech High School","count":"1"},{"name":"Biology Centre of the ASCR, v. v. i.","count":"1"},{"name":"Brailcom","count":"1"},{"name":"CESNET","count":"152"},{"name":"CESNET, z.s.p.o.","count":"1"},{"name":"CTU in Prague","count":"1020"},{"name":"CZ.NIC","count":"3"},{"name":"Center for School Services Pilsen","count":"2"},{"name":"Centre for Higher Education Studies","count":"1"},{"name":"Centre for Innovation and Projects, VSTE","count":"2"},{"name":"Centre of Administration and Operations, ASCR","count":"15"},{"name":"Charles University in Prague","count":"2"},{"name":"College of Media and Journalism","count":"2"},{"name":"College of Polytechnics Jihlava","count":"3"},{"name":"Czech - Slavonic Business Academy of Doctor Edvard Benes","count":"1"},{"name":"Czech Science Foundation","count":"1"},{"name":"Czech University of Life Sciences Prague","count":"4"},{"name":"Department of Agricultural Economics and Information","count":"3"},{"name":"FZU","count":"1"},{"name":"Fire Rescue Service of Olomouc Region","count":"1"},{"name":"General Faculty Hospital in Prague","count":"1"},{"name":"Global Change Research Center, ASCR","count":"1"},{"name":"Gymnazium Cheb","count":"1"},{"name":"High School of Chemistry in Pardubice","count":"1"},{"name":"High School of Civil Engineering Liberec","count":"2"},{"name":"High School of Informatics and Financial Services","count":"2"},{"name":"Higher Professional School of Information Services","count":"1"},{"name":"Hospital Jihlava","count":"3"},{"name":"Hotel school Podebrady","count":"1"},{"name":"Institute of Archeology of the Academy of Sciences of the CR","count":"1"},{"name":"Institute of Biophysics, Academy of Sciences of the CR","count":"1"},{"name":"Institute of Botany of the Academy of Science of the CR","count":"1"},{"name":"Institute of Chemical Process Fundamentals, ASCR","count":"2"},{"name":"Institute of Chemical Technology, Prague","count":"2"},{"name":"Institute of Computer Science, ASCR, v.v.i.","count":"5"},{"name":"Institute of Czech Literature AS CR","count":"1"},{"name":"Institute of Geonics of the Academy of Sciences of the CR","count":"1"},{"name":"Institute of Information Theory and Automation, ASCR","count":"1"},{"name":"Institute of Macromolecular Chemistry, ASCR","count":"1"},{"name":"Institute of Mathematics, ASCR","count":"1"},{"name":"Institute of Microbiology of the Academy of Sciences of the Czech Republic, v.v.i.","count":"2"},{"name":"Institute of Molecular Genetics, ASCR","count":"2"},{"name":"Institute of Organic Chemistry and Biochemistry, ASCR","count":"5"},{"name":"Institute of Philosophy of the Academy of Sciences of the Czech Republic, v.v.i.","count":"1"},{"name":"Institute of Physical Chemistry, ASCR","count":"6"},{"name":"Institute of Physics of Materials of the Academy of Sciences of the CR","count":"1"},{"name":"Institute of Physics of Materials, ASCR","count":"1"},{"name":"Institute of Physics of the Academy of Sciences of the CR","count":"16"},{"name":"Institute of Plasma Physics, Academy of Sciences of the CR","count":"2"},{"name":"Institute of Rock Structure and Mechanics of the ASCR, v.v.i.","count":"1"},{"name":"Institute of Scientific Instruments, ASCR","count":"1"},{"name":"Institute of Theoretical and Applied Mechanics, v.v.i.","count":"1"},{"name":"Institute of Thermomechanics, Academy of Sciences of the CR","count":"4"},{"name":"JCU","count":"2"},{"name":"Jan Amos Komensky University Prague","count":"1"},{"name":"Janacek Academy of Music and Performing Arts in Brno","count":"1"},{"name":"Kerio Technologies s.r.o.","count":"1"},{"name":"Klet Observatory","count":"4"},{"name":"MUNI","count":"4"},{"name":"Masaryk Grammar School","count":"2"},{"name":"Masaryk Memorial Cancer Institute","count":"2"},{"name":"Masaryk University","count":"7"},{"name":"Mathias Lerch Gymnasium","count":"2"},{"name":"Mendel University in Brno","count":"2"},{"name":"Metropolitan University Prague","count":"1"},{"name":"Ministry of Education, Youth and Sports","count":"2"},{"name":"Moravian Library","count":"4"},{"name":"Moravian University College Olomouc","count":"3"},{"name":"Moravian-Silesian Research Library in Ostrava","count":"1"},{"name":"Municipal Library Ceska Trebova","count":"1"},{"name":"Municipal Library of Prague","count":"1"},{"name":"National Institute of Mental Health","count":"3"},{"name":"National Library of the Czech Republic","count":"2"},{"name":"National Medical Library","count":"1"},{"name":"National Museum","count":"2"},{"name":"National Technical Library","count":"4"},{"name":"Nuclear Physics Institute of the Academy of Sciences of the CR","count":"2"},{"name":"OSVC","count":"1"},{"name":"Pilsen Region","count":"4"},{"name":"Private Secondary School of Information Technologies","count":"1"},{"name":"Research Library in Olomouc","count":"2"},{"name":"Secondary School of Applied Cybernetics","count":"1"},{"name":"Secondary School of Electrotechnics and Informatics, Ostrava","count":"2"},{"name":"Secondary Technical School of Electrical Engineering and Technology College in Pisek","count":"1"},{"name":"Secondary Technical School of Mechanical Engineering, Pilsen","count":"3"},{"name":"Secondary school and College of Transport, Pilsen","count":"1"},{"name":"Secondary technical school, UL","count":"1"},{"name":"Silesian University","count":"1"},{"name":"Softweco Group","count":"1"},{"name":"State institute for drug control","count":"2"},{"name":"Technical University of Liberec","count":"1"},{"name":"Technology Agency of the Czech Republic","count":"4"},{"name":"Technology Centre ASCR","count":"1"},{"name":"Tertiary College and Secondary School of Electrical Engineering, Pilsen","count":"2"},{"name":"The Education and Research Library of the Pilsener Region","count":"1"},{"name":"The Institute of Hospitality Management","count":"2"},{"name":"The National Pedagogical Museum and Library of J. A. Comenius","count":"1"},{"name":"The Regional Research Library in Liberec","count":"2"},{"name":"The Research Library in Ceske Budejovice","count":"1"},{"name":"The Research Library in Hradec Kralove","count":"2"},{"name":"The University Hospital Brno","count":"5"},{"name":"Tomas Bata University in Zlin","count":"2"},{"name":"University Hospital Ostrava","count":"1"},{"name":"University hospital Hradec Kralove","count":"2"},{"name":"University of Defence in Brno","count":"4"},{"name":"University of Economics, Prague","count":"4"},{"name":"University of Hradec Kralove","count":"4"},{"name":"University of J. E. Purkyne","count":"1"},{"name":"University of Ostrava","count":"1"},{"name":"University of Pardubice","count":"3"},{"name":"University of South Bohemia Ceske Budejovice","count":"1"},{"name":"University of Veterinary and Pharmaceutical Sciences Brno","count":"6"},{"name":"University of West Bohemia","count":"2"},{"name":"Vysocina Region","count":"5"},{"name":"ZCU","count":"1"},{"name":"Zapadoceska univerzita v Plzni","count":"636"}]}';
        
            google.charts.setOnLoadCallback(function(){ drawChart('Digicert'); });
            google.charts.setOnLoadCallback(function(){ drawChart('Ldap'); });
            google.charts.setOnLoadCallback(function(){ drawChart('Ejbca'); });
        </script>
        
    </head>
    <body style="background-color: #ccc">
        
        <h1 class="mainTitle">List of certificates</h1>
        <div id="css-table">
            
<!--------------------------------------------------------------------------------------------------->
            <div class="collumn thirdScreen">
                <div class="title">
                    <h2 style="margin-top: 0;"><a href="digicert.jsp">DIGICERT</a></h2>
                    <input type="file" id="filesDigicert"/> 
                    <span id="btnReadFileDigicert">
                        <button type="button">update page</button>
                    </span>
                </div>
                <br>
                <a href="#" onClick ="exportCSV('Digicert', 'digicert_' + '<%=date%>')">Export to CSV</a>
                <br>
                <div>
                    <p class="labelSelectBox"> Displayed organisations </p>
                    <p class="labelSelectBox"> Hidden organisations </p>
                </div>
                <br>
                <div class="selectDiv">

                    <select class="center" name="selectedDatas[]" id="MasterSelectBoxDigicert" multiple="multiple" style="height: 200px"></select>

                    <div class="arrows">
                        <button id="btnAddDigicert" type="button">&gt;</button><br>
                        <button id="btnRemoveDigicert" type="button">&lt;</button>
                    </div>

                    <select class="center" name="hiddenDatas[]" id="PairedSelectBoxDigicert" multiple="multiple" style="height: 200px"></select>
                </div>

                <div class="labelSelectBox">
                    <label>sort:</label><br>
                    <form id="MasterDigicert">
                        <input type="radio" name="MasterDigicert" value="MasterDigicertAbc" onchange="sortMasterByName('Digicert')" checked> by alphabeth<br>
                        <input type="radio" name="MasterDigicert" value="MasterDigicertNum" onchange="sortMasterByValue('Digicert')"> by number of CAs<br>
                    </form>
                </div>
                <div class="labelSelectBox">
                    <label>sort:</label><br>
                    <form id="PairedDigicert">
                        <input type="radio" name="PairedDigicert" value="PairedDigicertAbc" onchange="sortPairedByName('Digicert')" checked> by alphabet<br>
                        <input type="radio" name="PairedDigicert" value="PairedDigicertNum" onchange="sortPairedByValue('Digicert')" > by number of CAs<br> 
                    </form>
                </div>
                <br><br><br><br><br>

                <div class="sliderDiv">

                    <p>Your slider has a value of <span id="sliderValueDigicert"></span></p>
                    <button id="btnSliderDigicert" type="button">Set minimum number of valid CAss</button>

                    <div id="sliderDigicert" class="slider"></div>

                </div>
                <br>

                <div id="chartVerticalDigicert"></div> 

                <div><br></div> 
                <div id="chartHorizontalDigicert"></div> 
                <div><br></div> 
                <div id="tableDigicert"></div>
            </div>
<!--------------------------------------------------------------------------------------------------->
            <div class="collumn thirdScreen">
                <div class="title">
                    <h2 style="margin-top: 0;"><a href="ldap.jsp">LDAP</a></h2>
                    <!--<input type="file" id="filesLdap"/>--> 
                    <button type="button">Browse...</button>
                    <span id="btnReadFileLdap">
                        <button type="button">update page</button>
                    </span>
                </div>
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
            <div class="collumn thirdScreen">
                <div class="title">
                    <h2 style="margin-top: 0;"><a href="ejbca.jsp">EJBCA</a></h2>
                    <input type="file" id="filesEjbca"/> 
                    <span id="btnReadFileEjbca">
                        <button type="button">update page</button>
                    </span>
                </div>
                <br>
                <a href="#" onClick ="exportCSV('Ejbca', 'ejbca_' + '<%=date%>')">Export to CSV</a>
                <br>
                <div>
                    <p class="labelSelectBox"> Displayed organisations </p>
                    <p class="labelSelectBox"> Hidden organisations </p>
                </div>
                <br>
                <div class="selectDiv">

                    <select class="center" name="selectedDatas[]" id="MasterSelectBoxEjbca" multiple="multiple" style="height: 200px"></select>

                    <div class="arrows">
                        <button id="btnAddEjbca" type="button">&gt;</button><br>
                        <button id="btnRemoveEjbca" type="button">&lt;</button>
                    </div>

                    <select class="center" name="hiddenDatas[]" id="PairedSelectBoxEjbca" multiple="multiple" style="height: 200px"></select>
                </div>

                <div class="labelSelectBox">
                    <label>sort:</label><br>
                    <form id="MasterEjbca">
                        <input type="radio" name="MasterEjbca" value="MasterEjbcaAbc" onchange="sortMasterByName('Ejbca')" checked> by alphabeth<br>
                        <input type="radio" name="MasterEjbca" value="MasterEjbcaNum" onchange="sortMasterByValue('Ejbca')"> by number of CAs<br>
                    </form>
                </div>
                <div class="labelSelectBox">
                    <label>sort:</label><br>
                    <form id="PairedEjbca">
                        <input type="radio" name="PairedEjbca" value="PairedEjbcaAbc" onchange="sortPairedByName('Ejbca')" checked> by alphabet<br>
                        <input type="radio" name="PairedEjbca" value="PairedEjbcaNum" onchange="sortPairedByValue('Ejbca')" > by number of CAs<br> 
                    </form>
                </div>
                <br><br><br><br><br>

                <div class="sliderDiv">

                    <p>Your slider has a value of <span id="sliderValueEjbca"></span></p>
                    <button id="btnSliderEjbca" type="button">Set minimum number of valid CAss</button>

                    <div id="sliderEjbca" class="slider"></div>

                </div>
                <br>

                <div id="chartVerticalEjbca"></div> 

                <div><br></div> 
                <div id="chartHorizontalEjbca"></div> 
                <div><br></div> 
                <div id="tableEjbca"></div>
            </div>
<!--------------------------------------------------------------------------------------------------->
        </div>
    </body>
</html>