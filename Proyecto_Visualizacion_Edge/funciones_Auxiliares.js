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


//This function verify that a right node taxonomy exists on left taxonomy
//Check that author, name and date are equal
function existeNombre_Complejo_Nuevos(nombre, autor, fecha){
    for (var i = 0; i < nodesLeft.length; i++) {
        if (nodesLeft[i].name == nombre && nodesLeft[i].author == autor){
            return false;
        }
    }
    return true;
}

function existeNombre_Complejo_Izquierda(nombre, autor, fecha,sinonimos){
    for (var i = 0; i < nodesLeft.length; i++) {
        if (nodesLeft[i].name == nombre && nodesLeft[i].author == autor){
            return false;
        }
        for (var j = 0; j < sinonimos.length; j++){
            if (sinonimos[j] == nodesLeft[i].name){
                return false;
            }
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
       }    
    },1000); 
    //loadFiles("datos1.json","datos2.json");
}




//This function  save the parents names on de nombres_Left variable
//of the left taxonomy
var nombres_Left = [];
var nombres_Right = [];
function Save_Parents_Names_Left(Children){
    if (Children != undefined){
        for (var i = 0; i < Children.length; i++){
            if (Children[i].children != undefined){
                Save_Parents_Names_Left(Children[i].children);
                nombres_Left.push(Children[i].name);
            }
            else{
                nombres_Left.push(Children[i].name);
            }
        }
    }
    else{
        return [];
    }
}

//This function  save the parents names on de nombres_Right variable
//of the right taxonomy
function Save_Parents_Names_Right(Children){
    if (Children != undefined){
        for (var i = 0; i < Children.length; i++){
            if (Children[i].children != undefined){
                Save_Parents_Names_Right(Children[i].children);
                nombres_Right.push(Children[i].name);
            }
            else{
                nombres_Right.push(Children[i].name);
            }
        }
    }
    else{
        return [];
    }
}

//This function return de array with the parents names of left taxonomy 
// to loadFiles function that requires this data
function Retornar_Nommbres_Left(){
    return nombres_Left;
}

//This function return de array with the parents names of right taxonomy 
// to loadFiles function that requires this data
function Retornar_Nommbres_Right(){
    return nombres_Right;
}

function Quantity_Nodes(taxonomy){
    console.log(taxonomy.length);
    var level = 0;
    for (var i = 0; i < taxonomy.length; i++){
        contadorNivel = 1;
        getNivel(taxonomy[i]);
        if ( contadorNivel > level){
            level = contadorNivel;
        }
    }
    return level;
}

//Return the number of level according to each node
var contadorNivel = 1;
function getNivel(nodo){
  if (nodo.parent == undefined){
    return contadorNivel;
  }
  else{
    contadorNivel+=1;
    getNivel(nodo.parent);
  }
}

function CalcularPosicionesLineas(pos, nodosIzquierdos, max){
    contadorNivel = 1;
    getNivel(nodosIzquierdos[pos]);
    var nodoNivel = contadorNivel;
    var y1 = 0;
    var y2 = 40;
    var limit = 0;
    var xe = nodosIzquierdos[pos].x+37;
    for (var x = 0; x < pos; x++){
        y2+=20;
    } 
    y1 = y2 + 20; 
    limit = y1;
    var hoja = true;
    for (var i = 0; i < nodosIzquierdos.length; i++){
        contadorNivel = 1;
        getNivel(nodosIzquierdos[i]);
        var elementoNivel = contadorNivel;
        if (elementoNivel == nodoNivel+1 && i > pos){
            limit = y1;
            console.log(nodoNivel);
        }
        if ((elementoNivel == nodoNivel && i > pos) || (i == nodosIzquierdos.length - 1)){
          if (nodoNivel == max-1){
            document.getElementById("CanvasLineasTenues").innerHTML += '<line x1="'+xe+'" y1="'+y2+'" x2="'+xe+'" y2="'+(limit-1)+'" style="stroke:rgb(0,0,0);stroke-width:0.4" />';
          }
          else{
            document.getElementById("CanvasLineasTenues").innerHTML += '<line x1="'+xe+'" y1="'+y2+'" x2="'+xe+'" y2="'+(limit-9)+'" style="stroke:rgb(0,0,0);stroke-width:0.4" />';
          }
          
          //line(nodosIzquierdos[pos].x-35,limit-15,nodosIzquierdos[pos].x-35,y2);
          return;
        }
        else if (elementoNivel > nodoNivel && i > pos){
          y1+=20;
        }
    }
}

function CalcularPosicionesLineasDerecha(pos, nodosDerechos, max){
    contadorNivel = 1;
    getNivel(nodosDerechos[pos]);
    var nodoNivel = contadorNivel;
    var y1 = 0;
    var y2 = 40;
    var limit = 0;
    var xe = nodosDerechos[pos].x+45;
    for (var x = 0; x < pos; x++){
        y2+=20;
    } 
    y1 = y2 + 20; 
    for (var i = 0; i < nodosDerechos.length; i++){
        contadorNivel = 1;
        getNivel(nodosDerechos[i]);
        var elementoNivel = contadorNivel;
        if (elementoNivel == nodoNivel+1 && i > pos){
            limit = y1;
        }
        if ((elementoNivel == nodoNivel && i > pos) || (i == nodosDerechos.length - 1)){
            if (nodoNivel == max-1){
                document.getElementById("CanvasLineasTenues2").innerHTML += '<line x1="'+xe+'" y1="'+(y2)+'" x2="'+xe+'" y2="'+(limit-3)+'" style="stroke:black;stroke-width:0.4" />';
            }
            else{
                document.getElementById("CanvasLineasTenues2").innerHTML += '<line x1="'+xe+'" y1="'+(y2)+'" x2="'+xe+'" y2="'+(limit-10)+'" style="stroke:black;stroke-width:0.4" />';
            }
              //line(nodosIzquierdos[pos].x-35,limit-15,nodosIzquierdos[pos].x-35,y2);
              return;
        }
        else if (elementoNivel > nodoNivel && i > pos){
          y1+=20;
        }
    }
}
