
var nodesLeft = []; //Global variable to the left nodes
var nodesRight = [];//Global variable to the right nodes
var availableWidth;
var availableHeight;
var valueSlider=0;
var iniciado = false;

//Check variables
var splitsG = false;;
var mergersG = false;;
var movesG = false;
var renamesG = false;
var exclusionsG = false;
var newsG = false;
var conguencyG = false;
var allG = false;
var clearG = false;
var file1 = "";
var file2 = "";


function setsplitsG(){
     var processingInstance;
    processingInstance = Processing.getInstanceById('CANVAS');
    if (splitsG == false){
        splitsG = true;
        var  cantidadSplits = processingInstance.returnAmountSplits(); 
        document.getElementById("SplitsStatsValue").innerHTML = cantidadSplits;      
    }
    else{
        splitsG = false;
        document.getElementById("SplitsStatsValue").innerHTML = "0"; 
    }
}

function setsmergersG(){
     var processingInstance;
    processingInstance = Processing.getInstanceById('CANVAS');
    if (mergersG == false){
        mergersG = true;
        var cantidadMergers = processingInstance.returnCantidadMergers();
        document.getElementById("MergesStatsValue").innerHTML = cantidadMergers;   
    }
    else{
        mergersG = false;
        document.getElementById("MergesStatsValue").innerHTML = "0";
    }
}

function setsmovesG(){
     var processingInstance;
    processingInstance = Processing.getInstanceById('CANVAS');
    if (movesG == false){
        movesG = true;
        var cantidadMoves = processingInstance.returnMoves();   
        document.getElementById("MovesStatsValue").innerHTML = cantidadMoves;     
    }
    else{
        movesG = false;
        document.getElementById("MovesStatsValue").innerHTML = "0";  
    }
}

function setsrenamesG(){
     var processingInstance;
    processingInstance = Processing.getInstanceById('CANVAS');
    if (renamesG == false){
        renamesG = true;
        var cantidadRename = processingInstance.returnRenames();  
        document.getElementById("RenamesStatsValue").innerHTML = cantidadRename;  
    }
    else{
        renamesG = false;
        document.getElementById("RenamesStatsValue").innerHTML = "0"; 
    }
}

function setsexclusionsG(){
    var processingInstance;
    processingInstance = Processing.getInstanceById('CANVAS');
    if (exclusionsG == false){
        exclusionsG = true;
        var cantidadExclusiones = processingInstance.returnExclusiones();
        document.getElementById("ExclusionStatsValue").innerHTML = cantidadExclusiones;           
    }
    else{
        exclusionsG = false;
         document.getElementById("ExclusionStatsValue").innerHTML = "0";  
    }
}

function setnewsG(){
    var processingInstance;
    processingInstance = Processing.getInstanceById('CANVAS');
    if (newsG == false){
        newsG = true;
        var cantidadNuevos = processingInstance.returnNuevos();
        document.getElementById("NewStatsValue").innerHTML = cantidadNuevos;
    }
    else{
        newsG = false;
         document.getElementById("NewStatsValue").innerHTML = "0";
    }
}

function setconguencyG(){
     var processingInstance;
    processingInstance = Processing.getInstanceById('CANVAS');
    if (conguencyG == false){
        conguencyG = true;
        processingInstance.Congruencia(); 
        var cantidadCongruentes = processingInstance.returnCongruentes(); 
        document.getElementById("CongruenceStatsValue").innerHTML = cantidadCongruentes;
    }
    else{
        conguencyG = false;
        document.getElementById("CongruenceStatsValue").innerHTML = "0";
    }
}

function setAllG(){
    if (allG == false){
        setsmergersG();
        setconguencyG();
        setnewsG();
        setsexclusionsG();
        setsrenamesG();
        setsplitsG();
        setsmovesG();
        allG = true;
        document.getElementById("Congruencia").checked = true;
        document.getElementById("Splits").checked = true;
        document.getElementById("Mergers").checked = true;
        document.getElementById("Moves").checked = true;
        document.getElementById("Renames").checked = true;
        document.getElementById("News").checked = true;
        document.getElementById("Exclusions").checked = true;
    }
    else{
        allG = false;
        setconguencyG();
        setnewsG();
        setsexclusionsG();
        setsrenamesG();
        setsmergersG();
        setsplitsG();
        setsmovesG();
        document.getElementById("Congruencia").checked = false;
        document.getElementById("Splits").checked = false;
        document.getElementById("Mergers").checked = false;
        document.getElementById("Moves").checked = false;
        document.getElementById("Renames").checked = false;
        document.getElementById("News").checked = false;
        document.getElementById("Exclusions").checked = false;
    }
}


$(window).resize(function() {
    window.location.href = window.location.href;
});

availableWidth = $(window).width(); //size of the width of the screen
availableHeight = $(window).height();

function loadFiles (file1, file2){
    d3.json("Archivos-Datos/"+file1, function (err, data) {
        var Ltree = d3.layout.treelist()
            .childIndent(20)
            .nodeHeight(20);
        function render(data, parent) {
                var nodes = Ltree.nodes(data),
                duration = 1000;
                for(var node = 0;node<nodes.length;node++){
                    if(nodes[node].children!=null){
                        nodes[node]["has_parent"] = "yes";    
                        nodes[node]["position"] = "left";
                    }
                    else{
                        nodes[node]["has_parent"] = "no";    
                        nodes[node]["position"] = "left";
                    }
                } 
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
                for(var node = 0;node<nodes.length;node++){
                    if(nodes[node].children!=null){
                        nodes[node]["has_parent"] = "yes";    
                        nodes[node]["position"] = "right";
                        nodes[node]["R"] = 0;
                        nodes[node]["G"] = 0;
                        nodes[node]["B"] = 0;
                    }
                    else{
                        nodes[node]["has_parent"] = "no";    
                        nodes[node]["position"] = "right";
                        nodes[node]["R"] = 0;
                        nodes[node]["G"] = 0;
                        nodes[node]["B"] = 0;
                    }
                    
                }
                nodesRight = nodes;
            }
            render(data, data);
             var processingInstance;
            processingInstance = Processing.getInstanceById('CANVAS');
            var archivo1 = file1.replace(".json", "");
            var archivo2 = file2.replace(".json", "");
            processingInstance.setNames(archivo1,archivo2);   
            processingInstance.setup();
    });
}


function nuevaventana (){
    var processingInstance;
    processingInstance = Processing.getInstanceById('CANVAS');
    processingInstance.setup();
    var win = window.open("../Abrir_Taxonomias/index.html","ventana1","width=400,height=300,scrollbars=NO");
    var trigger = setInterval(function(){
       if (win.closed){
        loadFiles(file1,file2);
        clearInterval(trigger);
        console.log("Success");
       }    
    },1000); 
    //loadFiles("datos1.json","datos2.json");
}
