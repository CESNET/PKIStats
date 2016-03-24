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
        <jsp:useBean id="sosator" class="com.cesnet.pki.Sosator" />        
          
    </head>
    <body>                 
        <div class="center">
            <input type="file" id="files"/> 
            <span id="btnReadText">
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
        <div id="select_div">                

            <select class="center" name="selectedDatas[]" id="MasterSelectBox" multiple="multiple" style=" height: 200px"></select>

            <div id="arrows">
                <button id="btnAdd" type="button">&gt;</button><br>
                <button id="btnRemove" type="button">&lt;</button>
            </div>                

            <select class="center" name="hiddenDatas[]" id="PairedSelectBox" multiple="multiple" style=" height: 200px"></select>                
        </div>

        <div class="labelSelectBox">
            <label>sort:</label><br>
            <form id="Master">
                <input type="radio" name="Master" value="MasterAbc" onchange="sortMasterByName()" checked> by alphabeth<br>
                <input type="radio" name="Master" value="MasterNum" onchange="sortMasterByValue()"> by number of CAs<br>
            </form>
        </div>
        <div class="labelSelectBox">
            <label>sort:</label><br>
            <form id="Paired">
                <input type="radio" name="Paired" value="PairedAbc" onchange="sortPairedByName()" checked> by alphabet<br>
                <input type="radio" name="Paired" value="PairedNum" onchange="sortPairedByValue()" > by number of CAs<br> 
            </form>
        </div>
        <br><br><br><br><br>

        <div id="slider_div">                         

            <p>Your slider has a value of <span id="slider-value"></span></p>
            <button id="btn_slider" type="button">Set minimum number of valid CAss</button>

            <div id="slider"></div>

        </div>
        <br>
        <form id="graph" class="center" style="background-color:white">
            <label>sort graph:</label><br>
            <input type="radio" name="Graph" value="GraphAbc" checked> by alphabeth<br>
            <input type="radio" name="Graph" value="GraphNum"> by number of CAs<br>
        </form>
        <div id="chart_vert_div"></div> 

        <div><br></div> 
        <div id="chart_horiz_div"></div> 
        <div><br></div> 
        <div id="table_div"></div> 
    </body>
</html>
