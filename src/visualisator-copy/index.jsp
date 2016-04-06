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
        <script src="script.js"></script>
        <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css"> 
        <link rel="stylesheet" href="styles.css">
        <%@page contentType="text/html" pageEncoding="UTF-8"%>
        <jsp:useBean id="connector" class="com.cesnet.pki.ejbca.Connector" />        
        <% String json_ldap = connector.getJSON("ldap"); %>
        <% String date = connector.getDate(); %>
        
        <script>            
            var date = '<%=date%>';
            var jsonLdap = '<%=json_ldap%>';
            var jsonEjbca = '{"Academy of Arts Architecture and Design Prague":1,"Academy of Performing Arts in Prague":1,"Academy of Sciences Library":1,"Anglo-Czech High School":1,"Biology Centre of the ASCR, v. v. i.":1,"Brailcom":1,"CESNET":152,"CESNET, z.s.p.o.":1,"CTU in Prague":1020,"CZ.NIC":3,"Center for School Services Pilsen":2,"Centre for Higher Education Studies":1,"Centre for Innovation and Projects, VSTE":2,"Centre of Administration and Operations, ASCR":15,"Charles University in Prague":2,"College of Media and Journalism":2,"College of Polytechnics Jihlava":3,"Czech - Slavonic Business Academy of Doctor Edvard Benes":1,"Czech Science Foundation":1,"Czech University of Life Sciences Prague":4,"Department of Agricultural Economics and Information":3,"FZU":1,"Fire Rescue Service of Olomouc Region":1,"General Faculty Hospital in Prague":1,"Global Change Research Center, ASCR":1,"Gymnazium Cheb":1,"High School of Chemistry in Pardubice":1,"High School of Civil Engineering Liberec":2,"High School of Informatics and Financial Services":2,"Higher Professional School of Information Services":1,"Hospital Jihlava":3,"Hotel school Podebrady":1,"Institute of Archeology of the Academy of Sciences of the CR":1,"Institute of Biophysics, Academy of Sciences of the CR":1,"Institute of Botany of the Academy of Science of the CR":1,"Institute of Chemical Process Fundamentals, ASCR":2,"Institute of Chemical Technology, Prague":2,"Institute of Computer Science, ASCR, v.v.i.":5,"Institute of Czech Literature AS CR":1,"Institute of Geonics of the Academy of Sciences of the CR":1,"Institute of Information Theory and Automation, ASCR":1,"Institute of Macromolecular Chemistry, ASCR":1,"Institute of Mathematics, ASCR":1,"Institute of Microbiology of the Academy of Sciences of the Czech Republic, v.v.i.":2,"Institute of Molecular Genetics, ASCR":2,"Institute of Organic Chemistry and Biochemistry, ASCR":5,"Institute of Philosophy of the Academy of Sciences of the Czech Republic, v.v.i.":1,"Institute of Physical Chemistry, ASCR":6,"Institute of Physics of Materials of the Academy of Sciences of the CR":1,"Institute of Physics of Materials, ASCR":1,"Institute of Physics of the Academy of Sciences of the CR":16,"Institute of Plasma Physics, Academy of Sciences of the CR":2,"Institute of Rock Structure and Mechanics of the ASCR, v.v.i.":1,"Institute of Scientific Instruments, ASCR":1,"Institute of Theoretical and Applied Mechanics, v.v.i.":1,"Institute of Thermomechanics, Academy of Sciences of the CR":4,"JCU":2,"Jan Amos Komensky University Prague":1,"Janacek Academy of Music and Performing Arts in Brno":1,"Kerio Technologies s.r.o.":1,"Klet Observatory":4,"MUNI":4,"Masaryk Grammar School":2,"Masaryk Memorial Cancer Institute":2,"Masaryk University":7,"Mathias Lerch Gymnasium":2,"Mendel University in Brno":2,"Metropolitan University Prague":1,"Ministry of Education, Youth and Sports":2,"Moravian Library":4,"Moravian University College Olomouc":3,"Moravian-Silesian Research Library in Ostrava":1,"Municipal Library Ceska Trebova":1,"Municipal Library of Prague":1,"National Institute of Mental Health":3,"National Library of the Czech Republic":2,"National Medical Library":1,"National Museum":2,"National Technical Library":4,"Nuclear Physics Institute of the Academy of Sciences of the CR":2,"OSVC":1,"Pilsen Region":4,"Private Secondary School of Information Technologies":1,"Research Library in Olomouc":2,"Secondary School of Applied Cybernetics":1,"Secondary School of Electrotechnics and Informatics, Ostrava":2,"Secondary Technical School of Electrical Engineering and Technology College in Pisek":1,"Secondary Technical School of Mechanical Engineering, Pilsen":3,"Secondary school and College of Transport, Pilsen":1,"Secondary technical school, UL":1,"Silesian University":1,"Softweco Group":1,"State institute for drug control":2,"Technical University of Liberec":1,"Technology Agency of the Czech Republic":4,"Technology Centre ASCR":1,"Tertiary College and Secondary School of Electrical Engineering, Pilsen":2,"The Education and Research Library of the Pilsener Region":1,"The Institute of Hospitality Management":2,"The National Pedagogical Museum and Library of J. A. Comenius":1,"The Regional Research Library in Liberec":2,"The Research Library in Ceske Budejovice":1,"The Research Library in Hradec Kralove":2,"The University Hospital Brno":5,"Tomas Bata University in Zlin":2,"University Hospital Ostrava":1,"University hospital Hradec Kralove":2,"University of Defence in Brno":4,"University of Economics, Prague":4,"University of Hradec Kralove":4,"University of J. E. Purkyne":1,"University of Ostrava":1,"University of Pardubice":3,"University of South Bohemia Ceske Budejovice":1,"University of Veterinary and Pharmaceutical Sciences Brno":6,"University of West Bohemia":2,"Vysocina Region":5,"ZCU":1,"Západočeská univerzita v Plzni":636}';
        </script>
        
        
    </head>
    <body>
        
        <div id="css-table">
            
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
                        <input type="radio" name="Master" value="MasterEjbcaAbc" onchange="sortMasterEjbcaByName()" checked> by alphabeth<br>
                        <input type="radio" name="Master" value="MasterEjbcaNum" onchange="sortMasterEjbcaByValue()"> by number of CAs<br>
                    </form>
                </div>
                <div class="labelSelectBox">
                    <label>sort:</label><br>
                    <form id="PairedEjbca">
                        <input type="radio" name="Paired" value="PairedEjbcaAbc" onchange="sortPairedEjbcaByName()" checked> by alphabet<br>
                        <input type="radio" name="Paired" value="PairedEjbcaNum" onchange="sortPairedEjbcaByValue()" > by number of CAs<br> 
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
                        <input type="radio" name="Master" value="MasterLdapAbc" onchange="sortMasterLdapByName()" checked> by alphabeth<br>
                        <input type="radio" name="Master" value="MasterLdapNum" onchange="sortMasterLdapByValue()"> by number of CAs<br>
                    </form>
                </div>
                <div class="labelSelectBox">
                    <label>sort:</label><br>
                    <form id="PairedLdap">
                        <input type="radio" name="Paired" value="PairedLdapAbc" onchange="sortPairedLdapByName()" checked> by alphabet<br>
                        <input type="radio" name="Paired" value="PairedLdapNum" onchange="sortPairedLdapByValue()" > by number of CAs<br> 
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
        </div>
    </body>
</html>