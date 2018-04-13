
//START THE SECTION OF FUNCTIONS FOR THE RADIO BUTTONS
//THE EXTRA FUNCTIONS THAT APEAR IN THE CODE ARE PLACED IN funciones_auxiliares.js

//Function to call processing function that paint the lines in the screen
//the lines are painted from right to left
function CargarLineasIzquierdas(){
    var processingInstance;
    processingInstance = Processing.getInstanceById('CANVAS');
     if (encendido){
         LimpiarCanvas();
         encendido = false;
    }
    if (document.getElementById("Congruencia").checked){
        congruencia = true;
        processingInstance.drawCongruency(); 
        cantidadCongruentes = 0;
        var izquierda = processingInstance.retornarIzquierdosConguencia();
        var derecha = processingInstance.retornarDerechosConguencia();
        for (var i = 0; i < nodesLeft.length; i++){
            for (var j = 0; j < izquierda.length; j++){
                if (nodesLeft[i].name == izquierda[j].nodo.name){
                    if (izquierda[j].color == "Azul"){
                        document.getElementById(nodesLeft[i].name+"1").style.color = "#1712C4";
                    }
                }
            }
        }
        for (var i = 0; i < nodesRight.length; i++){
            for (var j = 0; j < derecha.length; j++){
                if (nodesRight[i].name == derecha[j].nodo.name){
                    if (derecha[j].color == "Azul"){
                        document.getElementById(nodesRight[i].name+"2").style.color = "#1712C4";
                         cantidadCongruentes += 1;
                    }
                }
            }
        }
         window.sessionStorage.setItem("Congruencia", true);
         document.getElementById("CongruenceStatsValue").innerHTML = cantidadCongruentes;
    }
    else{
        congruencia = false;
        for (var node1 = 0; node1 < nodesLeft.length; node1++){
            document.getElementById(nodesLeft[node1].name+"1").style.color ="black";
        }
        for (var node1 = 0; node1 < nodesRight.length; node1++){
            document.getElementById(nodesRight[node1].name+"2").style.color ="black";
        }
        processingInstance.setup();
        document.getElementById("CongruenceStatsValue").innerHTML = 0;
        VerificarChecks();
        window.sessionStorage.setItem("Congruencia", false);
    }
    
   
}

//It is a function to celan up the screen
//Clean the color of the nodes and the lines that exist in the canvas

//Funcion para quitar las lineas de la pantalla
//Limpia tanto el color de los nodos asi como todas las lineas que existan en el canvas
function LimpiarCanvas(){
    var processingInstance;
    processingInstance = Processing.getInstanceById('CANVAS');
    for (var node1 = 0; node1 < nodesLeft.length; node1++){
        document.getElementById(nodesLeft[node1].name+"1").style.color ="black";
    }
    for (var node1 = 0; node1 < nodesRight.length; node1++){
        document.getElementById(nodesRight[node1].name+"2").style.color ="black";
    }
    processingInstance.setup();
    splits = false;
    moves = false;
    renames = false;
    exclusions = false;
    merges = false;
    congruencia= false;
    nuevos = false;
    resetText();
    document.getElementById("Splits").checked = false;
    document.getElementById("News").checked = false;
    document.getElementById("Congruencia").checked = false;    
    document.getElementById("Mergers").checked = false;
    document.getElementById("Moves").checked = false;
    document.getElementById("Renames").checked = false;
    document.getElementById("Exclusions").checked = false;
    document.getElementById("All").checked = false;
}

