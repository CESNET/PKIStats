/*
    Created on : 18.3.2016, 15:47:26
    Author     : jana
*/

/* global google */

// init values
var jsonEjbca;
var jsonLdap;
var jsonDigicert;

var dateEjbca;
var dateLdap;
var dateDigicert;

var exclusiveEjbca = [];
var exclusiveLdap = [];
var exclusiveDigicert = [];

var redrawEjbca = true;
var redrawLdap = true;
var redrawDigicert = true;

var countEjbca;
var countLdap;
var countDigicert;

var tresholdEjbca = 1;
var tresholdLdap = 1;
var tresholdDigicert = 1;

var json = {
    'Ejbca': jsonEjbca,
    'Ldap': jsonLdap,
    'Digicert': jsonDigicert
};
var date = {
    'Ejbca': dateEjbca,
    'Ldap': dateLdap,
    'Digicert': dateDigicert
};
var exclusive = {
    'Ejbca': exclusiveEjbca,
    'Ldap': exclusiveLdap,
    'Digicert': exclusiveDigicert
};
var redraw = {
    'Ejbca': redrawEjbca,
    'Ldap': redrawLdap,
    'Digicert': redrawDigicert
};
var count = {
    'Ejbca': countEjbca,
    'Ldap': countLdap,
    'Digicert': countDigicert
};
var treshold = {
    'Ejbca': tresholdEjbca,
    'Ldap': tresholdLdap,
    'Digicert': tresholdDigicert
};

// Load the Visualization API and the corechart package.
google.charts.load('current', {'packages':['corechart', 'table', 'bar']});

function sortResults(json, propertyName) {
    json = json.sort(function(a, b) {       
        return (b[json, propertyName]-a[json, propertyName]);//(a[json, propertyName] > b[json, propertyName]) ? 1 : ((a[json, propertyName] < b[json, propertyName]) ? -1 : 0);
    });
}

function drawChart(parameter) {
        
    // init values
    var max = 0;
    count[parameter] = 0;

    // Create the data table.
    var data = new google.visualization.DataTable();
    data.addColumn('string', 'Organizations');
    data.addColumn('number', 'Count');  

    var parsedValidCAs = JSON.parse(json[parameter]);

    // set to default
    if (redraw[parameter]===true) {
        $("#PairedSelectBox"+parameter).empty();
        $("#MasterSelectBox"+parameter).empty();
        $selectBox = $('#MasterSelectBox'+parameter);
        exclusive[parameter] = [];
        treshold[parameter] = 1;
    }

    // sort by key or value
    var radioChecked = $('input[name="Master'+parameter+'"]:checked').val();
    if (radioChecked === 'Master'+parameter+'Abc') {        
        sortResults(parsedValidCAs.organizations, "name");        
    } else if (radioChecked === 'Master'+parameter+'Num') {        
        sortResults(parsedValidCAs.organizations, "count");        
    }

    for (var i=0; i<parsedValidCAs.organizations.length; i++) {

        var org = parsedValidCAs.organizations[i];

        if (org.count >= treshold[parameter]) {

            // do not add excluded organisations
            if (exclusive[parameter].indexOf(org.name) !== -1) {
                continue;
            }

            // find the biggest number of CA
            if (org.count > max) {
                max = parseInt(org.count);
            }

            // add new options to select box only once
            if (redraw[parameter]===true) {
                $selectBox.append($('<option />', {
                    value: parseInt(org.count),
                    text: org.name + " (" + org.count + ")"
                }));
            }

            data.addRow([org.name, parseInt(org.count)]);

            count[parameter]++;
        }
    }

    // Set chart options
    var optionsVert = {
        'title':'Number of valid CAs at ' + date[parameter],
        chartArea:{left:200,right:100,top:50, bottom:200,width:"80%",height:"80%"},
        width: '100%',
        height: 600,
        bar: { groupWidth: '75%' },
        fontSize: 12
    };
    var optionsHoriz = {
        'title':'Number of valid CA at ' + date[parameter],
        chartArea:{right:0,bottom:15,top:60,width:"80%",height:"80%"},
        width: '100%',
        height: 15*count[parameter] + 100,
        bar: { groupWidth: '75%' },
        fontSize: 12,
        backgroundColor: '#E4E4E4'
        
    };

    var verticalChart = verticalChart = new google.visualization.ColumnChart(document.getElementById('chartVertical'+parameter));
    verticalChart.draw(data, optionsVert);

    var horizontalChart = new google.visualization.BarChart(document.getElementById('chartHorizontal'+parameter));
    horizontalChart.draw(data, optionsHoriz);

    var table = new google.visualization.Table(document.getElementById('table'+parameter));
    // add to table sorting option
    google.visualization.events.addListener(table, 'sort', function(e){
        if(!sorting.hasOwnProperty('Count')){
            sorting=e;
        }
        if(sorting.column==e.column){
            sorting.desc=sorting.ascending;
            sorting.ascending=!sorting.ascending;
        } else {
            sorting.desc=true;
            sorting.ascending=false;
            sorting.column=e.column;
        }
        data.sort([sorting]);
        table.draw(data, {showRowNumber: true});
    });
    table.draw(data, {showRowNumber: true, sortAscending: false});

    // init slider with updated values
    $("#slider"+parameter).slider({
        value: treshold[parameter],
        min: 1,
        max: max,
        step: 1,
        slide: function( event, ui ) {
            $("#sliderValue"+parameter).html(ui.value);
        }
    });

    $("#sliderValue" + parameter).html($('#slider' + parameter).slider('value') );

    // redraw is not need
    redraw[parameter] = false;
}

