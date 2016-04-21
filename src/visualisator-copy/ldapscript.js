/* 
    Created on : 18.3.2016, 15:47:26
    Author     : jana
*/

/* global google */

// init values
var jsonServer;
var jsonLdap;
var jsonClient;

var dateServer;
var dateLdap;
var dateClient;

var exclusiveServer = [];
var exclusiveLdap = [];
var exclusiveClient = [];

var redrawServer = true;
var redrawLdap = true;
var redrawClient = true;

var countServer;
var countLdap;
var countClient;

var tresholdServer = 1;
var tresholdLdap = 1;
var tresholdClient = 1;

var json = {
    'Server': jsonServer,
    'Ldap': jsonLdap,
    'Client': jsonClient
};
var date = {
    'Server': dateServer,
    'Ldap': dateLdap,
    'Client': dateClient
};
var exclusive = {
    'Server': exclusiveServer,
    'Ldap': exclusiveLdap,
    'Client': exclusiveClient
};
var redraw = {
    'Server': redrawServer,
    'Ldap': redrawLdap,
    'Client': redrawClient
};
var treshold = {
    'Server': tresholdServer,
    'Ldap': tresholdLdap,
    'Client': tresholdClient
};

// Load the Visualization API and the corechart package.
google.charts.load('current', {'packages':['bar']});

function sortNumberss(a,b) {
    return b-a;
}

function sortJsonByAlphabeth(json) {
    var orderedByName = {};
    Object.keys(json).sort().forEach(function(key) {
        orderedByName[key] = json[key];
    });

    return orderedByName;
}

function sortJsonByNumbers(json) {
    var swappedJSON = {};
    Object.keys(json).sort(sortNumberss).forEach(function(key) {
        swappedJSON[json[key]] = key;
    });
    var swappedJSONback = {};
    Object.keys(swappedJSON).sort(sortNumberss).forEach(function(key) {
        swappedJSONback[swappedJSON[key]] = key;
    });

    return swappedJSONback;
}

function orderArray(array_with_order, array_to_order) {
                   // server          ldap original
    var ordered_array = [];
    var len = Object.keys(array_to_order).length;
    var index;
    var current;
    var remaining = [];
    
    var keys = Object.keys(array_to_order);    
    
    for (var i = 0; i < len; i++) {      
        current = array_to_order[keys[i]];
        index = array_with_order.indexOf(current[0].name);
        if (index !== -1) {
        	ordered_array[index] = current[0];
        } else {
          remaining.push(current[0]);
        }
    }

    for (var i = 0; i < remaining.length; i++) {
        ordered_array.push(remaining[i]);
    }
		
    //return changed the array
    return ordered_array;
}

