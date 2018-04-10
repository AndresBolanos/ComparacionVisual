

var id = 0;
var x = 1;
var nodesLeft = []; //Global variable to the left nodes
var nodesRight = [];//Global variable to the right nodes
var svg;//Global variable to the canvas in the screen
var anchoDiv ;//Global variable to the size of the div to draw the lines
var NODOS = [];
var padres = [];//are cleaned in a function 

//Definition of the statics variables
var cantidadSplits;
var cantidadMergers;
var cantidadRename;
var cantidadMoves;
var cantidadEclusiones;
var cantidadNuevos;
var cantidadCongruentes;
var availableWidth;
var availableHeight;
var text;
var iniciar = false;

$(window).resize(function() {
    window.location.href = window.location.href;
});
availableWidth = $(window).width(); //size of the width of the screen

//var margin = {top: -5, right: -5, bottom: -5, left: -5};
var margin = -5;

function loadFiles (file1, file2){
   d3.json("Archivos-Datos/"+file1, function (err, data) {
        var Ltree = d3.layout.treelist()
            .childIndent(20)
            .nodeHeight(20);
        function render(data, parent) {
                var nodes = Ltree.nodes(data),
                duration = 1000;
                nodesLeft = nodes;
            }
            render(data, data);
    });


    d3.json("Archivos-Datos/"+file2, function (err, data) {
        var Ltree = d3.layout.treelist()
            .childIndent(20)
            .nodeHeight(20);

        var ul = d3.select("#leftSide").append("ul").classed("treelist", "true");
        function render(data, parent) {
                var nodes = Ltree.nodes(data),
                duration = 1000;
                nodesRight = nodes;
            }
            render(data, data);
            console.log(nodesRight)
            iniciar = true;
            var processingInstance;
            processingInstance = Processing.getInstanceById('CANVAS'); 
            var archivo1 = file1.replace(".json", "");
            var archivo2 = file2.replace(".json", "");
            processingInstance.setNames(archivo1,archivo2);         
            processingInstance.setup();
            processingInstance.set_Inicio(true);
            processingInstance.setExclusiones(false);
            processingInstance.setNuevos(false);
            processingInstance.redraw();
    });
    
}


//$(document).ready(click);
/*
function click(){ 
        console.log("Clickeo"); 
        
        console.log("Si");
}*/