// reads file
function readFile(parameter, callback) {

    var files = document.getElementById('files'+parameter).files;
    if (!files.length) {
        alert('Please select a file!');
        return;
    }

    var file = files[0];

    var reader = new FileReader();

    // If we use onloadend, we need to check the readyState.
    reader.onloadend = function(evt) {
        if (evt.target.readyState === FileReader.DONE) { // DONE == 2
            
            json[parameter] = evt.target.result;
            callback();
        }
    };
    reader.readAsText(file);
}

function sortMasterByName(parameter) {
    $('#MasterSelectBox'+parameter).html($("#MasterSelectBox"+parameter+" option").sort(function (a,b) {
        return a.text === b.text ? 0 : a.text < b.text ? -1 : 1;
    }));
    drawChart(parameter);
}
function sortMasterByValue(parameter) {
    $('#MasterSelectBox'+parameter).html($("#MasterSelectBox"+parameter+" option").sort(function (a,b) {
        return a.value === b.value ? (a.text === b.text ? 0 : a.text < b.text ? -1 : 1) : b.value - a.value ;
    }));
    drawChart(parameter);
}
function sortPairedByName(parameter) {    
    $('#PairedSelectBox'+parameter).html($("#PairedSelectBox"+parameter+" option").sort(function (a,b) {
        return a.text === b.text ? 0 : a.text < b.text ? -1 : 1;
    }));
}
function sortPairedByValue(parameter) {
    $('#PairedSelectBox'+parameter).html($("#PairedSelectBox"+parameter+" option").sort(function (a,b) {
        return a.value === b.value ? (a.text === b.text ? 0 : a.text < b.text ? -1 : 1) : b.value - a.value;
    }));
}

function sortSelectBox(sortType,parameter) {
    if (sortType === 'Paired'+parameter+'Num') {
        sortPairedByValue(parameter);
    } else if (sortType === 'Paired'+parameter+'Abc') {
        sortPairedByName(parameter);
    } else if (sortType === 'Master'+parameter+'Num') {
        sortMasterByValue(parameter);
    } else if (sortType === 'Master'+parameter+'Abc') {
        sortMasterByName(parameter);
    }
}

google.charts.setOnLoadCallback(function(){ drawChart('Ejbca'); });
google.charts.setOnLoadCallback(function(){ drawChart('Ldap'); });
google.charts.setOnLoadCallback(function(){ drawChart('Digicert'); });