function drawOnlyChart(sortBy) {
    // init values
    count = 0;

    var parsedValidCAs = JSON.parse(json['Ldap']);
    var parsedValidServerCAs = JSON.parse(json['Client']);
    var parsedValidClientCAs = JSON.parse(json['Server']);
   
   alert(parsedValidCAs.organizations);
   console.log(Object.keys(JSON.parse(json['Ldap']).organizations));
   
    var originalSorted;
   
    // sort
    if (sortBy != null) {
        var sorted;
        
        var radioChecked = $('input[name="Master'+sortBy+'"]:checked').val();
        if (radioChecked === 'Master'+sortBy+'Abc') {            
            switch(sortBy) {
                case 'Ldap':
                    sorted = sortJsonByAlphabeth(parsedValidCAs);
                    break;
                case 'Client':
                    sorted = sortJsonByAlphabeth(parsedValidClientCAs);
                    break;
                case 'Server':
                    sorted = sortJsonByAlphabeth(parsedValidServerCAs);
                    break;            
            }
        } else if (radioChecked === 'Master'+sortBy+'Num') {
            switch(sortBy) {
                case 'Ldap':
                    sorted = sortJsonByNumbers(parsedValidCAs);
                    break;
                case 'Client':
                    sorted = sortJsonByNumbers(parsedValidClientCAs);
                    break;
                case 'Server':
                    sorted = sortJsonByNumbers(parsedValidServerCAs);
                    break;            
            }
        }
        
        var sortedKeys = Object.keys(sorted);

        //originalSorted = orderArray(sortedKeys, parsedValidCAs.organizations);
        //console.log(originalSorted);        
        
        //parsedValidCAs = sorted;
    }
    // Create the data table.
    var data = new google.visualization.DataTable();
    data.addColumn('string', 'Organizations');
    data.addColumn('number', 'Count All');  
    data.addColumn('number', 'Count Client CAs');  
    data.addColumn('number', 'Count Server CAs');  
    
    // generate data
    for (var entry in parsedValidCAs.organizations) {

        var orgAll = parsedValidCAs.organizations[entry][0];  
        var orgClient;
        var orgServer;     
            
        var numAll = parseInt(orgAll.count);
        var numClient = 0;
        var numServer = 0;
        
        if (parsedValidClientCAs.organizations[entry] === undefined || parsedValidClientCAs.organizations[entry] === null) {
            orgClient = -1;
        } else {
            orgClient = parsedValidClientCAs.organizations[entry][0];
            numClient = parseInt(orgClient.count);
            if (exclusive['Client'].indexOf(orgClient.name) !== -1 || orgClient.count < treshold['Client']) {
                numClient = 0;
            }
        }
        
        if (parsedValidServerCAs.organizations[entry] === undefined || parsedValidServerCAs.organizations[entry] === null) {
            orgServer = -1;
        } else {
            orgServer = parsedValidServerCAs.organizations[entry][0];
            numServer = parseInt(orgServer.count);
            if (exclusive['Server'].indexOf(orgServer.name) !== -1 || orgServer.count < treshold['Server']) {
                numServer = 0;
            }
        }
        
        // do not add excluded organisations
        if (exclusive['Ldap'].indexOf(orgAll.name) !== -1 || orgAll.count < treshold['Ldap']) {
            numAll = 0;
        }
          
        if (numAll != 0 || numClient != 0 || numServer != 0) {
            data.addRow([orgAll.name, numAll, numClient, numServer]);
            count++;
        }       
    }
    
    // Set chart options
    var optionsHoriz = {
        'title':'Number of valid CAs at ' + date['Ldap'],
        //chartArea:{left:200,right:100,top:50, bottom:200,width:"80%",height:"80%"},
        width: '100%',
        height: 50*count + 200,
        bar: { groupWidth: '75%' },
        fontSize: 12,
        bars: 'horizontal'
    };

    var horizontalChart = new google.charts.Bar(document.getElementById('chartVerticalLdap'));
    horizontalChart.draw(data, optionsHoriz);
    
    // redraw is not need
    redraw['Ldap'] = false;
}

function setSelectBox(parameter) {    
    // init values
    var max = 0;

    var parsedValidCAs = JSON.parse(json[parameter]);   
            
    // set to default
    if (redraw[parameter]===true) {
        $("#PairedSelectBox"+parameter).empty();
        $("#MasterSelectBox"+parameter).empty();
        $selectBox = $('#MasterSelectBox'+parameter);
        exclusive[parameter] = [];
        treshold[parameter] = 1;
    }

    // sort
    var radioChecked = $('input[name="Master'+parameter+'"]:checked').val();
    if (radioChecked === 'Master'+parameter+'Abc') {
        parsedValidCAs = sortJsonByAlphabeth(parsedValidCAs);
    } else if (radioChecked === 'Master'+parameter+'Num') {
        parsedValidCAs = sortJsonByNumbers(parsedValidCAs);
    }

    // generate data
    for (var entry in parsedValidCAs.organizations) {

        var org = parsedValidCAs.organizations[entry][0];
                    
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
        }
    }
    
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

