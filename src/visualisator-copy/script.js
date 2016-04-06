/* 
    Created on : 18.3.2016, 15:47:26
    Author     : jana
*/

// init values
var jsonLdap;
var jsonEjbca;
var date;

var exclusiveEjbca = [];
var exclusiveLdap = [];
var treshold = 1;
var count;
var redrawEjbca = true; // if redraw is needed
var redrawLdap = true;

// Load the Visualization API and the corechart package.
google.charts.load('current', {'packages':['corechart', 'table', 'bar']});

// Callback that creates and populates a data table, instantiates the chart, 
// passes in the data and draws it.    
function drawChartEjbca() {

    // init values
    var max = 0;
    var parsedValidCAs = JSON.parse(jsonEjbca);
    count = 0;

    // Create the data table.
    var data = new google.visualization.DataTable();
    data.addColumn('string', 'Organizations');
    data.addColumn('number', 'Count');  

    // set to default
    if (redrawEjbca===true) {
        $("#PairedSelectBoxEjbca").empty();
        $("#MasterSelectBoxEjbca").empty();
        var $select = $('#MasterSelectBoxEjbca');
        exclusiveEjbca = [];
        treshold = 1;
    }
    
    for (var entry in parsedValidCAs) {

        if (parsedValidCAs[entry] >= treshold) {

            // do not add excluded organisations
            if (exclusiveEjbca.indexOf(entry) !== -1) {
                continue;
            } 

            // find the biggest number of CA
            if (parsedValidCAs[entry] > max) {
                max = parsedValidCAs[entry];
            }

            // add new options to select box only once
            if (redrawEjbca===true) {
                $select.append($('<option />', {
                    value: parsedValidCAs[entry],
                    text: entry + " (" + parsedValidCAs[entry] + ")"
                }));
            }

            data.addRow([entry, parsedValidCAs[entry]]);

            count++;
        }
    }

    // Set chart options
    var optionsVert = {
        'title':'Number of valid CAs at ' + date,
        chartArea:{left:200,right:100,top:50, bottom:200,width:"80%",height:"80%"},
        width: '100%',
        height: 600,
        bar: { groupWidth: '75%' },
        fontSize: 12
    };
    var optionsHoriz = {
        'title':'Number of valid CA at ' + date,
        chartArea:{right:0,bottom:15,top:60,width:"80%",height:"80%"},
        width: '100%',
        height: 15*count + 100,
        bar: { groupWidth: '75%' },
        fontSize: 12,
        backgroundColor: '#E4E4E4'
        
    };

    // Instantiate and draw our chart
    var verticalChart = new google.visualization.ColumnChart(document.getElementById('chartVerticalEjbca'));
    verticalChart.draw(data, optionsVert);

    var horizontalChart = new google.visualization.BarChart(document.getElementById('chartHorizontalEjbca'));
    horizontalChart.draw(data, optionsHoriz);

    var table = new google.visualization.Table(document.getElementById('tableEjbca'));
    // add to table sorting option
    google.visualization.events.addListener(table, 'sort', function(e){
        if(!sorting.hasOwnProperty('column')){
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
    })
    table.draw(data, {showRowNumber: true, sortAscending: false});

    // init slider with updated values
    $("#sliderEjbca").slider({
        value: treshold,
        min: 1,
        max: max,
        step: 1,
        slide: function( event, ui ) {
            $("#sliderValueEjbca").html(ui.value);
        }
    });
    
    $("#sliderValueEjbca").html($('#sliderEjbca').slider('value') );

    redrawEjbca = false;
}

// reads file
function readFileEjbca(callback) {

    var files = document.getElementById('filesEjbca').files;
    if (!files.length) {
        alert('Please select a file!');
        return;
    }

    var file = files[0];

    var reader = new FileReader();

    // If we use onloadend, we need to check the readyState.
    reader.onloadend = function(evt) {
        if (evt.target.readyState === FileReader.DONE) { // DONE == 2
            jsonEjbca = evt.target.result;
            callback();
        }
    };

    reader.readAsText(file);
}

function sortBothEjbcaByName() {
    $('#MasterSelectBoxEjbca').html($("#MasterSelectBoxEjbca option").sort(function (a,b) {
        return a.text === b.text ? 0 : a.text < b.text ? -1 : 1;
    }));
    $('#PairedSelectBoxEjbca').html($("#PairedSelectBoxEjbca option").sort(function (a,b) {
        return a.text === b.text ? 0 : a.text < b.text ? -1 : 1;
    }));
}
function sortBothEjbcaByValue() {
    $('#MasterSelectBoxEjbca').html($("#MasterSelectBoxEjbca option").sort(function (a,b) {
        return a.value === b.value ? (a.text === b.text ? 0 : a.text < b.text ? -1 : 1) : b.value - a.value ;
    }));
    $('#PairedSelectBoxEjbca').html($("#PairedSelectBoxEjbca option").sort(function (a,b) {
        return a.value === b.value ? (a.text === b.text ? 0 : a.text < b.text ? -1 : 1) : b.value - a.value;
    }));
}
function sortMasterEjbcaByName() {
    $('#MasterSelectBoxEjbca').html($("#MasterSelectBoxEjbca option").sort(function (a,b) {
        return a.text === b.text ? 0 : a.text < b.text ? -1 : 1;
    }));
}
function sortMasterEjbcaByValue() {
    $('#MasterSelectBoxEjbca').html($("#MasterSelectBoxEjbca option").sort(function (a,b) {
        return a.value === b.value ? (a.text === b.text ? 0 : a.text < b.text ? -1 : 1) : b.value - a.value ;
    }));
}
function sortPairedEjbcaByName() {    
    $('#PairedSelectBoxEjbca').html($("#PairedSelectBoxEjbca option").sort(function (a,b) {
        return a.text === b.text ? 0 : a.text < b.text ? -1 : 1;
    }));
}
function sortPairedEjbcaByValue() {
    $('#PairedSelectBoxEjbca').html($("#PairedSelectBoxEjbca option").sort(function (a,b) {
        return a.value === b.value ? (a.text === b.text ? 0 : a.text < b.text ? -1 : 1) : b.value - a.value;
    }));
}

function sortSelectBoxEjbca(sortType) {
    if (sortType === 'PairedEjbcaNum') {
        sortPairedEjbcaByValue();
    } else if (sortType === 'PairedEjbcaAbc') {
        sortPairedEjbcaByName();
    } else if (sortType === 'MasterEjbcaNum') {
        sortMasterEjbcaByValue();
    } else if (sortType === 'MasterEjbcaAbc') {
        sortMasterEjbcaByName();
    }
}

// Set a callback to run when the Google Visualization API is loaded.
google.charts.setOnLoadCallback(drawChartEjbca);

$(document).ready(function() {
    // slider
    $('#btnSliderEjbca').click(function() {
        treshold = $('#sliderEjbca').slider('value');
        drawChartEjbca();
    });

    // select boxes
    $('#btnAddEjbca').click(function() { 
        // move option from master to paired select box
        $('#MasterSelectBoxEjbca > option:selected').each(function() {
            var string = $(this).text();
            exclusiveEjbca.push(string.substring(0, string.lastIndexOf('(')-1));
        });
        $('#MasterSelectBoxEjbca > option:selected').appendTo('#PairedSelectBoxEjbca');

        // cruel sorting functions
        var sortType = $('input[name=Paired]:checked', '#PairedEjbca').val();

        sortSelectBoxEjbca(sortType);

        // redraw chart
        drawChartEjbca();
    });

    $('#btnRemoveEjbca').click(function() { 
        $('#PairedSelectBoxEjbca > option:selected').each(function() {
            var string = $(this).text();
            var index = exclusiveEjbca.indexOf(string.substring(0, string.lastIndexOf('(')-1));
            if (index > -1) {
                exclusiveEjbca.splice(index, 1);
            }
        });
        $('#PairedSelectBoxEjbca > option:selected').appendTo('#MasterSelectBoxEjbca'); 

        // cruel sorting functions2
        var sortType = $('input[name=Master]:checked', '#MasterEjbca').val();

        sortSelectBoxEjbca(sortType);

        // redraw chart
        drawChartEjbca();
    });

    // read file
    $('#btnReadFileEjbca').click(function() {
        readFileEjbca(function() {

            var str = document.getElementById('filesEjbca').value;

            // remove last '.json'
            date = str.slice(0, -5); 

            redrawEjbca = true;
            drawChartEjbca();
        });
    });

});

////////////////////////////////////////////////////////////////////////////////
function drawChartLdap() {

    // init values
    var max = 0;
    var parsedValidCAs = JSON.parse(jsonLdap);
    count = 0;

    // Create the data table.
    var data = new google.visualization.DataTable();
    data.addColumn('string', 'Organizations');
    data.addColumn('number', 'Count');  

    // set to default
    if (redrawLdap===true) {
        $("#PairedSelectBoxLdap").empty();
        $("#MasterSelectBoxLdap").empty();
        var $select = $('#MasterSelectBoxLdap');
        exclusiveLdap = [];
        treshold = 1;
    }
    
    for (var entry in parsedValidCAs) {

        if (parsedValidCAs[entry] >= treshold) {

            // do not add excluded organisations
            if (exclusiveLdap.indexOf(entry) != -1) {
                continue;
            } 

            // find the biggest number of CA
            if (parsedValidCAs[entry] > max) {
                max = parsedValidCAs[entry];
            }

            // add new options to select box only once
            if (redrawLdap===true) {
                $select.append($('<option />', {
                    value: parsedValidCAs[entry],
                    text: entry + " (" + parsedValidCAs[entry] + ")"
                }));
            }

            data.addRow([entry, parsedValidCAs[entry]]);

            count++;
        }
    }

    // Set chart options
    var optionsVert = {
        'title':'Number of valid CAs at ' + date,
        chartArea:{left:200,right:100,top:50, bottom:200,width:"80%",height:"80%"},
        width: '100%',
        height: 600,
        bar: { groupWidth: '75%' },
        fontSize: 12
    };
    var optionsHoriz = {
        'title':'Number of valid CA at ' + date,
        chartArea:{right:0,bottom:15,top:60,width:"80%",height:"80%"},
        width: '100%',
        height: 15*count + 100,
        bar: { groupWidth: '75%' },
        fontSize: 12,
        backgroundColor: '#E4E4E4'
        
    };

    // Instantiate and draw our chart
    var verticalChart = new google.visualization.ColumnChart(document.getElementById('chartVerticalLdap'));
    verticalChart.draw(data, optionsVert);

    var horizontalChart = new google.visualization.BarChart(document.getElementById('chartHorizontalLdap'));
    horizontalChart.draw(data, optionsHoriz);

    var table = new google.visualization.Table(document.getElementById('tableLdap'));
    // add to table sorting option
    google.visualization.events.addListener(table, 'sort', function(e){
        if(!sorting.hasOwnProperty('column')){
            sorting=e;
        }
        if(sorting.column===e.column){
            sorting.desc=sorting.ascending;
            sorting.ascending=!sorting.ascending;
        } else {
            sorting.desc=true;
            sorting.ascending=false;
            sorting.column=e.column;
        }
        data.sort([sorting]);
        table.draw(data, {showRowNumber: true});
    })
    table.draw(data, {showRowNumber: true, sortAscending: false});

    // init slider with updated values
    $("#sliderLdap").slider({
        value: treshold,
        min: 1,
        max: max,
        step: 1,
        slide: function( event, ui ) {
            $("#sliderValueLdap").html(ui.value);
        }
    });
    
    $("#sliderValueLdap").html($('#sliderLdap').slider('value') );

    redrawLdap = false;
}

// reads file
function readFileLdap(callback) {

    console.log("a nic :) (ldap does not have generated files)");
/*
    var files = document.getElementById('filesLdap').files;
    if (!files.length) {
        alert('Please select a file!');
        return;
    }

    var file = files[0];

    var reader = new FileReader();

    // If we use onloadend, we need to check the readyState.
    reader.onloadend = function(evt) {
        if (evt.target.readyState == FileReader.DONE) { // DONE == 2
            jsonLdap = evt.target.result;
            callback();
        }
    };

    reader.readAsText(file);*/
}

function sortBothLdapByName() {
    $('#MasterSelectBoxLdap').html($("#MasterSelectBoxLdap option").sort(function (a,b) {
        return a.text === b.text ? 0 : a.text < b.text ? -1 : 1;
    }));
    $('#PairedSelectBoxLdap').html($("#PairedSelectBoxLdap option").sort(function (a,b) {
        return a.text === b.text ? 0 : a.text < b.text ? -1 : 1;
    }));
}
function sortBothLdapByValue() {
    $('#MasterSelectBoxLdap').html($("#MasterSelectBoxLdap option").sort(function (a,b) {
        return a.value === b.value ? (a.text === b.text ? 0 : a.text < b.text ? -1 : 1) : b.value - a.value ;
    }));
    $('#PairedSelectBoxEjbcaLdap').html($("#PairedSelectBoxLdap option").sort(function (a,b) {
        return a.value === b.value ? (a.text === b.text ? 0 : a.text < b.text ? -1 : 1) : b.value - a.value;
    }));
}
function sortMasterLdapByName() {
    $('#MasterSelectBoxLdap').html($("#MasterSelectBoxLdap option").sort(function (a,b) {
        return a.text === b.text ? 0 : a.text < b.text ? -1 : 1;
    }));
}
function sortMasterLdapByValue() {
    $('#MasterSelectBoxLdap').html($("#MasterSelectBoxLdap option").sort(function (a,b) {
        return a.value === b.value ? (a.text === b.text ? 0 : a.text < b.text ? -1 : 1) : b.value - a.value ;
    }));
}
function sortPairedLdapByName() {    
    $('#PairedSelectBoxLdap').html($("#PairedSelectBoxLdap option").sort(function (a,b) {
        return a.text === b.text ? 0 : a.text < b.text ? -1 : 1;
    }));
}
function sortPairedLdapByValue() {
    $('#PairedSelectBoxLdap').html($("#PairedSelectBoxLdap option").sort(function (a,b) {
        return a.value === b.value ? (a.text === b.text ? 0 : a.text < b.text ? -1 : 1) : b.value - a.value;
    }));
}

function sortSelectBoxLdap(sortType) {
    if (sortType === 'PairedLdapNum') {
        sortPairedLdapByValue();
    } else if (sortType === 'PairedLdapAbc') {
        sortPairedLdapByName();
    } else if (sortType === 'MasterLdapNum') {
        sortMasterLdapByValue();
    } else if (sortType === 'MasterLdapAbc') {
        sortMasterLdapByName();
    }
}

// Set a callback to run when the Google Visualization API is loaded.
google.charts.setOnLoadCallback(drawChartLdap);

$(document).ready(function() {
    // slider
    $('#btnSliderLdap').click(function() {
        treshold = $('#sliderLdap').slider('value');
        drawChartLdap();
    });

    // select boxes
    $('#btnAddLdap').click(function() { 
        // move option from master to paired select box
        $('#MasterSelectBoxLdap > option:selected').each(function() {
            var string = $(this).text();
            exclusiveLdap.push(string.substring(0, string.lastIndexOf('(')-1));
        });
        $('#MasterSelectBoxLdap > option:selected').appendTo('#PairedSelectBoxLdap');

        // cruel sorting functions
        var sortType = $('input[name=Paired]:checked', '#PairedLdap').val();

        sortSelectBoxLdap(sortType);

        // redraw chart
        drawChartLdap();
    });

    $('#btnRemoveLdap').click(function() { 
        $('#PairedSelectBoxLdap > option:selected').each(function() {
            var string = $(this).text();
            var index = exclusiveLdap.indexOf(string.substring(0, string.lastIndexOf('(')-1));
            if (index > -1) {
                exclusiveLdap.splice(index, 1);
            }
        });
        $('#PairedSelectBoxLdap > option:selected').appendTo('#MasterSelectBoxLdap'); 

        // cruel sorting functions2
        var sortType = $('input[name=Master]:checked', '#MasterLdap').val();

        sortSelectBoxLdap(sortType);

        // redraw chart
        drawChartLdap();
    });

    // read file
    $('#btnReadFileLdap').click(function() {
        
        alert("Ldap does not have generated files.");
            
        readFileLdap(function() {

            
            /*var str = document.getElementById('filesLdap').value;

            // remove last '.json'
            date = str.slice(0, -5); 

            redrawLdap = true;
            drawChartLdap();*/
        });
    });

});