function verficar_fecha(nodes,nombre, fecha){
    for (var node = 0; node < nodes.length; node++) {
            if (nodes[node].name == nombre && nodes[node].record_scrutiny_date == fecha){
                return true;
            }
        }
        return false;
}

//this is an auxliliar function of exclusiones() to check if a node
//exist en the right taxonomy or in the synonyms
//Make a loop in the right 
function existeNombreDerecha(nombre,author,date){
    for (var nodeR = 0; nodeR < nodesRight.length; nodeR++) {
        if(nodesRight[nodeR].name == nombre && nodesRight[nodeR].author == author && nodesRight[nodeR].record_scrutiny_date == date){
            return false;
        }
        else if (nodesRight[nodeR].name == nombre && nodesRight[nodeR].author == author){
            return false;
        }
        var sinonimos = nodesRight[nodeR].Synonym;
        for (var i = 0;i<sinonimos.length;i++){
            if (sinonimos[i] == nombre){
                return false;
            }
        }
    }
    return true;
}


//This functions is to check if the checks are activated 
function VerificarChecks(){
    resetText();
    if (document.getElementById("Splits").checked){
        pintarSplits();
    }
    if (document.getElementById("News").checked){
        pintarNuevos();
    }
    if (document.getElementById("Moves").checked){
        Move();
    }
    if (document.getElementById("Congruencia").checked){
        CargarLineasIzquierdas();
    }
    if (document.getElementById("Mergers").checked){
        merge();
    }
    if (document.getElementById("Exclusions").checked){
        exclusiones();
    }
    if (document.getElementById("Renames").checked){
        Rename();
    }
}

//This function is to get the position x of a node in the screen
//Receive the name of the author and the date of a node 
//and receive an array of the nodes that we need to search 
//Is required that the three atributes are equals
function getpostionX(nodes,nombre,author,date,flag){
    if (flag){
        console.log(author);
        for (var node = 0; node < nodes.length; node++) {
            if (nodes[node].name == nombre && nodes[node].author == author && nodes[node].record_scrutiny_date == date){
                return nodes[node].x -20;
            }
        } 
    }
    else{
         for (var node = 0; node < nodes.length; node++) {
            if (nodes[node].name == nombre && nodes[node].author == author){
                return nodes[node].x-20;
            }
        } 
    }
    
}

//This function is to get the position y of a node in the screen 
//Receive the name of the author and the date of a node 
//and receive an array of the nodes that we need to search 
//Is required that the three atributes are equals
function getpostionY(nodes,nombre,author,date,flag){
    if (flag){
         for (var node = 0; node < nodes.length; node++) {
            if (nodes[node].name == nombre && nodes[node].author == author && nodes[node].record_scrutiny_date == date){
                return nodes[node].y;
            }
        }
    }
    else{
         for (var node = 0; node < nodes.length; node++) {
            if (nodes[node].name == nombre && nodes[node].author == author){
                return nodes[node].y;
            }
        }
    }
   
}

//This function is to get the position x of a node in the screen 
//Receive the name of the author and the date of a node 
//and receive an array of the nodes that we need to search 
//Is not necesary that the atributes are equals is required only the name
function getpostionXSimple(nodes,nombre){
    for (var node = 0; node < nodes.length; node++) {
        if (nodes[node].name == nombre){
            return nodes[node].x -20;
        }
    } 
}

//This function is to get the position y of a node in the screen 
//Receive the name of the author and the date of a node 
//and receive an array of the nodes that we need to search 
//Is not necesary that the atributes are equals is required only the name
function getpostionYSimple(nodes,nombre){
    for (var node = 0; node < nodes.length; node++) {
        if (nodes[node].name == nombre){
            return nodes[node].y;
        }
    }
}


function existeNombre_Complejo_Nuevos(nombre, autor, fecha){
    for (var i = 0; i < nodesLeft.length; i++) {
        if (nodesLeft[i].name == nombre && nodesLeft[i].author == autor && nodesLeft[i].record_scrutiny_date == fecha){
            return false;
        }
    }
    return true;
}
var file1 = "";
var file2 = "";

function nuevaventana (){
    LimpiarCanvas();
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