function sortMasterByName(parameter) {
    $('#MasterSelectBox'+parameter).html($("#MasterSelectBox"+parameter+" option").sort(function (a,b) {
        return a.text === b.text ? 0 : a.text < b.text ? -1 : 1;
    }));
    setSelectBox(parameter);
    drawOnlyChart(parameter);
}
function sortMasterByValue(parameter) {
    $('#MasterSelectBox'+parameter).html($("#MasterSelectBox"+parameter+" option").sort(function (a,b) {
        return a.value === b.value ? (a.text === b.text ? 0 : a.text < b.text ? -1 : 1) : b.value - a.value ;
    }));
    setSelectBox(parameter);
    drawOnlyChart(parameter);
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

google.charts.setOnLoadCallback(drawOnlyChart);



$(document).ready(function() {

    setSelectBox('Ldap');
    setSelectBox('Server');
    setSelectBox('Client');

    // slider Client
    $('#btnSliderClient').click(function() {
        treshold['Client'] = $('#sliderClient').slider('value');
        setSelectBox('Client');
        drawOnlyChart();
    });
    // slider Ldap
    $('#btnSliderLdap').click(function() {
        treshold['Ldap'] = $('#sliderLdap').slider('value');
        setSelectBox('Ldap');
        drawOnlyChart();
    });
    // slider Server
    $('#btnSliderServer').click(function() {
        treshold['Server'] = $('#sliderServer').slider('value');
        setSelectBox('Server');
        drawOnlyChart();
    });


    // select boxes add Client
    $('#btnAddClient').click(function() { 
        // move option from master to paired select box
        $('#MasterSelectBoxClient > option:selected').each(function() {
            var string = $(this).text();
            exclusive['Client'].push(string.substring(0, string.lastIndexOf('(')-1));
        });
        $('#MasterSelectBoxClient > option:selected').appendTo('#PairedSelectBoxClient');
        // cruel sorting functions
        var sortType = $('input[name=Paired]:checked', '#PairedClient').val();
        sortSelectBox(sortType,'Client');
        // redraw chart
        setSelectBox('Client');
        drawOnlyChart();
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
        setSelectBox('Ldap');
        drawOnlyChart();
    });
    // select boxes add Server
    $('#btnAddServer').click(function() { 
        // move option from master to paired select box
        $('#MasterSelectBoxServer > option:selected').each(function() {
            var string = $(this).text();
            exclusive['Server'].push(string.substring(0, string.lastIndexOf('(')-1));
        });
        $('#MasterSelectBoxServer > option:selected').appendTo('#PairedSelectBoxServer');
        // cruel sorting functions
        var sortType = $('input[name=Paired]:checked', '#PairedServer').val();
        sortSelectBox(sortType,'Server');
        // redraw chart
        setSelectBox('Server');
        drawOnlyChart();
    });


    // select boxes remove Client
    $('#btnRemoveClient').click(function() { 
        $('#PairedSelectBoxClient > option:selected').each(function() {
            var string = $(this).text();
            var index = exclusive['Client'].indexOf(string.substring(0, string.lastIndexOf('(')-1));
            if (index > -1) {
                exclusive['Client'].splice(index, 1);
            }
        });
        $('#PairedSelectBoxClient > option:selected').appendTo('#MasterSelectBoxClient');
        // cruel sorting functions2
        var sortType = $('input[name=Master]:checked', '#MasterClient').val();
        sortSelectBox(sortType,'Client');
        // redraw chart
        setSelectBox('Client');
        drawOnlyChart();
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
        setSelectBox('Ldap');
        drawOnlyChart();
    });
    // select boxes remove Server
    $('#btnRemoveServer').click(function() { 
        $('#PairedSelectBoxServer > option:selected').each(function() {
            var string = $(this).text();
            var index = exclusive['Server'].indexOf(string.substring(0, string.lastIndexOf('(')-1));
            if (index > -1) {
                exclusive['Server'].splice(index, 1);
            }
        });
        $('#PairedSelectBoxServer > option:selected').appendTo('#MasterSelectBoxServer');
        // cruel sorting functions2
        var sortType = $('input[name=Master]:checked', '#MasterServer').val();
        sortSelectBox(sortType,'Server');
        // redraw chart
        setSelectBox('Server');
        drawOnlyChart();
    });

});