
var nodesLeft = []; //Global variable to the left nodes
var nodesRight = [];//Global variable to the right nodes
var availableWidth;
var availableHeight;
var valueSlider=0;
var iniciado = false;
var iniciadoProceso = false;

//Check variables 
//If one variable is true execute the task
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
var file1 = "";
var file2 = "";

//Save the statistics
//Now the statistics are hidden.
var cantidadSplits;
var cantidadMergers;
var cantidadRename;
var cantidadMoves;
var cantidadEclusiones;
var cantidadNuevos;
var cantidadCongruentes;


//Load the last state of the page, sliders that are on en the taxonomies.
//Using session Storage (Browser).
function CargaBitacora(){
    setTimeout(function() {
        loadFiles('AmphibiaTest1.json','AmphibiaTest4.json');
         /*if (window.sessionStorage.getItem('File1_A') != null && window.sessionStorage.getItem('File2_A') != null){
           loadFiles (window.sessionStorage.getItem('File1_A'), window.sessionStorage.getItem('File2_A'));
        }*/
         setTimeout(function() {
            if (window.sessionStorage.getItem('All_A') == "true"  || (window.sessionStorage.getItem('Congruencia_A') == "true"
                && (window.sessionStorage.getItem('Splits_A') == "true")
                && (window.sessionStorage.getItem('Merges_A') == "true")
                && (window.sessionStorage.getItem('Nuevos_A') == "true")
                && (window.sessionStorage.getItem('Moves_A') == "true")
                && (window.sessionStorage.getItem('Renames_A') == "true")
                && (window.sessionStorage.getItem('Exclusions_A') == "true"))
                )
                {
                     document.getElementById("All").checked = true;
                     setAllG();
                }
            else{
                if (window.sessionStorage.getItem('Congruencia_A') == "true" ){
                     document.getElementById("Congruencia").checked = true;
                     setconguencyG();
                }
                 if (window.sessionStorage.getItem('Splits_A') == "true" ){
                     document.getElementById("Splits").checked = true;
                     setsplitsG();
                }
                if (window.sessionStorage.getItem('Merges_A') == "true" ){
                     document.getElementById("Mergers").checked = true;
                     setsmergersG();
                }
                if (window.sessionStorage.getItem('Nuevos_A') == "true" ){
                     document.getElementById("News").checked = true;
                     setnewsG();
                }
                if (window.sessionStorage.getItem('Moves_A') == "true" ){
                     document.getElementById("Moves").checked = true;
                     setsmovesG();
                }
                if (window.sessionStorage.getItem('Renames_A') == "true" ){
                     document.getElementById("Renames").checked = true;
                     setsrenamesG();
                }
                if (window.sessionStorage.getItem('Exclusions_A') == "true" ){
                     document.getElementById("Exclusions").checked = true;
                     setsexclusionsG();
                }
            }
            
        }, 1000);
    },1000);
}

//When the page is loaded o reloaded the pague need to be cleaned
$(window).bind("load", function() {
    LimpiarCanvas();
});

//Clean the window, lines and sliders
function LimpiarCanvas(){
    splits = false;
    moves = false;
    renames = false;
    exclusions = false;
    merges = false;
    congruencia= false;
    nuevos = false;
    document.getElementById("Splits").checked = false;
    document.getElementById("News").checked = false;
    document.getElementById("Congruencia").checked = false;    
    document.getElementById("Mergers").checked = false;
    document.getElementById("Moves").checked = false;
    document.getElementById("Renames").checked = false;
    document.getElementById("Exclusions").checked = false;
    document.getElementById("All").checked = false;
}

//This function is called to save the state of the session storage of splits.
function setsplitsG(){
    if (splitsG == false){
        splitsG = true;
        window.sessionStorage.setItem("Splits_A", true);
    }
    else{
        splitsG = false;
        window.sessionStorage.setItem("Splits_A", false);
    }
    console.log(splitsG);
}

//This function is called to save the state of the session storage of merges.
function setsmergersG(){
    if (mergersG == false){
        mergersG = true;
        window.sessionStorage.setItem("Merges_A", true);
    }
    else{
        mergersG = false;
        window.sessionStorage.setItem("Merges_A", false);
    }
    console.log(mergersG);
}

//This function is called to save the state of the session storage of moves.
function setsmovesG(){
    if (movesG == false){
        movesG = true;
        window.sessionStorage.setItem("Moves_A", true);
    }
    else{
        movesG = false;
        window.sessionStorage.setItem("Moves_A", false);
    }
    console.log(movesG);
}

//This function is called to save the state of the session storage of renames.
function setsrenamesG(){
    if (renamesG == false){
        renamesG = true;
        window.sessionStorage.setItem("Renames_A", true);
    }
    else{
        renamesG = false;
        window.sessionStorage.setItem("Renames_A", false);
    }
    console.log(renamesG);
}

