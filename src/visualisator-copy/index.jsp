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
            date['Ejbca'] = initialDate;
            date['Ldap'] = initialDate;
            date['Digicert'] = initialDate;
            
            json['Ldap'] = '<%=json_ldap%>';
            json['Ejbca'] = '{"Academy of Arts Architecture and Design Prague":1,"Academy of Performing Arts in Prague":1,"Academy of Sciences Library":1,"Anglo-Czech High School":1,"Biology Centre of the ASCR, v. v. i.":1,"Brailcom":1,"CESNET":152,"CESNET, z.s.p.o.":1,"CTU in Prague":1020,"CZ.NIC":3,"Center for School Services Pilsen":2,"Centre for Higher Education Studies":1,"Centre for Innovation and Projects, VSTE":2,"Centre of Administration and Operations, ASCR":15,"Charles University in Prague":2,"College of Media and Journalism":2,"College of Polytechnics Jihlava":3,"Czech - Slavonic Business Academy of Doctor Edvard Benes":1,"Czech Science Foundation":1,"Czech University of Life Sciences Prague":4,"Department of Agricultural Economics and Information":3,"FZU":1,"Fire Rescue Service of Olomouc Region":1,"General Faculty Hospital in Prague":1,"Global Change Research Center, ASCR":1,"Gymnazium Cheb":1,"High School of Chemistry in Pardubice":1,"High School of Civil Engineering Liberec":2,"High School of Informatics and Financial Services":2,"Higher Professional School of Information Services":1,"Hospital Jihlava":3,"Hotel school Podebrady":1,"Institute of Archeology of the Academy of Sciences of the CR":1,"Institute of Biophysics, Academy of Sciences of the CR":1,"Institute of Botany of the Academy of Science of the CR":1,"Institute of Chemical Process Fundamentals, ASCR":2,"Institute of Chemical Technology, Prague":2,"Institute of Computer Science, ASCR, v.v.i.":5,"Institute of Czech Literature AS CR":1,"Institute of Geonics of the Academy of Sciences of the CR":1,"Institute of Information Theory and Automation, ASCR":1,"Institute of Macromolecular Chemistry, ASCR":1,"Institute of Mathematics, ASCR":1,"Institute of Microbiology of the Academy of Sciences of the Czech Republic, v.v.i.":2,"Institute of Molecular Genetics, ASCR":2,"Institute of Organic Chemistry and Biochemistry, ASCR":5,"Institute of Philosophy of the Academy of Sciences of the Czech Republic, v.v.i.":1,"Institute of Physical Chemistry, ASCR":6,"Institute of Physics of Materials of the Academy of Sciences of the CR":1,"Institute of Physics of Materials, ASCR":1,"Institute of Physics of the Academy of Sciences of the CR":16,"Institute of Plasma Physics, Academy of Sciences of the CR":2,"Institute of Rock Structure and Mechanics of the ASCR, v.v.i.":1,"Institute of Scientific Instruments, ASCR":1,"Institute of Theoretical and Applied Mechanics, v.v.i.":1,"Institute of Thermomechanics, Academy of Sciences of the CR":4,"JCU":2,"Jan Amos Komensky University Prague":1,"Janacek Academy of Music and Performing Arts in Brno":1,"Kerio Technologies s.r.o.":1,"Klet Observatory":4,"MUNI":4,"Masaryk Grammar School":2,"Masaryk Memorial Cancer Institute":2,"Masaryk University":7,"Mathias Lerch Gymnasium":2,"Mendel University in Brno":2,"Metropolitan University Prague":1,"Ministry of Education, Youth and Sports":2,"Moravian Library":4,"Moravian University College Olomouc":3,"Moravian-Silesian Research Library in Ostrava":1,"Municipal Library Ceska Trebova":1,"Municipal Library of Prague":1,"National Institute of Mental Health":3,"National Library of the Czech Republic":2,"National Medical Library":1,"National Museum":2,"National Technical Library":4,"Nuclear Physics Institute of the Academy of Sciences of the CR":2,"OSVC":1,"Pilsen Region":4,"Private Secondary School of Information Technologies":1,"Research Library in Olomouc":2,"Secondary School of Applied Cybernetics":1,"Secondary School of Electrotechnics and Informatics, Ostrava":2,"Secondary Technical School of Electrical Engineering and Technology College in Pisek":1,"Secondary Technical School of Mechanical Engineering, Pilsen":3,"Secondary school and College of Transport, Pilsen":1,"Secondary technical school, UL":1,"Silesian University":1,"Softweco Group":1,"State institute for drug control":2,"Technical University of Liberec":1,"Technology Agency of the Czech Republic":4,"Technology Centre ASCR":1,"Tertiary College and Secondary School of Electrical Engineering, Pilsen":2,"The Education and Research Library of the Pilsener Region":1,"The Institute of Hospitality Management":2,"The National Pedagogical Museum and Library of J. A. Comenius":1,"The Regional Research Library in Liberec":2,"The Research Library in Ceske Budejovice":1,"The Research Library in Hradec Kralove":2,"The University Hospital Brno":5,"Tomas Bata University in Zlin":2,"University Hospital Ostrava":1,"University hospital Hradec Kralove":2,"University of Defence in Brno":4,"University of Economics, Prague":4,"University of Hradec Kralove":4,"University of J. E. Purkyne":1,"University of Ostrava":1,"University of Pardubice":3,"University of South Bohemia Ceske Budejovice":1,"University of Veterinary and Pharmaceutical Sciences Brno":6,"University of West Bohemia":2,"Vysocina Region":5,"ZCU":1,"Západočeská univerzita v Plzni":636}';
            json['Digicert'] = '{"Charles University in Prague":1073,"Institute of Photonics and Electronics of the AS CR, v.v.i.":40,"Fakultní nemocnice Ostrava":17,"CESNET":1423,"Janáčkova akademie múzických umění v Brně":4,"Fyzikální ústav AV ČR, v. v. i.":118,"Czech University of Life Sciences Prague":95,"Středisko společných činností AV ČR, v. v. i.":287,"Univerzita Palackého v Olomouci":266,"SPŠ strojnická a SOŠ prof. Švejcara, Plzeň":13,"Univerzita Jana Amose Komenského Praha s.r.o.":12,"Metropolitan University Prague":12,"Institute of Physics of Materials AS CR, v. v. i.":8,"Ustav jaderne fyziky AV CR, v. v. i.":33,"Masaryk University":864,"University of Pardubice":190,"Ústav geoniky AV ČR, v. v. i.":14,"Národní knihovna České republiky":18,"Ustav organicke chemie a biochemie AV CR, v. v. i.":36,"Vysoká škola uměleckoprůmyslová v Praze":73,"Ústav zemědělské ekonomiky a informací":12,"Akademie múzických umění v Praze":87,"Nemocnice Jihlava, prispevkova organizace":38,"Astronomický ústav AV ČR, v. v. i.":35,"Vysoká škola evropských a regionálních studií, o.p.s.":6,"VSB-Technical University of Ostrava":645,"Veterinární a farmaceutická univerzita Brno":60,"Plzeňský kraj":2,"Výzkumný ústav vodohospodářský T. G. Masaryka, v. v. i.":2,"Research Library in Olomouc":6,"Ministerstvo školství, mládeže a tělovýchovy":157,"Institute of Mathematics CAS":9,"Vysoká škola polytechnická Jihlava":31,"Ústav přístrojové techniky AV ČR, v. v. i.":6,"Vysoká škola technická a ekonomická v Českých Budějovicích":22,"Grantová agentura České republiky":3,"Vyšší odborná škola informačních služeb, Praha 4, Pacovská 350":2,"Institute of Experimental Botany AS CR, v. v. i.":15,"Hasičský záchranný sbor Olomouckého kraje":4,"Všeobecná fakultní nemocnice v Praze":20,"University of South Bohemia in Ceske Budejovice":209,"Národní technická knihovna":12,"Středisko služeb školám, Plzeň, Částkova 78":2,"University of Economics, Prague":963,"Fakultní nemocnice Plzeň":14,"Fyziologický ústav AV ČR, v. v. i.":10,"Fakultní nemocnice Hradec Králové":45,"Food Research Institute Prague":2,"Moravska zemska knihovna v Brne":29,"Czech Technical University in Prague":957,"Narodni lekarska knihovna":2,"Výzkumný ústav geodetický, topografický a kartografický, v. v. i.":10,"Západočeská univerzita v Plzni":359,"VOŠ a SPŠE Plzeň":68,"Střední škola informatiky a právních studií, o.p.s.":3,"Ústav anorganické chemie AV ČR, v. v. i.":4,"Univerzita Tomáše Bati ve Zlíně":87,"Vysoké učení technické v Brně":216,"Institute of Geology of the CAS, v. v. i.":3,"Kerio Technologies s.r.o.":44,"Technical University of Liberec":386,"Institute of Molecular Genetics of the ASCR, v. v. i.":26,"University of Chemistry and Technology, Prague":163,"Biologické centrum AV ČR, v. v. i.":6,"Univerzita Hradec Králové":43,"Institute of Chemical Process Fundamentals of the CAS, v. v. i.":9,"Gymnázium Matyáše Lercha, Brno, Žižkova 55, příspěvková organizace":22,"University of Ostrava":69,"BBMRI-ERIC":31,"Jihoceska vedecka knihovna v Ceskych Budejovicich":6,"Institute of Information Theory and Automation of the ASCR":12,"Masarykův onkologický ústav":10,"Mendelova univerzita v Brně":69,"Centrum výzkumu globální změny AV ČR, v. v. i.":18,"Gymnázium, Plzeň, Mikulášské nám. 23":10,"BRAILCOM, o.p.s.":3,"Fakultní nemocnice Brno":4,"Vysoká škola hotelová v Praze 8, spol. s r.o.":4,"NÁRODNÍ MUZEUM":7,"Studijní a vědecká knihovna v Hradci Králové":12,"Silesian University in Opava":68,"Národní ústav duševního zdraví":4}';
       
        </script>
        
        
    </head>
    <body>
        
        <div id="css-table">