//A function to paint the new nodes
//This function search nodes in the right taxonomy that not exist in the left taxonomy
function pintarNuevos(){
    if (encendido){
         LimpiarCanvas();
         encendido = false;
    }
    var processingInstance;
    processingInstance = Processing.getInstanceById('CANVAS');
    cantidadNuevos = 0;
    if (document.getElementById("News").checked){
        nuevos = true;
        for (var nodeR = 1; nodeR < nodesRight.length; nodeR++){
            if (processingInstance.existeNombreNuevos(nodesRight[nodeR].name,nodesRight[nodeR].author) == true){
                var sinonimos = nodesRight[nodeR].Synonym;
                if (sinonimos.length == 0){
                    cantidadNuevos = cantidadNuevos+1;// it is a variable to save the amount of new nodes that exist
                    arregloNuevos.push(nodesRight[nodeR]);
                    document.getElementById(nodesRight[nodeR].name+"2").style.color ="#088A00";
                }
                else{ //enter if exist Synonyms
                    var flag = false;
                    for (i=0;i<sinonimos.length;i++){
                        if (processingInstance.existeNombre(sinonimos[i])){//verify if exist a Synonym in the left taxonomy
                            flag = false;
                        }      
                        else{
                            flag = true;
                            break;
                        }
                    }
                    if (flag == false){
                        cantidadNuevos = cantidadNuevos+1;//variable to save de amount of new nodes that exist
                        arregloNuevos.push(nodesRight[nodeR]);
                        document.getElementById(nodesRight[nodeR].name+"2").style.color ="#088A00";
                    }
                }
                
            }
        }
        document.getElementById("NewStatsValue").innerHTML = cantidadNuevos;
         window.sessionStorage.setItem("Nuevos", true);
    }
    else{
        nuevos = false;
        //the first two are to clean the any node that is painted
        for (var node1 = 0; node1 < nodesLeft.length; node1++){
            document.getElementById(nodesLeft[node1].name+"1").style.color ="black";
        }
        for (var node1 = 0; node1 < nodesRight.length; node1++){
            document.getElementById(nodesRight[node1].name+"2").style.color ="black";
        }
        d3.select("#Canvas").selectAll("*").remove();
        document.getElementById("NewStatsValue").innerHTML = 0;
        VerificarChecks();
        window.sessionStorage.setItem("Nuevos", false);
    }
    
}

//This function is to paint the splits that exist in the taxonomy
//First we clean up both taxonomies with de for
//Then ckeck each node of the left taxonomy and search the name of this node in the Synonyms of the right taxonomy 
//A split exist if two or more nodes in the right taxonomy have as Synonym the name of the left node
function pintarSplits(){
    if (encendido){
         LimpiarCanvas();
         encendido = false;
    }
    var processingInstance;
    processingInstance = Processing.getInstanceById('CANVAS');
    splits = true;
    if (document.getElementById("Splits").checked){
        processingInstance.drawSplits(-1,""); //Aqui mando el ancho de la linea
        var arregloIzquierdos =  processingInstance.returnSplitsLeft();
        var arregloDerechos =  processingInstance.returnSplitsRight();
        cantidadSplits = processingInstance.returnAmountSplits();
        for (var i = 0; i< arregloIzquierdos.length;i++){
            document.getElementById(arregloIzquierdos[i].name+"1").style.color ="#FF00BF";
        }
        for (var j=0;j<arregloDerechos.length;j++){
            document.getElementById(arregloDerechos[j].name+"2").style.color ="#FF00BF";
        }
         document.getElementById("SplitsStatsValue").innerHTML = cantidadSplits;
         window.sessionStorage.setItem("Splits", true);
    }
    else{
        splits = false;
         for (var node1 = 0; node1 < nodesLeft.length; node1++){
            document.getElementById(nodesLeft[node1].name+"1").style.color ="black";
        }
        for (var node1 = 0; node1 < nodesRight.length; node1++){
            document.getElementById(nodesRight[node1].name+"2").style.color ="black";
        }
        processingInstance.setup();
        document.getElementById("SplitsStatsValue").innerHTML = 0;
        VerificarChecks();
        window.sessionStorage.setItem("Splits", false);
    }  
}

//This function is to get the mergers
//We check if the name of the Synonym in the left taxonomy exist as name of a node in the right taxonomy
function merge(){
    if (encendido){
         LimpiarCanvas();
         encendido = false;
    }
    cantidadMergers = 0;
    var processingInstance;
    processingInstance = Processing.getInstanceById('CANVAS');
    merges = true;
    if (document.getElementById("Mergers").checked){
        processingInstance.merge("",0.75);
        var izquierdos = processingInstance.returnIzquierdosMerge();
        cantidadMergers = processingInstance.returnCantidadMergers();
        var derechos = processingInstance.returnDerechosMerge();
        for (var i = 0; i < izquierdos.length;i++){
            document.getElementById(izquierdos[i].name+"1").style.color ="#FF9100";
        }
        for (var i = 0; i < derechos.length;i++){
            document.getElementById(derechos[i].name+"2").style.color ="#FF9100";
        }
        document.getElementById("MergesStatsValue").innerHTML = cantidadMergers;
         window.sessionStorage.setItem("Merges", true);
    }
    else{
        merges = false;
        for (var node1 = 0; node1 < nodesLeft.length; node1++){
            document.getElementById(nodesLeft[node1].name+"1").style.color ="black";
        }
        for (var node1 = 0; node1 < nodesRight.length; node1++){
            document.getElementById(nodesRight[node1].name+"2").style.color ="black";
        }
        processingInstance.setup();
        document.getElementById("MergesStatsValue").innerHTML = 0;
        VerificarChecks();
        window.sessionStorage.setItem("Merges", false);
    }
}