//This function is called to save the state of the session storage of exclusions.
function setsexclusionsG(){
    if (exclusionsG == false){
        exclusionsG = true;
        window.sessionStorage.setItem("Exclusions_A", true);
    }
    else{
        exclusionsG = false;
        window.sessionStorage.setItem("Exclusions_A", false);
    }
    console.log(exclusionsG);
}

//This function is called to save the state of the session storage of news.
function setnewsG(){
    if (newsG == false){
        newsG = true;
        window.sessionStorage.setItem("Nuevos_A", true);
    }
    else{
        newsG = false;
        window.sessionStorage.setItem("Nuevos_A", false);
    }
    console.log(newsG);
}

//This function is called to save the state of the session storage of congruency.
function setconguencyG(){
    if (conguencyG == false){
        conguencyG = true;
        window.sessionStorage.setItem("Congruencia_A", true);
    }
    else{
        conguencyG = false;
        window.sessionStorage.setItem("Congruencia_A", false);
    }
    console.log(conguencyG);
}

//This function is called to save the state of the session storage of all tasks.
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
        window.sessionStorage.setItem("All_A", true);
        window.sessionStorage.setItem("Congruencia_A", true);
        window.sessionStorage.setItem("Nuevos_A", true);
        window.sessionStorage.setItem("Exclusions_A", true);
        window.sessionStorage.setItem("Renames_A", true);
        window.sessionStorage.setItem("Moves_A", true);
        window.sessionStorage.setItem("Merges_A", true);
        window.sessionStorage.setItem("Splits_A", true);
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
        window.sessionStorage.setItem("All_A", false);
        window.sessionStorage.setItem("Congruencia_A", false);
        window.sessionStorage.setItem("Nuevos_A", false);
        window.sessionStorage.setItem("Exclusions_A", false);
        window.sessionStorage.setItem("Renames_A", false);
        window.sessionStorage.setItem("Moves_A", false);
        window.sessionStorage.setItem("Merges_A", false);
        window.sessionStorage.setItem("Splits_A", false);
    }
}

//Reset the window to the deafult values and configuration
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

//This function is executed to start the animation
var vel = 0;
function IniciarAnimacion(){
    if (iniciadoProceso == false){
        console.log("Entra");
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
        document.getElementById('Comenzar').style.backgroundImage = "url('Pause.png')";
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

//To change the image of the buttom to default.
function resetPlayButtom(){
    document.getElementById('Comenzar').style.backgroundImage = "url('play.png')";
    valueSlider = 0;
    var processingInstance;
    processingInstance = Processing.getInstanceById('CANVAS');
    processingInstance.setValueSlider(valueSlider);
    iniciado = false;
    iniciadoProceso = false;
}

//Get the value velocity of the sider
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

//Load the files from the JSON and store in the arrays
function loadFiles (file1, file2){
    var processingInstance;
    processingInstance = Processing.getInstanceById('CANVAS');
    
    d3.json("Archivos-Datos/"+file1, function (err, data) {
        var Ltree = d3.layout.treelist()
            .childIndent(15)
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
            .childIndent(15)
            .nodeHeight(20);

        var ul = d3.select("#leftSide").append("ul").classed("treelist", "true");
        function render(data, parent) {
                var nodes = Ltree.nodes(data),
                duration = 1000;
                nodesRight = nodes;
            }
            render(data, data);
        try{
            if (nodesLeft.length > 0 && nodesRight.length > 0){
                processingInstance.setup();
                var archivo1 = file1.replace(".json", "");
                var archivo2 = file2.replace(".json", "");
               
                processingInstance.setNames(archivo1,archivo2);
            }
            else{
                loadFiles(file1,file2);
            }   
        }
        catch(e){
            loadFiles(file1,file2);
        }
         
    });
    window.sessionStorage.setItem("File1_A", file1);
    window.sessionStorage.setItem("File2_A", file2);
}

 

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

//Set the one by one slider
function setOneByOne(){
    if (document.getElementById("OneByOne").checked == true){
        onebyone = true;
        var processingInstance;
        processingInstance = Processing.getInstanceById('CANVAS');
        processingInstance.setValueOneByOne(true);
        document.getElementById("OneByOne").checked = true;
    }
    else{
        onebyone = false;
        var processingInstance;
        processingInstance = Processing.getInstanceById('CANVAS');
        processingInstance.setValueOneByOne(false);
        document.getElementById("OneByOne").checked = false;
    }
}

//Now is not used, but can be used to mantain clean the animation when is finish
//Clean at the end.
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
            
            processingInstance.setTerminado(false);
        }
    }
    else{
        //console.log("1 seg");
        window.setTimeout(demonio, 1000);
    }
}


//Function if the loade page need to be used
//Call this function from the HTML.
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



//This functions is activated when page is full loaded.
$(window).bind("load", function() {
    CargaBitacora(); //Call the function that load the latest state of the page.
});