<!--------------------------------------------------------------------------------------------------->
            <div class="collumn">
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
                        <input type="radio" name="Master" value="MasterEjbcaAbc" onchange="sortMasterByName('Ejbca')" checked> by alphabeth<br>
                        <input type="radio" name="Master" value="MasterEjbcaNum" onchange="sortMasterByValue('Ejbca')"> by number of CAs<br>
                    </form>
                </div>
                <div class="labelSelectBox">
                    <label>sort:</label><br>
                    <form id="PairedEjbca">
                        <input type="radio" name="Paired" value="PairedEjbcaAbc" onchange="sortPairedByName('Ejbca')" checked> by alphabet<br>
                        <input type="radio" name="Paired" value="PairedEjbcaNum" onchange="sortPairedByValue('Ejbca')" > by number of CAs<br> 
                    </form>
                </div>
                <br><br><br><br><br>

                <div class="sliderDiv">

                    <p>Your slider has a value of <span id="sliderValueEjbca"></span></p>
                    <button id="btnSliderEjbca" type="button">Set minimum number of valid CAss</button>

                    <div id="sliderEjbca"></div>

                </div>
                <br>

                <div id="chartVerticalEjbca"></div> 

                <div><br></div> 
                <div id="chartHorizontalEjbca"></div> 
                <div><br></div> 
                <div id="tableEjbca"></div>
            </div>