//This is the principal function of move that call the radio Buttun
//Call the processing function  drawMoves with the flag with the value of false and the RGB colors
//Call with false beacause the  Rename_Move  algoritm is used to move and rename functions, so the flag y to identify the disctincts algoritms
//The move and rename function are different beacuase in the rename the parent are the same and in the move are different
function Move(){
    if (encendido){
         LimpiarCanvas();
         encendido = false;
    }
    var processingInstance;
    processingInstance = Processing.getInstanceById('CANVAS');
    cantidadMoves = 0;
    moves = true;
    if (document.getElementById("Moves").checked){
        processingInstance.drawMoves(false,10,228,237,"");
        var izquierdos = processingInstance.returnRename_MovesLeft();
        var derechos = processingInstance.returnRename_MovesRight();
        cantidadMoves = processingInstance.returnMoves();
        for (var i = 0; i < izquierdos.length;i++){
            document.getElementById(izquierdos[i].name+"1").style.color ="#0AE4ED";
            document.getElementById(derechos[i].name+"2").style.color ="#0AE4ED";
        }
        document.getElementById("MovesStatsValue").innerHTML = cantidadMoves;
        window.sessionStorage.setItem("Moves", true);
    }
    else{
        moves = false;
        //we Clean up the nodes with black color
        for (var node1 = 0; node1 < nodesLeft.length; node1++){
            document.getElementById(nodesLeft[node1].name+"1").style.color ="black";
        }
        for (var node1 = 0; node1 < nodesRight.length; node1++){
            document.getElementById(nodesRight[node1].name+"2").style.color ="black";
        }
        //We clean up the canvas and the lines
        processingInstance.setup();
        document.getElementById("MovesStatsValue").innerHTML = 0;
        VerificarChecks();
        window.sessionStorage.setItem("Moves", false);
    }
    
}

//This is the principal rename function that the radio button call
//This functions works as the move function but call the processing function with the flag with true value and RGB colors
function Rename(){
    if (encendido){
         LimpiarCanvas();
         encendido = false;
    }
    cantidadRename = 0;
    var processingInstance;
    renames = true;
    processingInstance = Processing.getInstanceById('CANVAS');
    if (document.getElementById("Renames").checked){
        processingInstance.drawMoves(true,91,255,142,"");
        var izquierdos = processingInstance.returnRename_MovesLeft();
        var derechos = processingInstance.returnRename_MovesRight();
        cantidadRename = processingInstance.returnRenames();
        for (var i = 0; i < izquierdos.length;i++){
            document.getElementById(izquierdos[i].name+"1").style.color ="#5BFF8E";
            document.getElementById(derechos[i].name+"2").style.color ="#5BFF8E";
        }
        document.getElementById("RenamesStatsValue").innerHTML = cantidadRename;
        window.sessionStorage.setItem("Renames", true);
    }
    else{
        //we Clean up the nodes with black color
        for (var node1 = 0; node1 < nodesLeft.length; node1++){
            document.getElementById(nodesLeft[node1].name+"1").style.color ="black";
        }
        for (var node1 = 0; node1 < nodesRight.length; node1++){
            document.getElementById(nodesRight[node1].name+"2").style.color ="black";
        }
        //We clean up the canvas and the lines
        processingInstance.setup();
        document.getElementById("RenamesStatsValue").innerHTML = 0;
        VerificarChecks();
        window.sessionStorage.setItem("Renames", false);
    }  
}

