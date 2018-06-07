
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


//Load the last state of the page, sliders, etc
function CargaBitacora(){ 
     setTimeout(function(){
            loadFiles('AmphibiaTest1.json','AmphibiaTest5.json');
            /*if (window.sessionStorage.getItem('File1_Ag') != null && window.sessionStorage.getItem('File2_Ag') != null){
               loadFiles (window.sessionStorage.getItem('File1_Ag'), window.sessionStorage.getItem('File2_Ag'));
            }*/
            setTimeout(function() {
                if (window.sessionStorage.getItem('All_Ag') == "true"  || (window.sessionStorage.getItem('Congruencia_Ag') == "true"
                    && (window.sessionStorage.getItem('Splits_Ag') == "true")
                    && (window.sessionStorage.getItem('Merges_Ag') == "true")
                    && (window.sessionStorage.getItem('Nuevos_Ag') == "true")
                    && (window.sessionStorage.getItem('Moves_Ag') == "true")
                    && (window.sessionStorage.getItem('Renames_Ag') == "true")
                    && (window.sessionStorage.getItem('Exclusions_Ag') == "true"))
                    )
                    {
                         document.getElementById("All").checked = true;
                         allG= false;
                         setAllG();
                    }
                else{
                    if (window.sessionStorage.getItem('Congruencia_Ag') == "true" ){
                         document.getElementById("Congruencia").checked = true;
                         setconguencyG();
                    }
                     if (window.sessionStorage.getItem('Splits_Ag') == "true" ){
                         document.getElementById("Splits").checked = true;
                         setsplitsG();
                    }
                    if (window.sessionStorage.getItem('Merges_Ag') == "true" ){
                         document.getElementById("Mergers").checked = true;
                         setsmergersG();
                    }
                    if (window.sessionStorage.getItem('Nuevos_Ag') == "true" ){
                         document.getElementById("News").checked = true;
                         setnewsG();
                    }
                    if (window.sessionStorage.getItem('Moves_Ag') == "true" ){
                         document.getElementById("Moves").checked = true;
                         setsmovesG();
                    }
                    if (window.sessionStorage.getItem('Renames_Ag') == "true" ){
                         document.getElementById("Renames").checked = true;
                         setsrenamesG();
                    }
                    if (window.sessionStorage.getItem('Exclusions_Ag') == "true" ){
                         document.getElementById("Exclusions").checked = true;
                         setsexclusionsG();
                    }
                }
                
            }, 1000);
     },1000);
}

//Call splits function in processing to draw
function setsplitsG(){
     var processingInstance;
    processingInstance = Processing.getInstanceById('CANVAS');
    if (splitsG == false){
        splitsG = true;
        var  cantidadSplits = processingInstance.returnAmountSplits(); 
        document.getElementById("SplitsStatsValue").innerHTML = cantidadSplits;
        window.sessionStorage.setItem("Splits_Ag", true);      
    }
    else{
        splitsG = false;
        document.getElementById("SplitsStatsValue").innerHTML = "0";
        window.sessionStorage.setItem("Splits_Ag", false); 
    }
}

//Call merges function in processing to draw
function setsmergersG(){
     var processingInstance;
    processingInstance = Processing.getInstanceById('CANVAS');
    if (mergersG == false){
        mergersG = true;
        var cantidadMergers = processingInstance.returnCantidadMergers();
        document.getElementById("MergesStatsValue").innerHTML = cantidadMergers;
        window.sessionStorage.setItem("Merges_Ag", true);   
    }
    else{
        mergersG = false;
        document.getElementById("MergesStatsValue").innerHTML = "0";
        window.sessionStorage.setItem("Merges_Ag", false);
    }
}

//Call moves function in processing to draw
function setsmovesG(){
     var processingInstance;
    processingInstance = Processing.getInstanceById('CANVAS');
    if (movesG == false){
        movesG = true;
        var cantidadMoves = processingInstance.returnMoves();   
        document.getElementById("MovesStatsValue").innerHTML = cantidadMoves;
        window.sessionStorage.setItem("Moves_Ag", true);     
    }
    else{
        movesG = false;
        document.getElementById("MovesStatsValue").innerHTML = "0";
        window.sessionStorage.setItem("Moves_Ag", false);  
    }
}

