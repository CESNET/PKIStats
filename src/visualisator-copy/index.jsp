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
        <% String json_ldap = connector.getJSON("ldap"); %>
                
        <% String date = connector.getDate(); %>
        
        <script>
            var initialDate = '<%=date%>';
            date['Digicert'] = initialDate;
            date['Ldap'] = initialDate;
            date['Ejbca'] = initialDate;
            
            json['Digicert'] = '{"Akademie múzických umění v Praze":37,"Astronomical Institute of the Czech Academy of Sciences":14,"BBMRI-ERIC":11,"BRAILCOM, o.p.s.":1,"Biologické centrum AV ČR, v. v. i.":4,"Brno University of Technology":74,"CESNET, zájmové sdružení právnických osob":510,"Centrum výzkumu globální změny AV ČR, v. v. i.":6,"Czech University of Life Sciences Prague":34,"Fakultní nemocnice Brno":3,"Fakultní nemocnice Hradec Králové":16,"Fakultní nemocnice Ostrava":6,"Fakultní nemocnice Plzeň":7,"Food Research Institute Prague":1,"Fyziologický ústav AV ČR, v. v. i.":5,"Grantová agentura České republiky":1,"Gymnázium Matyáše Lercha, Brno, Žižkova 55, příspěvková organizace":9,"Gymnázium, Plzeň, Mikulášské nám. 23":2,"Hasičský záchranný sbor Olomouckého kraje":2,"Institute of Chemical Process Fundamentals of the CAS, v. v. i.":3,"Institute of Experimental Botany AS CR, v. v. i.":5,"Institute of Geology of the CAS, v. v. i.":1,"Institute of Information Theory and Automation of the ASCR":5,"Institute of Mathematics CAS":3,"Institute of Molecular Genetics of the ASCR, v. v. i.":14,"Institute of Photonics and Electronics of the AS CR, v.v.i.":15,"Institute of Physics AS CR":45,"Institute of Physics of Materials AS CR, v. v. i.":3,"Jihoceska vedecka knihovna v Ceskych Budejovicich":3,"Jihočeská univerzita v Českých Budějovicích":72,"Kerio Technologies s.r.o.":22,"Masaryk University":327,"Masarykův onkologický ústav":2,"Mendelova univerzita v Brně":25,"Metropolitan University Prague":4,"Ministerstvo školství, mládeže a tělovýchovy":62,"Moravska zemska knihovna v Brne":11,"Nemocnice Jihlava, prispevkova organizace":19,"NÁRODNÍ MUZEUM":3,"Národní knihovna České republiky":8,"Národní technická knihovna":5,"Národní ústav duševního zdraví":2,"Ostravská univerzita v Ostravě":28,"Plzeňský kraj":1,"Research Library in Olomouc":2,"SPŠ strojnická a SOŠ prof. Švejcara, Plzeň":5,"Silesian University in Opava":25,"Studijní a vědecká knihovna v Hradci Králové":4,"Středisko služeb školám, Plzeň, Částkova 78":1,"Středisko společných činností AV ČR, v. v. i.":120,"Střední škola informatiky a právních studií, o.p.s.":1,"Technická univerzita v Liberci":149,"University of Chemistry and Technology, Prague":55,"University of Economics, Prague":319,"University of Pardubice":74,"Univerzita Hradec Králové":16,"Univerzita Jana Amose Komenského Praha s.r.o.":4,"Univerzita Karlova v Praze":391,"Univerzita Palackého v Olomouci":97,"Univerzita Tomáše Bati ve Zlíně":38,"Ustav jaderne fyziky AV CR, v. v. i.":11,"Ustav organicke chemie a biochemie AV CR, v. v. i.":15,"VOŠ a SPŠE Plzeň":25,"VSB-Technical University of Ostrava":231,"Veterinární a farmaceutická univerzita Brno":23,"Vysoká škola evropských a regionálních studií, o.p.s.":2,"Vysoká škola polytechnická Jihlava":11,"Vysoká škola technická a ekonomická v Českých Budějovicích":11,"Vysoká škola uměleckoprůmyslová v Praze":25,"Vyšší odborná škola informačních služeb, Praha 4, Pacovská 350":1,"Výzkumný ústav geodetický, topografický a kartografický, v. v. i.":5,"Výzkumný ústav vodohospodářský T. G. Masaryka, v. v. i.":1,"Všeobecná fakultní nemocnice v Praze":7,"Západočeská univerzita v Plzni":138,"Ústav anorganické chemie AV ČR, v. v. i.":2,"Ústav geoniky AV ČR, v. v. i.":5,"Ústav přístrojové techniky AV ČR, v. v. i.":2,"Ústav zemědělské ekonomiky a informací":4,"České vysoké učení technické v Praze":355}';
            json['Ldap'] = '{"Akademie muzickych umeni v Praze":37,"Astronomical Institute of the Czech Academy of Sciences":5,"BBMRI-ERIC":11,"BRAILCOM, o.p.s.":1,"Biology Centre CAS":1,"Brno University of Technology":33,"CESNET":197,"CESNET (CESNET)":4,"CESNET (CESNET, zajmove sdruzeni pravnickych osob)":5,"CESNET, association of legal entities":1,"CESNET, zajmove sdruzeni pravnickych osob":98,"CVUT (Czech Technical University in Prague)":2,"Centre of Administration and Operations of the ASCR, v. v. i.":7,"Centrum vyzkumu globalni zmeny AV CR, v. v. i.":6,"Ceska zemedelska univerzita v Praze":2,"Ceske vysoke uceni technicke v Praze":127,"Charles University in Prague":114,"Czech Technical University in Prague":202,"Czech University of Life Sciences Prague":31,"Fakultni nemocnice Hradec Kralove":3,"Fakultni nemocnice Ostrava":1,"Fakultni nemocnice Plzen":5,"Food Research Institute Prague":1,"Fyzikalni ustav AV CR, v. v. i.":16,"Fyziologicky ustav AV CR, v. v. i.":2,"Grantova agentura Ceske republiky":1,"Gymnazium Matyase Lercha, Brno, Zizkova 55, prispevkova organizace":2,"Gymnazium, Plzen, Mikulasske nam. 23":2,"Hospital Jihlava":2,"Institute of Chemical Technology Prague":3,"Institute of Experimental Botany AS CR, v. v. i.":2,"Institute of Molecular Genetics of the ASCR, v. v. i.":11,"Institute of Organic Chemistry and Biochemistry AS CR, v.v.i.":4,"Institute of Photonics and Electronics of the AS CR, v.v.i.":1,"Institute of Physics AS CR":28,"Institute of Physics of Materials AS CR, v. v. i.":1,"Institute of Physiology CAS":1,"Jihoceska univerzita v Ceskych Budejovicich":20,"Kerio Technologies s.r.o.":12,"Kerio Technologies sro":6,"MUP (Metropolitan University Prague)":4,"Masaryk University":161,"Masarykova univerzita":135,"Masarykuv onkologicky ustav":2,"Mendel University in Brno":8,"Mendelova univerzita v Brne":17,"Moravian Library":2,"Moravska zemska knihovna v Brne":9,"Narodni knihovna Ceske republiky":5,"Narodni technicka knihovna":3,"Narodni ustav dusevniho zdravi":2,"Nemocnice Jihlava, prispevkova organizace":2,"Ostravska univerzita v Ostrave":24,"Palacky University Olomouc":38,"Research Library in Olomouc":1,"SPS strojnicka a SOS prof. Svejcara, Plzen":4,"Silesian University in Opava":9,"Slezska univerzita v Opave":16,"Stredisko spolecnych cinnosti AV CR, v. v. i.":108,"Technical University of Liberec":83,"Technicka univerzita v Liberci":42,"The National Library of the Czech Republic":3,"UPCE (University of Pardubice)":1,"University Hospital Hradec Kralove":6,"University of Chemistry and Technology, Prague":25,"University of Economics, Prague":271,"University of Hradec Kralove":3,"University of Ostrava":3,"University of Pardubice":22,"University of South Bohemia in Ceske Budejovice":47,"University of Veterinary and Pharmaceutical Sciences Brno":3,"University of West Bohemia":15,"Univerzita Hradec Kralove":13,"Univerzita Karlova v Praze":178,"Univerzita Palackeho v Olomouci":45,"Univerzita Pardubice":47,"Univerzita Tomase Bati ve Zline":35,"Ustav anorganicke chemie AV CR, v. v. i.":2,"Ustav fotoniky a elektroniky AV CR, v. v. i.":3,"Ustav fyziky materialu AV CR, v. v. i.":1,"Ustav jaderne fyziky AV CR, v. v. i.":9,"Ustav teorie informace a automatizace AV CR, v. v. i.":2,"VOS a SPSE Plzen":21,"VSB-Technical University of Ostrava":130,"Veterinarni a farmaceuticka univerzita Brno":16,"Vseobecna fakultni nemocnice v Praze":6,"Vysoka skola banska - Technicka univerzita Ostrava":77,"Vysoka skola chemicko-technologicka v Praze":27,"Vysoka skola ekonomicka v Praze":36,"Vysoka skola polytechnicka Jihlava":10,"Vysoka skola umeleckoprumyslova v Praze":22,"Vysoke uceni technicke v Brne":39,"Vyssi odborna skola informacnich sluzeb, Praha 4, Pacovska 350":1,"Vyzkumny ustav geodeticky, topograficky a kartograficky, v. v. i.":5,"Vyzkumny ustav vodohospodarsky T. G. Masaryka, v. v. i.":1,"Zapadoceska univerzita v Plzni":120}';
            json['Ejbca'] = '{"Academy of Arts Architecture and Design Prague":1,"Academy of Performing Arts in Prague":1,"Academy of Sciences Library":1,"Anglo-Czech High School":1,"Biology Centre of the ASCR, v. v. i.":1,"Brailcom":1,"CESNET":152,"CESNET, z.s.p.o.":1,"CTU in Prague":1020,"CZ.NIC":3,"Center for School Services Pilsen":2,"Centre for Higher Education Studies":1,"Centre for Innovation and Projects, VSTE":2,"Centre of Administration and Operations, ASCR":15,"Charles University in Prague":2,"College of Media and Journalism":2,"College of Polytechnics Jihlava":3,"Czech - Slavonic Business Academy of Doctor Edvard Benes":1,"Czech Science Foundation":1,"Czech University of Life Sciences Prague":4,"Department of Agricultural Economics and Information":3,"FZU":1,"Fire Rescue Service of Olomouc Region":1,"General Faculty Hospital in Prague":1,"Global Change Research Center, ASCR":1,"Gymnazium Cheb":1,"High School of Chemistry in Pardubice":1,"High School of Civil Engineering Liberec":2,"High School of Informatics and Financial Services":2,"Higher Professional School of Information Services":1,"Hospital Jihlava":3,"Hotel school Podebrady":1,"Institute of Archeology of the Academy of Sciences of the CR":1,"Institute of Biophysics, Academy of Sciences of the CR":1,"Institute of Botany of the Academy of Science of the CR":1,"Institute of Chemical Process Fundamentals, ASCR":2,"Institute of Chemical Technology, Prague":2,"Institute of Computer Science, ASCR, v.v.i.":5,"Institute of Czech Literature AS CR":1,"Institute of Geonics of the Academy of Sciences of the CR":1,"Institute of Information Theory and Automation, ASCR":1,"Institute of Macromolecular Chemistry, ASCR":1,"Institute of Mathematics, ASCR":1,"Institute of Microbiology of the Academy of Sciences of the Czech Republic, v.v.i.":2,"Institute of Molecular Genetics, ASCR":2,"Institute of Organic Chemistry and Biochemistry, ASCR":5,"Institute of Philosophy of the Academy of Sciences of the Czech Republic, v.v.i.":1,"Institute of Physical Chemistry, ASCR":6,"Institute of Physics of Materials of the Academy of Sciences of the CR":1,"Institute of Physics of Materials, ASCR":1,"Institute of Physics of the Academy of Sciences of the CR":16,"Institute of Plasma Physics, Academy of Sciences of the CR":2,"Institute of Rock Structure and Mechanics of the ASCR, v.v.i.":1,"Institute of Scientific Instruments, ASCR":1,"Institute of Theoretical and Applied Mechanics, v.v.i.":1,"Institute of Thermomechanics, Academy of Sciences of the CR":4,"JCU":2,"Jan Amos Komensky University Prague":1,"Janacek Academy of Music and Performing Arts in Brno":1,"Kerio Technologies s.r.o.":1,"Klet Observatory":4,"MUNI":4,"Masaryk Grammar School":2,"Masaryk Memorial Cancer Institute":2,"Masaryk University":7,"Mathias Lerch Gymnasium":2,"Mendel University in Brno":2,"Metropolitan University Prague":1,"Ministry of Education, Youth and Sports":2,"Moravian Library":4,"Moravian University College Olomouc":3,"Moravian-Silesian Research Library in Ostrava":1,"Municipal Library Ceska Trebova":1,"Municipal Library of Prague":1,"National Institute of Mental Health":3,"National Library of the Czech Republic":2,"National Medical Library":1,"National Museum":2,"National Technical Library":4,"Nuclear Physics Institute of the Academy of Sciences of the CR":2,"OSVC":1,"Pilsen Region":4,"Private Secondary School of Information Technologies":1,"Research Library in Olomouc":2,"Secondary School of Applied Cybernetics":1,"Secondary School of Electrotechnics and Informatics, Ostrava":2,"Secondary Technical School of Electrical Engineering and Technology College in Pisek":1,"Secondary Technical School of Mechanical Engineering, Pilsen":3,"Secondary school and College of Transport, Pilsen":1,"Secondary technical school, UL":1,"Silesian University":1,"Softweco Group":1,"State institute for drug control":2,"Technical University of Liberec":1,"Technology Agency of the Czech Republic":4,"Technology Centre ASCR":1,"Tertiary College and Secondary School of Electrical Engineering, Pilsen":2,"The Education and Research Library of the Pilsener Region":1,"The Institute of Hospitality Management":2,"The National Pedagogical Museum and Library of J. A. Comenius":1,"The Regional Research Library in Liberec":2,"The Research Library in Ceske Budejovice":1,"The Research Library in Hradec Kralove":2,"The University Hospital Brno":5,"Tomas Bata University in Zlin":2,"University Hospital Ostrava":1,"University hospital Hradec Kralove":2,"University of Defence in Brno":4,"University of Economics, Prague":4,"University of Hradec Kralove":4,"University of J. E. Purkyne":1,"University of Ostrava":1,"University of Pardubice":3,"University of South Bohemia Ceske Budejovice":1,"University of Veterinary and Pharmaceutical Sciences Brno":6,"University of West Bohemia":2,"Vysocina Region":5,"ZCU":1,"Zapadoceska univerzita v Plzni":636}';
        </script>
        
    </head>
    <body>
        
        <div id="css-table">
<!--------------------------------------------------------------------------------------------------->
            <div class="collumn thirdScreen">
                <div class="center">
                    <h1>DIGICERT</h1>
                    <input type="file" id="filesDigicert"/> 
                    <span id="btnReadFileDigicert">
                        <button type="button">update page</button>
                    </span>
                </div>
                <br>
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
                <div class="center">
                    <h1><a href="ldap.jsp">LDAP</a></h1>
                    <!--<input type="file" id="filesLdap"/>--> 
                    <button type="button">Browse...</button> yet unsupported    . . .
                    <span id="btnReadFileLdap">
                        <button type="button">update page</button>
                    </span>
                </div>
                <br>
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
                <div class="center">
                    <h1>EJBCA</h1>
                    <input type="file" id="filesEjbca"/> 
                    <span id="btnReadFileEjbca">
                        <button type="button">update page</button>
                    </span>
                </div>
                <br>
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