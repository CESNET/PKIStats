<%-- 
    Document   : ejbca
    Created on : 21.4.2016, 10:25:51
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
            date['Ejbca'] = initialDate;
            json['Ejbca'] = '{"organizations":[{"name":"Academy of Arts Architecture and Design Prague","count":"1"},{"name":"Academy of Performing Arts in Prague","count":"1"},{"name":"Academy of Sciences Library","count":"1"},{"name":"Anglo-Czech High School","count":"1"},{"name":"Biology Centre of the ASCR, v. v. i.","count":"1"},{"name":"Brailcom","count":"1"},{"name":"CESNET","count":"152"},{"name":"CESNET, z.s.p.o.","count":"1"},{"name":"CTU in Prague","count":"1020"},{"name":"CZ.NIC","count":"3"},{"name":"Center for School Services Pilsen","count":"2"},{"name":"Centre for Higher Education Studies","count":"1"},{"name":"Centre for Innovation and Projects, VSTE","count":"2"},{"name":"Centre of Administration and Operations, ASCR","count":"15"},{"name":"Charles University in Prague","count":"2"},{"name":"College of Media and Journalism","count":"2"},{"name":"College of Polytechnics Jihlava","count":"3"},{"name":"Czech - Slavonic Business Academy of Doctor Edvard Benes","count":"1"},{"name":"Czech Science Foundation","count":"1"},{"name":"Czech University of Life Sciences Prague","count":"4"},{"name":"Department of Agricultural Economics and Information","count":"3"},{"name":"FZU","count":"1"},{"name":"Fire Rescue Service of Olomouc Region","count":"1"},{"name":"General Faculty Hospital in Prague","count":"1"},{"name":"Global Change Research Center, ASCR","count":"1"},{"name":"Gymnazium Cheb","count":"1"},{"name":"High School of Chemistry in Pardubice","count":"1"},{"name":"High School of Civil Engineering Liberec","count":"2"},{"name":"High School of Informatics and Financial Services","count":"2"},{"name":"Higher Professional School of Information Services","count":"1"},{"name":"Hospital Jihlava","count":"3"},{"name":"Hotel school Podebrady","count":"1"},{"name":"Institute of Archeology of the Academy of Sciences of the CR","count":"1"},{"name":"Institute of Biophysics, Academy of Sciences of the CR","count":"1"},{"name":"Institute of Botany of the Academy of Science of the CR","count":"1"},{"name":"Institute of Chemical Process Fundamentals, ASCR","count":"2"},{"name":"Institute of Chemical Technology, Prague","count":"2"},{"name":"Institute of Computer Science, ASCR, v.v.i.","count":"5"},{"name":"Institute of Czech Literature AS CR","count":"1"},{"name":"Institute of Geonics of the Academy of Sciences of the CR","count":"1"},{"name":"Institute of Information Theory and Automation, ASCR","count":"1"},{"name":"Institute of Macromolecular Chemistry, ASCR","count":"1"},{"name":"Institute of Mathematics, ASCR","count":"1"},{"name":"Institute of Microbiology of the Academy of Sciences of the Czech Republic, v.v.i.","count":"2"},{"name":"Institute of Molecular Genetics, ASCR","count":"2"},{"name":"Institute of Organic Chemistry and Biochemistry, ASCR","count":"5"},{"name":"Institute of Philosophy of the Academy of Sciences of the Czech Republic, v.v.i.","count":"1"},{"name":"Institute of Physical Chemistry, ASCR","count":"6"},{"name":"Institute of Physics of Materials of the Academy of Sciences of the CR","count":"1"},{"name":"Institute of Physics of Materials, ASCR","count":"1"},{"name":"Institute of Physics of the Academy of Sciences of the CR","count":"16"},{"name":"Institute of Plasma Physics, Academy of Sciences of the CR","count":"2"},{"name":"Institute of Rock Structure and Mechanics of the ASCR, v.v.i.","count":"1"},{"name":"Institute of Scientific Instruments, ASCR","count":"1"},{"name":"Institute of Theoretical and Applied Mechanics, v.v.i.","count":"1"},{"name":"Institute of Thermomechanics, Academy of Sciences of the CR","count":"4"},{"name":"JCU","count":"2"},{"name":"Jan Amos Komensky University Prague","count":"1"},{"name":"Janacek Academy of Music and Performing Arts in Brno","count":"1"},{"name":"Kerio Technologies s.r.o.","count":"1"},{"name":"Klet Observatory","count":"4"},{"name":"MUNI","count":"4"},{"name":"Masaryk Grammar School","count":"2"},{"name":"Masaryk Memorial Cancer Institute","count":"2"},{"name":"Masaryk University","count":"7"},{"name":"Mathias Lerch Gymnasium","count":"2"},{"name":"Mendel University in Brno","count":"2"},{"name":"Metropolitan University Prague","count":"1"},{"name":"Ministry of Education, Youth and Sports","count":"2"},{"name":"Moravian Library","count":"4"},{"name":"Moravian University College Olomouc","count":"3"},{"name":"Moravian-Silesian Research Library in Ostrava","count":"1"},{"name":"Municipal Library Ceska Trebova","count":"1"},{"name":"Municipal Library of Prague","count":"1"},{"name":"National Institute of Mental Health","count":"3"},{"name":"National Library of the Czech Republic","count":"2"},{"name":"National Medical Library","count":"1"},{"name":"National Museum","count":"2"},{"name":"National Technical Library","count":"4"},{"name":"Nuclear Physics Institute of the Academy of Sciences of the CR","count":"2"},{"name":"OSVC","count":"1"},{"name":"Pilsen Region","count":"4"},{"name":"Private Secondary School of Information Technologies","count":"1"},{"name":"Research Library in Olomouc","count":"2"},{"name":"Secondary School of Applied Cybernetics","count":"1"},{"name":"Secondary School of Electrotechnics and Informatics, Ostrava","count":"2"},{"name":"Secondary Technical School of Electrical Engineering and Technology College in Pisek","count":"1"},{"name":"Secondary Technical School of Mechanical Engineering, Pilsen","count":"3"},{"name":"Secondary school and College of Transport, Pilsen","count":"1"},{"name":"Secondary technical school, UL","count":"1"},{"name":"Silesian University","count":"1"},{"name":"Softweco Group","count":"1"},{"name":"State institute for drug control","count":"2"},{"name":"Technical University of Liberec","count":"1"},{"name":"Technology Agency of the Czech Republic","count":"4"},{"name":"Technology Centre ASCR","count":"1"},{"name":"Tertiary College and Secondary School of Electrical Engineering, Pilsen","count":"2"},{"name":"The Education and Research Library of the Pilsener Region","count":"1"},{"name":"The Institute of Hospitality Management","count":"2"},{"name":"The National Pedagogical Museum and Library of J. A. Comenius","count":"1"},{"name":"The Regional Research Library in Liberec","count":"2"},{"name":"The Research Library in Ceske Budejovice","count":"1"},{"name":"The Research Library in Hradec Kralove","count":"2"},{"name":"The University Hospital Brno","count":"5"},{"name":"Tomas Bata University in Zlin","count":"2"},{"name":"University Hospital Ostrava","count":"1"},{"name":"University hospital Hradec Kralove","count":"2"},{"name":"University of Defence in Brno","count":"4"},{"name":"University of Economics, Prague","count":"4"},{"name":"University of Hradec Kralove","count":"4"},{"name":"University of J. E. Purkyne","count":"1"},{"name":"University of Ostrava","count":"1"},{"name":"University of Pardubice","count":"3"},{"name":"University of South Bohemia Ceske Budejovice","count":"1"},{"name":"University of Veterinary and Pharmaceutical Sciences Brno","count":"6"},{"name":"University of West Bohemia","count":"2"},{"name":"Vysocina Region","count":"5"},{"name":"ZCU","count":"1"},{"name":"Zapadoceska univerzita v Plzni","count":"636"}]}';
        
            google.charts.setOnLoadCallback(function(){ drawChart('Ejbca'); });
        </script>
        
    </head>
    <body style="background-color: #ccc">
        
        <h1 class="mainTitle">EJBCA statistics</h1>
        <div id="css-table">
            
<!--------------------------------------------------------------------------------------------------->
            <div class="collumn fullScreen">
                <div class="title">
                    <h2 style="margin-top: 0;">EJBCA</h2>
                    <input type="file" id="filesEjbca"/> 
                    <span id="btnReadFileEjbca">
                        <button type="button">update page</button>
                    </span>
                </div>
                <div class="selectPart">
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