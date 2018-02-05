
var nodesLeft = []; //Global variable to the left nodes
var nodesRight = [];//Global variable to the right nodes
var availableWidth;
var availableHeight;
var valueSlider=0;
var iniciado = false;
var iniciadoProceso = false;

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
var LastValue = 0;
var onebyone = false;
var terminado;


var cantidadSplits;
var cantidadMergers;
var cantidadRename;
var cantidadMoves;
var cantidadEclusiones;
var cantidadNuevos;
var cantidadCongruentes;

function setsplitsG(){
    if (splitsG == false){
        splitsG = true;
    }
    else{
        splitsG = false;
    }
    console.log(splitsG);
}

function setsmergersG(){
    if (mergersG == false){
        mergersG = true;
    }
    else{
        mergersG = false;
    }
    console.log(mergersG);
}

function setsmovesG(){
    if (movesG == false){
        movesG = true;
    }
    else{
        movesG = false;
    }
    console.log(movesG);
}

function setsrenamesG(){
    if (renamesG == false){
        renamesG = true;
    }
    else{
        renamesG = false;
    }
    console.log(renamesG);
}

function setsexclusionsG(){
    if (exclusionsG == false){
        exclusionsG = true;
    }
    else{
        exclusionsG = false;
    }
    console.log(exclusionsG);
}

function setnewsG(){
    if (newsG == false){
        newsG = true;
    }
    else{
        newsG = false;
    }
    console.log(newsG);
}

function setconguencyG(){
    if (conguencyG == false){
        conguencyG = true;
    }
    else{
        conguencyG = false;
    }
    console.log(conguencyG);
}

function setAllG(){
    if (allG == false){
        splitsG = true;
        mergersG = true;
        renamesG = true;
        movesG = true;
        exclusionsG = true;
        newsG = true;
        conguencyG = true;
        allG = true;
        splits = false;
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
        splitsG = false;
        mergersG = false;
        renamesG = false;
        movesG = false;
        exclusionsG = false;
        newsG = false;
        conguencyG = false;
        document.getElementById("Congruencia").checked = false;
        document.getElementById("Splits").checked = false;
        document.getElementById("Mergers").checked = false;
        document.getElementById("Moves").checked = false;
        document.getElementById("Renames").checked = false;
        document.getElementById("News").checked = false;
        document.getElementById("Exclusions").checked = false;
    }
}
function Clear(){
    finish = true;
    var processingInstance;
    processingInstance = Processing.getInstanceById('CANVAS');
    document.getElementById("SplitsStatsValue").innerHTML = 0;
    document.getElementById("MergesStatsValue").innerHTML = 0;
    document.getElementById("MovesStatsValue").innerHTML = 0;
    document.getElementById("RenamesStatsValue").innerHTML = 0;
    document.getElementById("ExclusionStatsValue").innerHTML = 0;
    document.getElementById("NewStatsValue").innerHTML = 0;
    document.getElementById("CongruenceStatsValue").innerHTML = 0;
    clearG = true;
    processingInstance.setup();
    processingInstance.setValueOneByOne(false);
    allG = true;
    setAllG();
    document.getElementById("All").checked = false;
    document.getElementById('Slider').checked = "0";
    //valueSlider = document.getElementById('Slider').value;
    var processingInstance;
    processingInstance = Processing.getInstanceById('CANVAS');
    document.getElementById('Comenzar').style.backgroundImage = "url('play.png')";
    valueSlider = 0;
    var processingInstance;
    processingInstance = Processing.getInstanceById('CANVAS');
    console.log("Valor "+valueSlider);
    processingInstance.setValueSlider(valueSlider);
    document.getElementById("Reset").checked = false;
    iniciadoProceso = false;
    iniciado = false;
    document.getElementById("OneByOne").checked = false;
}

var vel = 0;
function IniciarAnimacion(){
    if (iniciadoProceso == false){
        var processingInstance;
        processingInstance = Processing.getInstanceById('CANVAS');
        processingInstance.beginAnimation();
        iniciadoProceso = true;
    }
    else{
         var processingInstance;
         processingInstance = Processing.getInstanceById('CANVAS');
         processingInstance.StopAnimation();
         iniciadoProceso = false;
    }
    if (iniciado == false){
        showVal(vel);
        iniciado = true;
        document.getElementById('Comenzar').style.backgroundImage = "url('stop.png')";
    }
    else{
        document.getElementById('Comenzar').style.backgroundImage = "url('play.png')";
        valueSlider = 0;
        var processingInstance;
        processingInstance = Processing.getInstanceById('CANVAS');
        processingInstance.setValueSlider(valueSlider);
        iniciado = false;
        
    } 

    Estadisticas(); 
}

function showVal(x){
    vel = x;
    valueSlider = document.getElementById('Slider').value;
    var processingInstance;
    processingInstance = Processing.getInstanceById('CANVAS');
    processingInstance.setValueSlider(valueSlider);
}


$(window).resize(function() {
    window.location.href = window.location.href;
});

availableWidth = $(window).width(); //size of the width of the screen
availableHeight = $(window).height();


d3.json("Archivos-Datos/"+"datos1.json", function (err, data) {
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


d3.json("Archivos-Datos/"+"datos2.json", function (err, data) {
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
});

 

//Metodos para obtener las estadisticas
function Estadisticas(){
    var processingInstance;
    processingInstance = Processing.getInstanceById('CANVAS');
    cantidadMoves = processingInstance.returnCantidadMoves();
    cantidadRename = processingInstance.returnCantidadRenames();
    cantidadSplits = processingInstance.returnCantidadSplits();
    cantidadMergers = processingInstance.returnCantidadMerges();
    cantidadNuevos = processingInstance.returnCantidadNews();
    cantidadEclusiones = processingInstance.returnCantidadExclusiones(); 
    cantidadCongruentes = processingInstance.RetornarCantidadCongruentes();          
    document.getElementById("SplitsStatsValue").innerHTML = cantidadSplits;
    document.getElementById("MergesStatsValue").innerHTML = cantidadMergers;
    document.getElementById("MovesStatsValue").innerHTML = cantidadMoves;
    document.getElementById("RenamesStatsValue").innerHTML = cantidadRename;
    document.getElementById("ExclusionStatsValue").innerHTML = cantidadEclusiones;
    document.getElementById("NewStatsValue").innerHTML = cantidadNuevos;
    document.getElementById("CongruenceStatsValue").innerHTML = cantidadCongruentes;
}


function setOneByOne(){
 if (onebyone == false){
        onebyone = true;
        var processingInstance;
        processingInstance = Processing.getInstanceById('CANVAS');
        processingInstance.setValueOneByOne(true);
    }
    else{
        onebyone = false;
        var processingInstance;
        processingInstance = Processing.getInstanceById('CANVAS');
        processingInstance.setValueOneByOne(false);
    }
}

var finish = true;
function demonio(){
    //console.log("Se ejecuta");
    var processingInstance;
    processingInstance = Processing.getInstanceById('CANVAS');
    var terminado = processingInstance.returnTerminado();
    if (terminado == true){
        if (finish == true){
             console.log(finish);
             finish = false;
             window.setTimeout(demonio, 3000);
        }
        else{
            Clear();
            //console.log("3 seg");
            window.setTimeout(demonio, 3000);
            processingInstance.setTerminado(false);
        }
    }
    else{
        //console.log("1 seg");
        window.setTimeout(demonio, 1000);
    }
}

window.setTimeout(demonio, 1000);