$(document).ready(function() {

    // slider Ejbca
    $('#btnSliderEjbca').click(function() {
        treshold['Ejbca'] = $('#sliderEjbca').slider('value');
        drawChart('Ejbca');
    });
    // slider Ldap
    $('#btnSliderLdap').click(function() {
        treshold['Ldap'] = $('#sliderLdap').slider('value');
        drawChart('Ldap');
    });
    // slider Digicert
    $('#btnSliderDigicert').click(function() {
        treshold['Digicert'] = $('#sliderDigicert').slider('value');
        drawChart('Digicert');
    });


    // select boxes add Ejbca
    $('#btnAddEjbca').click(function() { 
        // move option from master to paired select box
        $('#MasterSelectBoxEjbca > option:selected').each(function() {
            var string = $(this).text();
            exclusive['Ejbca'].push(string.substring(0, string.lastIndexOf('(')-1));
        });
        $('#MasterSelectBoxEjbca > option:selected').appendTo('#PairedSelectBoxEjbca');
        // cruel sorting functions
        var sortType = $('input[name=Paired]:checked', '#PairedEjbca').val();
        sortSelectBox(sortType,'Ejbca');
        // redraw chart
        drawChart('Ejbca');
    });
    // select boxes add Ldap
    $('#btnAdd'+'Ldap').click(function() { 
        // move option from master to paired select box
        $('#MasterSelectBoxLdap > option:selected').each(function() {
            var string = $(this).text();
            exclusive['Ldap'].push(string.substring(0, string.lastIndexOf('(')-1));
        });
        $('#MasterSelectBoxLdap > option:selected').appendTo('#PairedSelectBoxLdap');
        // cruel sorting functions
        var sortType = $('input[name=Paired]:checked', '#PairedLdap').val();
        sortSelectBox(sortType,'Ldap');
        // redraw chart
        drawChart('Ldap');
    });
    // select boxes add Digicert
    $('#btnAddDigicert').click(function() { 
        // move option from master to paired select box
        $('#MasterSelectBoxDigicert > option:selected').each(function() {
            var string = $(this).text();
            exclusive['Digicert'].push(string.substring(0, string.lastIndexOf('(')-1));
        });
        $('#MasterSelectBoxDigicert > option:selected').appendTo('#PairedSelectBoxDigicert');
        // cruel sorting functions
        var sortType = $('input[name=Paired]:checked', '#PairedDigicert').val();
        sortSelectBox(sortType,'Digicert');
        // redraw chart
        drawChart('Digicert');
    });


    // select boxes remove Ejbca
    $('#btnRemoveEjbca').click(function() { 
        $('#PairedSelectBoxEjbca > option:selected').each(function() {
            var string = $(this).text();
            var index = exclusive['Ejbca'].indexOf(string.substring(0, string.lastIndexOf('(')-1));
            if (index > -1) {
                exclusive['Ejbca'].splice(index, 1);
            }
        });
        $('#PairedSelectBoxEjbca > option:selected').appendTo('#MasterSelectBoxEjbca');
        // cruel sorting functions2
        var sortType = $('input[name=Master]:checked', '#MasterEjbca').val();
        sortSelectBox(sortType,'Ejbca');
        // redraw chart
        drawChart('Ejbca');
    });
    // select boxes remove Ldap
    $('#btnRemoveLdap').click(function() { 
        $('#PairedSelectBoxLdap > option:selected').each(function() {
            var string = $(this).text();
            var index = exclusive['Ldap'].indexOf(string.substring(0, string.lastIndexOf('(')-1));
            if (index > -1) {
                exclusive['Ldap'].splice(index, 1);
            }
        });
        $('#PairedSelectBoxLdap > option:selected').appendTo('#MasterSelectBoxLdap');
        // cruel sorting functions2
        var sortType = $('input[name=Master]:checked', '#MasterLdap').val();
        sortSelectBox(sortType,'Ldap');
        // redraw chart
        drawChart('Ldap');
    });
    // select boxes remove Digicert
    $('#btnRemoveDigicert').click(function() { 
        $('#PairedSelectBoxDigicert > option:selected').each(function() {
            var string = $(this).text();
            var index = exclusive['Digicert'].indexOf(string.substring(0, string.lastIndexOf('(')-1));
            if (index > -1) {
                exclusive['Digicert'].splice(index, 1);
            }
        });
        $('#PairedSelectBoxDigicert > option:selected').appendTo('#MasterSelectBoxDigicert');
        // cruel sorting functions2
        var sortType = $('input[name=Master]:checked', '#MasterDigicert').val();
        sortSelectBox(sortType,'Digicert');
        // redraw chart
        drawChart('Digicert');
    });


    // read file Ejbca
    $('#btnReadFileEjbca').click(function() {
        readFile('Ejbca', function() {
            var str = document.getElementById('filesEjbca').value;
            // remove last '.json'
            date['Ejbca'] = str.slice(0, -5);
            redraw['Ejbca'] = true;
            drawChart('Ejbca');
        });
    });
    // read file Ldap
    $('#btnReadFileLdap').click(function() {
        readFile('Ldap', function() {
            var str = document.getElementById('filesLdap').value;
            // remove last '.json'
            date['Ldap'] = str.slice(0, -5);
            redraw['Ldap'] = true;
            drawChart('Ldap');
        });
    });
    // read file Digicert
    $('#btnReadFileDigicert').click(function() {
        readFile('Digicert', function() {
            var str = document.getElementById('filesDigicert').value;
            // remove last '.json'
            date['Digicert'] = str.slice(0, -5); 
            redraw['Digicert'] = true;
            drawChart('Digicert');
        });
    });
});

//functionExport(json_data, "User_Report", true);
function exportCSV(parameter, title) {
    
    var csvContent = "name,count\n";
    
    var length = document.getElementById("MasterSelectBox" + parameter).options.length;
    
    for (var i=0; i<length; i++) {
        var text = document.getElementById("MasterSelectBox" + parameter).options[i].text;
        
        var name = text.substring(0, text.lastIndexOf('(')-1);
        var count = text.substring(text.lastIndexOf('(')+1, text.lastIndexOf(')'));
        
        csvContent += "\""+name + "\"," + count + "\n";
    }
    
    var CSV = csvContent;
    
    //Generate a file name
    var fileName = title.replace(/ /g, "_");
    var uri = 'data:text/csv;charset=UTF-8,%EF%BB%BF' + encodeURI(CSV);
    var link = document.createElement("a");
    link.href = uri;
    link.style = "visibility:hidden";
    link.download = fileName + ".csv";
    //this part will append the anchor tag and remove it after automatic click
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
}