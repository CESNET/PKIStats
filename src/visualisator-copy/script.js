/* 
    Created on : 18.3.2016, 15:47:26
    Author     : jana
*/

// init values
var json = '{"Academy of Arts Architecture and Design Prague":1,"Academy of Performing Arts in Prague":2,"Anglo-Czech High School":1,"Biology Centre of the ASCR, v. v. i.":1,"Brailcom":1,"CESNET":135,"CTU in Prague":911,"CZ.NIC":3,"Center for School Services Pilsen":1,"Centre for Higher Education Studies":1,"Centre for Innovation and Projects, VSTE":2,"Centre of Administration and Operations, ASCR":14,"Charles University in Prague":1,"College of Media and Journalism":2,"College of Polytechnics Jihlava":3,"Czech - Slavonic Business Academy of Doctor Edvard Benes":1,"Czech Science Foundation":1,"Czech University of Life Sciences Prague":6,"Department of Agricultural Economics and Information":2,"FZU":1,"Fire Rescue Service of Olomouc Region":1,"General Faculty Hospital in Prague":1,"Global Change Research Center, ASCR":1,"Gymnazium Cheb":1,"High School of Chemistry in Pardubice":2,"High School of Civil Engineering Liberec":2,"High School of Informatics and Financial Services":2,"Higher Professional School of Information Services":1,"Hospital Jihlava":3,"Hotel school Podebrady":1,"Institute of Archeology of the Academy of Sciences of the CR":1,"Institute of Biophysics, Academy of Sciences of the CR":1,"Institute of Botany of the Academy of Science of the CR":1,"Institute of Chemical Process Fundamentals, ASCR":3,"Institute of Chemical Process Fundamentals/C ASCR":1,"Institute of Chemical Technology, Prague":2,"Institute of Computer Science, ASCR, v.v.i.":3,"Institute of Czech Literature AS CR":1,"Institute of Geonics of the Academy of Sciences of the CR":1,"Institute of Information Theory and Automation, ASCR":1,"Institute of Macromolecular Chemistry, ASCR":1,"Institute of Mathematics, ASCR":1,"Institute of Microbiology of the Academy of Sciences of the Czech Republic, v.v.i.":2,"Institute of Molecular Genetics, ASCR":2,"Institute of Organic Chemistry and Biochemistry, ASCR":5,"Institute of Philosophy of the Academy of Sciences of the Czech Republic, v.v.i.":1,"Institute of Physical Chemistry, ASCR":4,"Institute of Physics of Materials of the Academy of Sciences of the CR":1,"Institute of Physics of Materials, ASCR":1,"Institute of Physics of the Academy of Sciences of the CR":23,"Institute of Plasma Physics, Academy of Sciences of the CR":2,"Institute of Scientific Instruments, ASCR":1,"Institute of Technology and Business in Ceske Budejovice":1,"Institute of Theoretical and Applied Mechanics, v.v.i.":1,"Institute of Thermomechanics, Academy of Sciences of the CR":4,"Jan Amos Komensky University Prague":2,"Janacek Academy of Music and Performing Arts in Brno":2,"Klet Observatory":3,"MUNI":4,"Masaryk Grammar School":1,"Masaryk Memorial Cancer Institute":2,"Masaryk University":6,"Mathias Lerch Gymnasium":5,"Mendel University in Brno":2,"Metropolitan University Prague":1,"Ministry of Education, Youth and Sports":2,"Moravian Library":4,"Moravian University College Olomouc":3,"Moravian-Silesian Research Library in Ostrava":2,"Municipal Library Ceska Trebova":1,"Municipal Library of Prague":1,"National Institute of Mental Health":3,"National Library of the Czech Republic":2,"National Medical Library":1,"National Museum":2,"National Technical Library":3,"Nuclear Physics Institute of the Academy of Sciences of the CR":2,"OSVC":1,"Pilsen Region":2,"Private Secondary School of Information Technologies":1,"Research Library in Olomouc":2,"Secondary School of Applied Cybernetics":1,"Secondary School of Electrotechnics and Informatics, Ostrava":2,"Secondary Technical School of Electrical Engineering and Technology College in Pisek":1,"Secondary Technical School of Mechanical Engineering, Pilsen":1,"Secondary technical school, UL":1,"Silesian University":1,"Softweco Group":1,"State institute for drug control":2,"T. G. Masaryk Water Research Institute":1,"Technical University of Liberec":1,"Technology Centre ASCR":1,"Tertiary College and Secondary School of Electrical Engineering, Pilsen":2,"The Education and Research Library of the Pilsener Region":1,"The Institute of Hospitality Management":2,"The National Pedagogical Museum and Library of J. A. Comenius":1,"The Research Library in Ceske Budejovice":2,"The Research Library in Hradec Kralove":2,"The University Hospital Brno":5,"Tomas Bata University in Zlin":2,"University Hospital Ostrava":1,"University hospital Hradec Kralove":2,"University of Defence in Brno":4,"University of Economics, Prague":4,"University of Hradec Kralove":3,"University of J. E. Purkyne":1,"University of Ostrava":1,"University of Pardubice":3,"University of South Bohemia Ceske Budejovice":1,"University of Veterinary and Pharmaceutical Sciences Brno":7,"University of West Bohemia":2,"VUMS Computers":1,"Vysocina Region":2,"ZCU":1,"Západočeská univerzita v Plzni":590}';
var date = '2016-01-01';
var exclusive = [];
var treshold = 1;
var count;            
var redraw = true; // if redraw is needed