<!--------------------------------------------------------------------------------------------------->
            <div class="collumn">
                <div class="center">
                    <h1>LDAP</h1>
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
                        <input type="radio" name="Master" value="MasterLdapAbc" onchange="sortMasterByName('Ldap')" checked> by alphabeth<br>
                        <input type="radio" name="Master" value="MasterLdapNum" onchange="sortMasterByValue('Ldap')"> by number of CAs<br>
                    </form>
                </div>
                <div class="labelSelectBox">
                    <label>sort:</label><br>
                    <form id="PairedLdap">
                        <input type="radio" name="Paired" value="PairedLdapAbc" onchange="sortPairedByName('Ldap')" checked> by alphabet<br>
                        <input type="radio" name="Paired" value="PairedLdapNum" onchange="sortPairedByValue('Ldap')" > by number of CAs<br> 
                    </form>
                </div>
                <br><br><br><br><br>

                <div class="sliderDiv">

                    <p>Your slider has a value of <span id="sliderValueLdap"></span></p>
                    <button id="btnSliderLdap" type="button">Set minimum number of valid CAss</button>
                    
                    <div id="sliderLdap"></div>

                </div>
                <br>

                <div id="chartVerticalLdap"></div> 

                <div><br></div> 
                <div id="chartHorizontalLdap"></div> 
                <div><br></div> 
                <div id="tableLdap"></div>
            </div>
<!--------------------------------------------------------------------------------------------------->
            <div class="collumn">
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
                        <input type="radio" name="Master" value="MasterDigicertAbc" onchange="sortMasterByName('Digicert')" checked> by alphabeth<br>
                        <input type="radio" name="Master" value="MasterDigicertNum" onchange="sortMasterByValue('Digicert')"> by number of CAs<br>
                    </form>
                </div>
                <div class="labelSelectBox">
                    <label>sort:</label><br>
                    <form id="PairedDigicert">
                        <input type="radio" name="Paired" value="PairedDigicertAbc" onchange="sortPairedByName('Digicert')" checked> by alphabet<br>
                        <input type="radio" name="Paired" value="PairedDigicertNum" onchange="sortPairedByValue('Digicert')" > by number of CAs<br> 
                    </form>
                </div>
                <br><br><br><br><br>

                <div class="sliderDiv">

                    <p>Your slider has a value of <span id="sliderValueDigicert"></span></p>
                    <button id="btnSliderDigicert" type="button">Set minimum number of valid CAss</button>

                    <div id="sliderDigicert"></div>

                </div>
                <br>

                <div id="chartVerticalDigicert"></div> 

                <div><br></div> 
                <div id="chartHorizontalDigicert"></div> 
                <div><br></div> 
                <div id="tableDigicert"></div>
            </div>
<!--------------------------------------------------------------------------------------------------->
        </div>
    </body>
</html>