//Call renames function in processing to draw
function setsrenamesG(){
     var processingInstance;
    processingInstance = Processing.getInstanceById('CANVAS');
    if (renamesG == false){
        renamesG = true;
        var cantidadRename = processingInstance.returnRenames();  
        document.getElementById("RenamesStatsValue").innerHTML = cantidadRename;
        window.sessionStorage.setItem("Renames_Ag", true);  
    }
    else{
        renamesG = false;
        document.getElementById("RenamesStatsValue").innerHTML = "0";
        window.sessionStorage.setItem("Renames_Ag", false); 
    }
}

//Call exclusions function in processing to draw
function setsexclusionsG(){
    var processingInstance;
    processingInstance = Processing.getInstanceById('CANVAS');
    if (exclusionsG == false){
        exclusionsG = true;
        var cantidadExclusiones = processingInstance.returnExclusiones();
        document.getElementById("ExclusionStatsValue").innerHTML = cantidadExclusiones;
        window.sessionStorage.setItem("Exclusions_Ag", true);           
    }
    else{
        exclusionsG = false;
         document.getElementById("ExclusionStatsValue").innerHTML = "0";
         window.sessionStorage.setItem("Exclusions_Ag", false);  
    }
}

//Call news function in processing to draw
function setnewsG(){
    var processingInstance;
    processingInstance = Processing.getInstanceById('CANVAS');
    if (newsG == false){
        newsG = true;
        var cantidadNuevos = processingInstance.returnNuevos();
        document.getElementById("NewStatsValue").innerHTML = cantidadNuevos;
        window.sessionStorage.setItem("Nuevos_Ag", true);
    }
    else{
        newsG = false;
         document.getElementById("NewStatsValue").innerHTML = "0";
         window.sessionStorage.setItem("Nuevos_Ag", false);
    }
}

//Call congruence function in processing to draw
function setconguencyG(){
     var processingInstance;
    processingInstance = Processing.getInstanceById('CANVAS');
    if (conguencyG == false){
        console.log("Seee");
        conguencyG = true;
        processingInstance.Congruencia(); 
        var cantidadCongruentes = processingInstance.returnCongruentes(); 
        document.getElementById("CongruenceStatsValue").innerHTML = cantidadCongruentes;
        window.sessionStorage.setItem("Congruencia_Ag", true);
    }
    else{
        conguencyG = false;
        document.getElementById("CongruenceStatsValue").innerHTML = "0";
        window.sessionStorage.setItem("Congruencia_Ag", false);
    }
}

//Call all tasks function in processing to draw
function setAllG(){
    if (allG == false){
        conguencyG = false;
        newsG = false;
        exclusionsG = false;
        renamesG = false;
        movesG = false;
        mergersG = false;
        splitsG = false;
        console.log("Enciende");
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
        document.getElementById("All").checked = true;
        window.sessionStorage.setItem("All_Ag", true);
        window.sessionStorage.setItem("Congruencia_Ag", true);
        window.sessionStorage.setItem("Nuevos_Ag", true);
        window.sessionStorage.setItem("Exclusions_Ag", true);
        window.sessionStorage.setItem("Renames_Ag", true);
        window.sessionStorage.setItem("Moves_Ag", true);
        window.sessionStorage.setItem("Merges_Ag", true);
        window.sessionStorage.setItem("Splits_Ag", true);
    }
    else{
        console.log("Apaga");
        allG = false;
        conguencyG = true;
        newsG = true;
        exclusionsG = true;
        renamesG = true;
        movesG = true;
        mergersG = true;
        splitsG = true;
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
        document.getElementById("All").checked = false;
        window.sessionStorage.setItem("All_Ag", false);
        window.sessionStorage.setItem("Congruencia_Ag", false);
        window.sessionStorage.setItem("Nuevos_Ag", false);
        window.sessionStorage.setItem("Exclusions_Ag", false);
        window.sessionStorage.setItem("Renames_Ag", false);
        window.sessionStorage.setItem("Moves_Ag", false);
        window.sessionStorage.setItem("Merges_Ag", false);
        window.sessionStorage.setItem("Splits_Ag", false);
    }
}


$(window).resize(function() {
    window.location.href = window.location.href;
});

availableWidth = $(window).width(); //size of the width of the screen
availableHeight = $(window).height();

//Load the files and store in logic array
function loadFiles (file1, file2){
    var processingInstance;
    processingInstance = Processing.getInstanceById('CANVAS');
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
    window.sessionStorage.setItem("File1_Ag", file1);
    window.sessionStorage.setItem("File2_Ag", file2);
}

//Show the window that have all the files to load
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