// Load the Visualization API and the corechart package.
google.charts.load('current', {'packages':['corechart', 'table', 'bar']});

// Callback that creates and populates a data table, instantiates the chart, 
// passes in the data and draws it.    
function drawChart() {
    
    // init values
    var max = 0;
    var parsedValidCAs = JSON.parse(json);
    count = 0;
    
    // Create the data table.
    var data = new google.visualization.DataTable();
    data.addColumn('string', 'Organizations');
    data.addColumn('number', 'Count');  

    // set to default
    if (redraw==true) {
        $("#PairedSelectBox").empty();         
        $("#MasterSelectBox").empty();    
        var $select = $('#MasterSelectBox'); 
        exclusive = [];
        treshold = 1;
    }
    
    for (var entry in parsedValidCAs) {                       

        if (parsedValidCAs[entry] >= treshold) {
            
            // do not add excluded organisations
            if (exclusive.indexOf(entry) != -1) {
                continue;
            } 
            
            // find the biggest number of CA
            if (parsedValidCAs[entry] > max) {
                max = parsedValidCAs[entry];
            }   
            
            // add new options to select box only once
            if (redraw==true) {
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
    var verticalChart = new google.visualization.ColumnChart(document.getElementById('chart_vert_div'));
    verticalChart.draw(data, optionsVert);

    var horizontalChart = new google.visualization.BarChart(document.getElementById('chart_horiz_div'));
    horizontalChart.draw(data, optionsHoriz);

    var table = new google.visualization.Table(document.getElementById('table_div'));
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
    table.draw(data, {showRowNumber: true, width: '50%', height: '50%', sortAscending: false});
    
    // init slider with updated values
    $("#slider").slider({
        value: treshold,
        min: 1,
        max: max,
        step: 1,
        slide: function( event, ui ) {
            $("#slider-value").html(ui.value);
        }
    });
    
    $("#slider-value").html($('#slider').slider('value') );       
    
    redraw = false;
}

// reads file
function readFile(callback) {

    var files = document.getElementById('files').files;
    if (!files.length) {
        alert('Please select a file!');
        return;
    }

    var file = files[0];

    var reader = new FileReader();

    // If we use onloadend, we need to check the readyState.
    reader.onloadend = function(evt) {
        if (evt.target.readyState == FileReader.DONE) { // DONE == 2
            json = evt.target.result;                         
            callback();
        }
    };

    reader.readAsText(file);                
}

function sortBothByName() {
    $('#MasterSelectBox').html($("#MasterSelectBox option").sort(function (a,b) {                    
        return a.text == b.text ? 0 : a.text < b.text ? -1 : 1;            
    }));
    $('#PairedSelectBox').html($("#PairedSelectBox option").sort(function (a,b) {                    
        return a.text == b.text ? 0 : a.text < b.text ? -1 : 1;            
    }));
}
function sortBothByValue() {
    $('#MasterSelectBox').html($("#MasterSelectBox option").sort(function (a,b) {                  
        return a.value == b.value ? (a.text == b.text ? 0 : a.text < b.text ? -1 : 1) : b.value - a.value ;            
    }));
    $('#PairedSelectBox').html($("#PairedSelectBox option").sort(function (a,b) {                    
        return a.value == b.value ? (a.text == b.text ? 0 : a.text < b.text ? -1 : 1) : b.value - a.value;     
    }));
}
function sortMasterByName() {
    $('#MasterSelectBox').html($("#MasterSelectBox option").sort(function (a,b) {                    
        return a.text == b.text ? 0 : a.text < b.text ? -1 : 1;            
    }));
}
function sortMasterByValue() {
    $('#MasterSelectBox').html($("#MasterSelectBox option").sort(function (a,b) {                  
        return a.value == b.value ? (a.text == b.text ? 0 : a.text < b.text ? -1 : 1) : b.value - a.value ;            
    }));    
}
function sortPairedByName() {    
    $('#PairedSelectBox').html($("#PairedSelectBox option").sort(function (a,b) {                    
        return a.text == b.text ? 0 : a.text < b.text ? -1 : 1;            
    }));
}
function sortPairedByValue() {
    $('#PairedSelectBox').html($("#PairedSelectBox option").sort(function (a,b) {                    
        return a.value == b.value ? (a.text == b.text ? 0 : a.text < b.text ? -1 : 1) : b.value - a.value;     
    }));
}

function sortSelectBox(sortType) {
    if (sortType === 'PairedNum') {
        sortPairedByValue();
    } else if (sortType === 'PairedAbc') {
        sortPairedByName();
    } else if (sortType === 'MasterNum') {
        sortMasterByValue();
    } else if (sortType === 'MasterAbc') {
        sortMasterByName();
    }
}

// Set a callback to run when the Google Visualization API is loaded.
google.charts.setOnLoadCallback(drawChart);

$(document).ready(function() {
    // slider
    $('#btn_slider').click(function() {
        treshold = $('#slider').slider('value');
        drawChart();                    
    });

    // select boxes
    $('#btnAdd').click(function() { 
        // move option from master to paired select box
        $('#MasterSelectBox > option:selected').each(function() {
            var string = $(this).text();
            exclusive.push(string.substring(0, string.indexOf('(')-1));
        });
        $('#MasterSelectBox > option:selected').appendTo('#PairedSelectBox'); 
        
        // cruel sorting functions
        var sortType = $('input[name=Paired]:checked', '#Paired').val();       
        
        sortSelectBox(sortType);
        
        // redraw chart        
        drawChart();
    });  
    
    $('#btnRemove').click(function() { 
        $('#PairedSelectBox > option:selected').each(function() {
            var string = $(this).text();
            var index = exclusive.indexOf(string.substring(0, string.indexOf('(')-1));
            if (index > -1) {
                exclusive.splice(index, 1);
            }
        });        
        $('#PairedSelectBox > option:selected').appendTo('#MasterSelectBox'); 
        
        // cruel sorting functions2
        var sortType = $('input[name=Master]:checked', '#Master').val();
                        
        sortSelectBox(sortType);
        
        // redraw chart        
        drawChart();
    });  

    // read file
    $('#btnReadText').click(function() {
        readFile(function() {

            var str = document.getElementById('files').value;
            
            // remove last '.json'
            date = str.slice(0, -5); 

            redraw = true;
            drawChart();
        });    
    });

});



