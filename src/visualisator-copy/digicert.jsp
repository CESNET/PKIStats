<%-- 
    Document   : digicert
    Created on : 21.4.2016, 10:25:43
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
            date['Digicert'] = initialDate;
            json['Digicert'] = '{"organizations":[{"name":"Akademie múzických umění v Praze","count":"37"},{"name":"Astronomický ústav AV ČR, v. v. i.","count":"14"},{"name":"BBMRI-ERIC","count":"11"},{"name":"BRAILCOM, o.p.s.","count":"1"},{"name":"Biologické centrum AV ČR, v. v. i.","count":"4"},{"name":"CESNET, zájmové sdružení právnických osob","count":"510"},{"name":"Centrum výzkumu globální změny AV ČR, v. v. i.","count":"6"},{"name":"Fakultní nemocnice Brno","count":"3"},{"name":"Fakultní nemocnice Hradec Králové","count":"17"},{"name":"Fakultní nemocnice Ostrava","count":"6"},{"name":"Fakultní nemocnice Plzeň","count":"7"},{"name":"Food Research Institute Prague","count":"1"},{"name":"Fyzikální ústav AV ČR, v. v. i.","count":"45"},{"name":"Fyziologický ústav AV ČR, v. v. i.","count":"5"},{"name":"Grantová agentura České republiky","count":"1"},{"name":"Gymnázium Matyáše Lercha, Brno, Žižkova 55, příspěvková organizace","count":"9"},{"name":"Gymnázium, Plzeň, Mikulášské nám. 23","count":"2"},{"name":"Hasičský záchranný sbor Olomouckého kraje","count":"2"},{"name":"Institute of Chemical Process Fundamentals of the CAS, v. v. i.","count":"3"},{"name":"Institute of Experimental Botany AS CR, v. v. i.","count":"5"},{"name":"Institute of Geology of the CAS, v. v. i.","count":"1"},{"name":"Institute of Mathematics CAS","count":"3"},{"name":"Institute of Molecular Genetics of the ASCR, v. v. i.","count":"14"},{"name":"Jihoceska vedecka knihovna v Ceskych Budejovicich","count":"3"},{"name":"Jihočeská univerzita v Českých Budějovicích","count":"72"},{"name":"Kerio Technologies s.r.o.","count":"22"},{"name":"Masarykova univerzita","count":"327"},{"name":"Masarykův onkologický ústav","count":"2"},{"name":"Mendelova univerzita v Brně","count":"25"},{"name":"Metropolitan University Prague","count":"4"},{"name":"Ministerstvo školství, mládeže a tělovýchovy","count":"62"},{"name":"Moravská zemská knihovna v Brně","count":"11"},{"name":"Nemocnice Jihlava, příspěvková organizace","count":"19"},{"name":"NÁRODNÍ MUZEUM","count":"3"},{"name":"Národní knihovna České republiky","count":"8"},{"name":"Národní technická knihovna","count":"5"},{"name":"Národní ústav duševního zdraví","count":"2"},{"name":"Ostravská univerzita v Ostravě","count":"28"},{"name":"Plzeňský kraj","count":"1"},{"name":"SPŠ strojnická a SOŠ prof. Švejcara, Plzeň","count":"5"},{"name":"Slezská univerzita v Opavě","count":"25"},{"name":"Studijní a vědecká knihovna v Hradci Králové","count":"4"},{"name":"Středisko služeb školám, Plzeň, Částkova 78","count":"1"},{"name":"Středisko společných činností AV ČR, v. v. i.","count":"120"},{"name":"Střední škola informatiky a právních studií, o.p.s.","count":"1"},{"name":"Technická univerzita v Liberci","count":"149"},{"name":"Univerzita Hradec Králové","count":"16"},{"name":"Univerzita Jana Amose Komenského Praha s.r.o.","count":"4"},{"name":"Univerzita Karlova v Praze","count":"391"},{"name":"Univerzita Palackého v Olomouci","count":"97"},{"name":"Univerzita Pardubice","count":"74"},{"name":"Univerzita Tomáše Bati ve Zlíně","count":"38"},{"name":"Ustav jaderne fyziky AV CR, v. v. i.","count":"11"},{"name":"VOŠ a SPŠE Plzeň","count":"25"},{"name":"Veterinární a farmaceutická univerzita Brno","count":"23"},{"name":"Vysoká škola báňská - Technická univerzita Ostrava","count":"231"},{"name":"Vysoká škola chemicko-technologická v Praze","count":"55"},{"name":"Vysoká škola ekonomická v Praze","count":"319"},{"name":"Vysoká škola evropských a regionálních studií, o.p.s.","count":"2"},{"name":"Vysoká škola polytechnická Jihlava","count":"11"},{"name":"Vysoká škola technická a ekonomická v Českých Budějovicích","count":"11"},{"name":"Vysoká škola uměleckoprůmyslová v Praze","count":"25"},{"name":"Vysoké učení technické v Brně","count":"74"},{"name":"Vyšší odborná škola informačních služeb, Praha 4, Pacovská 350","count":"1"},{"name":"Výzkumný ústav geodetický, topografický a kartografický, v. v. i.","count":"5"},{"name":"Výzkumný ústav vodohospodářský T. G. Masaryka, v. v. i.","count":"1"},{"name":"Vědecká knihovna v Olomouci","count":"2"},{"name":"Všeobecná fakultní nemocnice v Praze","count":"7"},{"name":"Západočeská univerzita v Plzni","count":"138"},{"name":"Ústav anorganické chemie AV ČR, v. v. i.","count":"2"},{"name":"Ústav fotoniky a elektroniky AV ČR, v. v. i.","count":"15"},{"name":"Ústav fyziky materiálů AV ČR, v. v. i.","count":"3"},{"name":"Ústav geoniky AV ČR, v. v. i.","count":"5"},{"name":"Ústav organické chemie a biochemie AV ČR, v. v. i.","count":"15"},{"name":"Ústav přístrojové techniky AV ČR, v. v. i.","count":"2"},{"name":"Ústav teorie informace a automatizace AV ČR, v. v. i.","count":"5"},{"name":"Ústav zemědělské ekonomiky a informací","count":"4"},{"name":"Česká zemědělská univerzita v Praze","count":"34"},{"name":"České vysoké učení technické v Praze","count":"354"}]}';
        
            google.charts.setOnLoadCallback(function(){ drawChart('Digicert'); });
        </script>
        
    </head>
    <body style="background-color: #ccc">
        
        <h1 class="mainTitle">DIGICERT statistics</h1>
        <div id="css-table">
            
<!--------------------------------------------------------------------------------------------------->
            <div class="collumn fullScreen">
                <div class="title">
                    <h2 style="margin-top: 0;">DIGICERT</h2>
                    <input type="file" id="filesDigicert"/> 
                    <span id="btnReadFileDigicert">
                        <button type="button">update page</button>
                    </span>
                </div>
                <div class="selectPart">
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
        </div>
    </body>
</html>