//This function is to search the excluded nodes
//First we clean up the screen, lines and nodes
//Check one by one the nodes of the left taxonomy
//use the existeNombreDerecha function to check if exist the name of if exist in the synonyms
//if not exist we paint the nodes
function exclusiones(){
    if (encendido){
         LimpiarCanvas();
         encendido = false;
    }
    cantidadEclusiones = 0;
    if (document.getElementById("Exclusions").checked){
        exclusions = true;
        for (node = 1;node < nodesLeft.length;node++){
            if (existeNombreDerecha(nodesLeft[node].name,nodesLeft[node].author,nodesLeft[node].record_scrutiny_date) == true){
                cantidadEclusiones = cantidadEclusiones+1;
                arregloEclusiones.push(nodesLeft[node]);
                document.getElementById(nodesLeft[node].name+"1").style.color = "#DF0101";
            }
        }
        document.getElementById("ExclusionStatsValue").innerHTML = cantidadEclusiones;
        window.sessionStorage.setItem("Exclusions", true);
    }
    else{
        exclusions = false;
         for (var node1 = 0; node1 < nodesLeft.length; node1++){
            document.getElementById(nodesLeft[node1].name+"1").style.color ="black";
        }
        for (var node1 = 0; node1 < nodesRight.length; node1++){
            document.getElementById(nodesRight[node1].name+"2").style.color ="black";
        }
        d3.select("#Canvas").selectAll("*").remove();
         document.getElementById("ExclusionStatsValue").innerHTML = 0;
        VerificarChecks();
        window.sessionStorage.setItem("Exclusions", false);
    }
}

//Function to show all the functionalities
function mostrarTodos(){
    if (encendido){
         LimpiarCanvas();
         encendido = false;
    }
    if (document.getElementById("All").checked){
        document.getElementById("Congruencia").checked = true;
        CargarLineasIzquierdas();
        document.getElementById("Splits").checked = true;
        pintarSplits();
        document.getElementById("News").checked = true;
        pintarNuevos();
        document.getElementById("Moves").checked = true;
        Move();
        document.getElementById("Mergers").checked = true;
        merge();
        document.getElementById("Exclusions").checked = true;
        exclusiones();
        document.getElementById("Renames").checked = true;
        Rename();
        window.sessionStorage.setItem("All", true);
        window.sessionStorage.setItem("Congruencia", true);
        window.sessionStorage.setItem("Nuevos", true);
        window.sessionStorage.setItem("Exclusions", true);
        window.sessionStorage.setItem("Renames", true);
        window.sessionStorage.setItem("Moves", true);
        window.sessionStorage.setItem("Merges", true);
        window.sessionStorage.setItem("Splits", true);
    }
    else{
        LimpiarCanvas();
        document.getElementById("SplitsStatsValue").innerHTML = "0";
        document.getElementById("MergesStatsValue").innerHTML = "0";
        document.getElementById("MovesStatsValue").innerHTML = "0";
        document.getElementById("RenamesStatsValue").innerHTML = "0";
        document.getElementById("ExclusionStatsValue").innerHTML = "0";
        document.getElementById("NewStatsValue").innerHTML = "0"; 
        document.getElementById("CongruenceStatsValue").innerHTML = "0";
        window.sessionStorage.setItem("All", false);
        window.sessionStorage.setItem("Exclusions", false);
        window.sessionStorage.setItem("Moves", false);
        window.sessionStorage.setItem("Renames", false);
        window.sessionStorage.setItem("Congruencia", false);
        window.sessionStorage.setItem("Nuevos", false);
        window.sessionStorage.setItem("Splits", false);
        window.sessionStorage.setItem("Merges", false);
    }
   
}

//Function to show all the statistics
function Estadisticas(){
    if (document.getElementById("Stats").checked){                
        document.getElementById("SplitsStatsValue").innerHTML = cantidadSplits;
        document.getElementById("MergesStatsValue").innerHTML = cantidadMergers;
        document.getElementById("MovesStatsValue").innerHTML = cantidadMoves;
        document.getElementById("RenamesStatsValue").innerHTML = cantidadRename;
        document.getElementById("ExclusionStatsValue").innerHTML = cantidadEclusiones;
        document.getElementById("NewStatsValue").innerHTML = cantidadNuevos;
    }
    else{
        //LimpiarCanvas();//Verificar q sea lo correcto
        document.getElementById("SplitsStatsValue").innerHTML = "0";
        document.getElementById("MergesStatsValue").innerHTML = "0";
        document.getElementById("MovesStatsValue").innerHTML = "0";
        document.getElementById("RenamesStatsValue").innerHTML = "0";
        document.getElementById("ExclusionStatsValue").innerHTML = "0";
        document.getElementById("NewStatsValue").innerHTML = "0"; 
    }
    
}