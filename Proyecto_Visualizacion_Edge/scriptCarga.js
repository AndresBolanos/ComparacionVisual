

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
var widthRight;
var text;


//Banderas de sliders
var splits = false;
var moves = false;
var renames = false;
var exclusions = false;
var merges = false;
var congruencia= false;
var nuevos = false;
var pintadoLinea = 0;
var arregloEclusiones = [];
var arregloNuevos = [];
var encendido = false;


function resetText(){
     for (var node1 = 0; node1 < nodesLeft.length; node1++){
         document.getElementById(nodesLeft[node1].name+"1").style.fontSize = "12px";
    }
     for (var node1 = 0; node1 < nodesRight.length; node1++){
         document.getElementById(nodesRight[node1].name+"2").style.fontSize = "12px";
     }
}

function resetTextFull(){
     for (var node1 = 0; node1 < nodesLeft.length; node1++){
        document.getElementById(nodesLeft[node1].name+"1").style.color ="black";
        document.getElementById(nodesLeft[node1].name+"1").style.fontSize = "12px";
    }
     for (var node1 = 0; node1 < nodesRight.length; node1++){
        document.getElementById(nodesRight[node1].name+"2").style.color ="black";
        document.getElementById(nodesRight[node1].name+"2").style.fontSize = "12px";
     }
}


var tocado = true;
var splitsAux = false;
$(window).click(function(e) {
    if(splitsAux == false){
         if (!tocado){
            console.log("Opa");
            resetTextFull();
            var processingInstance;
            processingInstance = Processing.getInstanceById('CANVAS');
            processingInstance.setup();
            VerificarChecks();
            splitsAux = false;
        }
        else{
            tocado = false;
            splitsAux = false;
        }
    }
    else{
        splitsAux = false;
    }
});



$(window).resize(function() {
    window.location.href = window.location.href;
});


function limpiar(){
    console.log("Limpia");
    $( "ul" ).remove( ".treelist" );
    $("#CanvasLineasTenues").empty();
    $("#CanvasLineasTenues2").empty();
    /*$("#leftSide").replaceWith(originalStateLeft);
    $("#rightSide").replaceWith(originalStateRight);*/
}
//var margin = {top: -5, right: -5, bottom: -5, left: -5};
var margin = -5;
var tocado = true;

function loadFiles (file1, file2){
    limpiar();
    d3.json("Archivos-Datos/"+file1, function (err, data) {
    var pannel = document.getElementById('Contenedor');
    availableWidth = $(window).width(); //size of the width of the screen
    widthRight =availableWidth*0.10;
    availableHeight = $(window).height()+(pannel.scrollHeight*2);

    document.getElementById('CanvasLineasTenues').setAttribute("height", availableHeight+"px");
    document.getElementById('CanvasLineasTenues2').setAttribute("height", availableHeight+"px");

    svg = d3.select("body").append("svg") //Declaration of the canvas that have the lines
            .attr("width",availableWidth)
            .attr("height",availableHeight)
            .attr("id","Canvas");

    var Ltree = d3.layout.treelist()
        .childIndent(20)
        .nodeHeight(20);

    var ul = d3.select("#leftSide").append("ul").classed("treelist", "true");
    var element = document.getElementById("leftSide");
    // Instead of .addClass("newclass")
    //element.setAttribute("class", );

    anchoDiv = document.getElementById("leftSide").offsetWidth;
    var pintado = false;
    function render(data, parent) {
            var nodes = Ltree.nodes(data),
            duration = 1000;
            function toggleChildren(d) {
                $("#CanvasLineasTenues").empty();
                if (d.children) {
                    d._children = d.children;
                    d.children = null;
                } else if (d._children) {
                    d.children = d._children;
                    d._children = null;
                }
            }

            nodesLeft = nodes;  // ww assign the nodes of the left to the global variable to use it in the next functions
            NODOS = nodes;
            var nodeEls = ul.selectAll("li.node").data(nodes, function (d) {
                d.id = d.id || ++id;
                //  AQUI FUE DONDE HICE LOS PROCESOOOOOS
                buscar_padres(d.name,nodesLeft);
                if (d.id == nodesLeft[0].id){
                    $("#CanvasLineasTenues").empty();
                }
                //console.log(padres);
                if (padres >= 1){
                    var y = d.y-20;
                    var y2 = y+20;
                    var x = 0;
                    for (var i = 0; i < padres; i++){                  
                        document.getElementById("CanvasLineasTenues").innerHTML += '<line x1="'+x+'" y1="'+y+'" x2="'+x+'" y2="'+y2+'" style="stroke:rgb(0,0,0);stroke-width:0.1" />';
                        x+=20;
                    }
                }
                return d.id;
            });
            //entered nodes
            //element.setAttribute("data-targetsize", "0.45");
            var entered = nodeEls.enter().append("li")//Here is everything related when you press each of the nodes
                .attr("class","node")
                .style("top", parent.y +"px")
                .style("opacity", 0)
                .style("height", Ltree.nodeHeight() + "px")
                .on("mouseover", function (d) {
                    d3.select(this).classed("selected", true);
                })
                .on("mouseout", function (d) {
                    d3.selectAll(".selected").classed("selected", false);
                })
                .on("click", function (d) {
                    tocado = true;
                    //mostrarTodos();
                    var processingInstance;
                    processingInstance = Processing.getInstanceById('CANVAS');
                    processingInstance.setup();
                    if (encendido){
                         resetTextFull();
                    }
                    resetText();
                     if(congruencia == true){
                        processingInstance.drawCongruency(d.name,2);
                        var arregloizuierda = processingInstance.retornarIzquierdosConguencia();
                        for (var i = 0; i < arregloizuierda.length; i++){
                            if (arregloizuierda[i].nodo.name == d.name){
                                if (arregloizuierda[i].color == "Azul"){
                                    document.getElementById(d.name+"1").style.color ="#1712C4";
                                    document.getElementById(d.name+"2").style.color ="#1712C4";
                                }
                                else{
                                    document.getElementById(d.name+"1").style.color ="#00E3FF";
                                    document.getElementById(d.name+"2").style.color ="#00E3FF";
                                }
                                document.getElementById(d.name+"1").style.fontSize = "large";
                                document.getElementById(d.name+"2").style.fontSize = "large";
                            }
                        }
                     }
                     if (splits == true){
                        processingInstance.drawSplits(2,d.name); //Aqui mando el ancho de la linea
                        var arregloIzquierdos =  processingInstance.returnSplitsLeft();
                        for (var i = 0; i < arregloIzquierdos.length; i++){
                            if (arregloIzquierdos[i].name == d.name){
                                console.log(d.name);
                                document.getElementById(d.name+"1").style.color ="#FF00BF";
                                document.getElementById(d.name+"1").style.fontSize = "large";
                            }
                        }
                        var arregloDerechos =  processingInstance.returnSplitsRight();
                        for (var i = 0; i < arregloDerechos.length; i++){
                            if (arregloDerechos[i].Synonym.length == 0){
                                if (arregloDerechos[i].name == d.name){
                                    document.getElementById(d.name+"2").style.color ="#FF00BF";
                                    document.getElementById(d.name+"2").style.fontSize = "large";
                                }
                            }
                            else{
                                var sinonimos = arregloDerechos[i].Synonym;
                                for (var s = 0; s < sinonimos.length; s++){
                                    if (sinonimos[s] == d.name){
                                        console.log(arregloDerechos[i].name);
                                        document.getElementById(arregloDerechos[i].name+"2").style.color ="#FF00BF";
                                        document.getElementById(arregloDerechos[i].name+"2").style.fontSize = "large";
                                    }
                                }
                            }
                        } 
                        console.log("sale");     
                     }
                     if (moves == true){
                        processingInstance.drawMoves(false,10,228,237,d.name,2);
                        var arregloizuierda = processingInstance.returnRename_MovesLeft();
                        for (var i = 0; i < arregloizuierda.length; i++){
                            if (arregloizuierda[i].name == d.name){
                                document.getElementById(d.name+"1").style.color ="#0AE4ED";
                                document.getElementById(d.name+"1").style.fontSize = "large";
                            }
                        }
                        var arregloderecha = processingInstance.returnRename_MovesRight();
                        for (var i = 0; i < arregloderecha.length; i++){ //Agregar el asunto para q sea solo uno
                            var sinonimos = arregloderecha[i].Synonym;
                            for (var s = 0; s < sinonimos.length; s++){
                                if (sinonimos[s] == d.name){
                                    document.getElementById(arregloderecha[i].name+"2").style.color ="#0AE4ED";
                                    document.getElementById(arregloderecha[i].name+"2").style.fontSize = "large";
                                }
                            }
                        }                  
                     }
                     if (renames == true){
                        processingInstance.drawMoves(true,91,255,142,d.name,2);
                        var arregloizuierda = processingInstance.returnRename_MovesLeft();
                        for (var i = 0; i < arregloizuierda.length; i++){
                            if (arregloizuierda[i].name == d.name){
                                document.getElementById(d.name+"1").style.color ="#5BFF8E";
                                document.getElementById(d.name+"1").style.fontSize = "large";
                            }
                        }
                        var arregloderecha = processingInstance.returnRename_MovesRight();
                        for (var i = 0; i < arregloderecha.length; i++){ //Agregar el asunto para q sea solo uno
                            var sinonimos = arregloderecha[i].Synonym;
                            for (var s = 0; s < sinonimos.length; s++){
                                if (sinonimos[s] == d.name){
                                    document.getElementById(arregloderecha[i].name+"2").style.color ="#5BFF8E";
                                    document.getElementById(arregloderecha[i].name+"2").style.fontSize = "large";
                                }
                            }
                        }                  
                     }
                     if (exclusions == true){
                        exclusiones();
                        for (var i = 0; i < arregloEclusiones.length; i++){
                            if (arregloEclusiones[i].name == d.name){
                                document.getElementById(d.name+"1").style.color ="#DF0101";
                                document.getElementById(d.name+"1").style.fontSize = "large";
                            }
                        } 
                        arregloEclusiones = []; 
                     }
                     if (merges == true){
                        processingInstance.merge(d.name,2);
                        var nodoDerecho = "";
                        var nodosIzquierdos = [];
                        var arregloderecha = processingInstance.returnDerechosMerge();
                        for (var i = 0; i < arregloderecha.length; i++){
                            var sinonimos = arregloderecha[i].Synonym;
                            for (var j = 0; j < sinonimos.length;j++){
                                if (sinonimos[j] == d.name){
                                    nodoDerecho =  arregloderecha[i].name;
                                    nodosIzquierdos = sinonimos;
                                }
                            }
                        }
                        if (document.getElementById(nodoDerecho+"2") != null){
                            document.getElementById(nodoDerecho+"2").style.color ="#FF9100";
                            document.getElementById(nodoDerecho+"2").style.fontSize = "large";
                            for (var i = 0; i < nodosIzquierdos.length; i++){
                                document.getElementById(nodosIzquierdos[i]+"1").style.color ="#FF9100";
                                document.getElementById(nodosIzquierdos[i]+"1").style.fontSize = "large";
                            }
                        }
                     }
                     if (renames == false && moves == false && splits == false && merges == false && congruencia == false && nuevos == false && exclusions == false){
                        for (var i = 0; i < nodesLeft.length; i++){
                        
                                    document.getElementById(d.name+"1").style.color ="black";
                                    document.getElementById(d.name+"1").style.fontSize = "large";
                                    //processingInstance.painSelectedNode(nodesLeft[i].name,nodesLeft[i].author,nodesLeft[i].record_scrutiny_date);
                                    encendido = true;
                        }
                     }
                     else{
                        console.log("Siiii");
                     }
                });
            //add arrows if it is a folder
            entered.append("span").style("font-size", "18px").attr("class", function (d) {

                var icon = d.children ? "glyphicon glyphicon-minus" // put the minus to the father node
                    : d._children ? "glyphicon glyphicon-minus" : "";
                return "caret glyphicon" + icon;//put the minus to the children nodes
            });
            entered.append("span").attr("class", "zoomTarget filename")
                .attr("id",function (d) { return d.name+"1"; })
                .html(function (d) { return "   "+d.name; });
            var element  = document.getElementsByTagName("li");
            for (var i = 0; i < element.length;i++){
                element[i].setAttribute("data-targetsize","0.10");
            }
            //update caret direction
            nodeEls.select("span").attr("class", function (d) {
                var icon = d.children ? "glyphicon glyphicon-minus"
                    : d._children ? "glyphicon glyphicon-plus" : "";
                return icon;
            });
            //Make only the icon to be displayed
             nodeEls.select("span").on("click", function (d) {
                    $("#CanvasLineasTenues").empty();
                    toggleChildren(d);
                    render(data, d);
            })
            //update position with transition
            nodeEls.transition().duration(duration)
                .style("top", function (d) { return (d.y - Ltree.nodeHeight()) + "px";})
                .style("left", function (d) { return d.x + "px"; })
                .style("opacity", 1);

            nodeEls.exit().remove();
            nodesLeft = nodes;
        }
        x = x+150;
        render(data, data);
    });


    d3.json("Archivos-Datos/"+file2, function (err, data) { //This function is developed in the same way as the previous function, read the json just on the right side
            var Rtree = d3.layout.treelist()
                .childIndent(20)
                .nodeHeight(20);
            var ul = d3.select("#rightSide").append("ul").classed("treelist", "true");
            function render(data, parent) {
                var nodes = Rtree.nodes(data),
                    duration = 1000;
                function toggleChildren(d) {
                    $("#CanvasLineasTenues2").empty();
                    if (d.children) {
                        d._children = d.children;
                        d.children = null;
                    } else if (d._children) {
                        d.children = d._children;
                        d._children = null;
                    }
                }           
                nodesRight = nodes;
                var nodeEls = ul.selectAll("li.node").data(nodes, function (d) {
                    d.id = d.id || ++id;
                     buscar_padres(d.name,nodesRight);
                    if (d.id == nodesRight[0].id){
                        $("#CanvasLineasTenues2").empty();
                    }
                    //console.log(padres);
                    if (padres >= 1){
                        var y = d.y -20;
                        var y2 = y+20;
                        var x = 0;
                        for (var i = 0; i < padres; i++){                  
                            document.getElementById("CanvasLineasTenues2").innerHTML += '<line x1="'+x+'" y1="'+y+'" x2="'+x+'" y2="'+y2+'" style="stroke:rgb(0,0,0);stroke-width:0.1" />';
                            x+=20;
                        }
                    }
                    return d.id;
                });
                //entered nodes
                var entered = nodeEls.enter().append("li")
                    .attr("class","node")
                    .style("top", parent.y +"px")
                    .style("opacity", 0)
                    .style("height", Rtree.nodeHeight() + "px")
                    .on("mouseover", function (d) {
                        d3.select(this).classed("selected", true);
                    })
                    .on("mouseout", function (d) {
                        d3.selectAll(".selected").classed("selected", false);
                    })
                    .on("click", function (d) {
                        //mostrarTodos();
                        tocado = true;
                        var processingInstance;
                        processingInstance = Processing.getInstanceById('CANVAS');
                        processingInstance.setup();
                        if (encendido){
                             resetTextFull();
                        }
                        resetText();
                        if (renames == true){
                            processingInstance.drawMoves(true,8,138,8,d.name,2);
                            var congruente = [];
                            var arregloderecha = processingInstance.returnRename_MovesRight();
                            for (var i = 0; i < arregloderecha.length; i++){
                                if (arregloderecha[i].name == d.name){
                                    congruente = arregloderecha[i].Synonym;
                                    document.getElementById(d.name+"2").style.color ="#088A08";
                                    document.getElementById(d.name+"2").style.fontSize = "large";
                                }
                            }
                            if (congruente.length > 0){
                                for (var s = 0; s < congruente.length; s++){
                                    document.getElementById(congruente[s]+"1").style.color ="#088A08";
                                    document.getElementById(congruente[s]+"1").style.fontSize = "large";
                                }
                            }    
                        }
                        if (nuevos == true){
                            pintarNuevos();
                            for (var i = 0; i < arregloNuevos.length; i++){
                                if (arregloNuevos[i].name == d.name){
                                    document.getElementById(d.name+"2").style.color ="#088A00";
                                    document.getElementById(d.name+"2").style.fontSize = "large";
                                }
                            }
                            arregloNuevos = [];
                        }
                         if (moves == true){
                            processingInstance.drawMoves(false,10,228,237,d.name,2);
                            var congruente = [];
                            var arregloderecha = processingInstance.returnRename_MovesRight();
                            for (var i = 0; i < arregloderecha.length; i++){
                                if (arregloderecha[i].name == d.name){
                                    congruente = arregloderecha[i].Synonym;
                                    document.getElementById(d.name+"2").style.color ="#0AE4ED";
                                    document.getElementById(d.name+"2").style.fontSize = "large";
                                }
                            }
                            if (congruente.length > 0){
                                for (var s = 0; s < congruente.length; s++){
                                    try{
                                        document.getElementById(congruente[s]+"1").style.color ="#0AE4ED";
                                        document.getElementById(congruente[s]+"1").style.fontSize = "large";
                                    }
                                    catch(e){
                                        console.log("Error");
                                    }
                                }
                            }    
                         }
                          if(congruencia == true){
                             processingInstance.drawCongruency(d.name,2);
                            var arregloderecha = processingInstance.retornarDerechosConguencia();
                            for (var i = 0; i < arregloderecha.length; i++){
                                if (arregloderecha[i].nodo.name == d.name){
                                    if (arregloderecha[i].color == "Azul"){
                                        document.getElementById(d.name+"1").style.color ="#1712C4";
                                        document.getElementById(d.name+"2").style.color ="#1712C4";
                                    }
                                    else{
                                        document.getElementById(d.name+"1").style.color ="#00E3FF";
                                        document.getElementById(d.name+"2").style.color ="#00E3FF";
                                    }
                                    document.getElementById(d.name+"1").style.fontSize = "large";
                                    document.getElementById(d.name+"2").style.fontSize = "large";
                                }
                            }
                          }
                          if (merges == true){
                            processingInstance.merge(d.name,2);
                            var nodoDerecho = "";
                            var nodosIzquierdos = [];
                            var arregloderecha = processingInstance.returnDerechosMerge();
                            for (var i = 0; i < arregloderecha.length; i++){
                                if (arregloderecha[i].name == d.name){
                                    nodoDerecho =  arregloderecha[i].name;
                                    nodosIzquierdos = arregloderecha[i].Synonym;;
                                }
                            }
                            if (document.getElementById(nodoDerecho+"2") != null){
                                document.getElementById(nodoDerecho+"2").style.color ="#FF9100";
                                document.getElementById(nodoDerecho+"2").style.fontSize = "large";
                                console.log(nodosIzquierdos);
                                for (var i = 0; i < nodosIzquierdos.length; i++){
                                    document.getElementById(nodosIzquierdos[i]+"1").style.color ="#FF9100";
                                    document.getElementById(nodosIzquierdos[i]+"1").style.fontSize = "large";
                                }
                            }
                          }
                          if (splits == true){
                            processingInstance.drawSplits(2,""); //Aqui mando el ancho de la linea
                            var arregloDerechos =  processingInstance.returnSplitsRight();
                            for (var i = 0; i < arregloDerechos.length; i++){
                                if (arregloDerechos[i].Synonym.length == 0){
                                    if (arregloDerechos[i].name == d.name){
                                        document.getElementById( d.name+"1").click();
                                    }
                                }
                                else{
                                    var sinonimos = arregloDerechos[i].Synonym;
                                    for (var s = 0; s < sinonimos.length; s++){
                                        if (arregloDerechos[i].name == d.name){
                                            document.getElementById(sinonimos[s]+"1").click();
                                        }
                                    }
                                }
                            }   
                            splitsAux = true;  
                          }
                        if (renames == false && moves == false && splits == false && merges == false && congruencia == false && nuevos == false && exclusions == false){
                
                                        document.getElementById(d.name+"2").style.color ="black";
                                        document.getElementById(d.name+"2").style.fontSize = "large";
                                        //processingInstance.painSelectedNode(nodesLeft[i].name,nodesLeft[i].author,nodesLeft[i].record_scrutiny_date);
                                        encendido = true;
                        }
                    });
                    var element  = document.getElementsByTagName("li");
                    for (var i = 0; i < element.length;i++){
                        element[i].setAttribute("data-targetsize","0.10");
                    }
                //add arrows if it is a folder
               entered.append("span").style("font-size", "18px").attr("class", function (d) {
                    var icon = d.children ? "glyphicon glyphicon-minus" //put the minus to the father node
                        : d._children ? "glyphicon glyphicon-minus" : "";
                    return "caret glyphicon" + icon;//put the minus to the children nodes
                });
            
               entered.append("span").attr("class", "zoomTarget filename")
                .attr("id",function (d) { return d.name+"2"; })
                .html(function (d) { return "   "+d.name; });
                nodeEls.select("span").attr("class", function (d) {
                    var icon = d.children ? "glyphicon glyphicon-minus"
                        : d._children ? "glyphicon glyphicon-plus" : "";
                    return icon;
                });
                 var element  = document.getElementsByTagName("span");
                    for (var i = 0; i < element.length;i++){
                        element[i].setAttribute("data-targetsize","0.10");
                    }
                    console.log(element);
                nodeEls.select("span").on("click", function (d) { 
                        $("#CanvasLineasTenues2").empty();               
                        toggleChildren(d);
                        render(data, d);
                })
                //update position with transition
                nodeEls.transition().duration(duration)
                    .style("top", function (d) { return (d.y - Rtree.nodeHeight()) + "px";})
                    .style("left", function (d) { return d.x + "px"; })
                    .style("opacity", 1);
                nodeEls.exit().remove();
            }
            render(data, data);
        });

}

var padres = 0;
function buscar_padres(nombre,nodos){
    padres = 0;
    for (var i = 0;i<nodos.length;i++){
        if (nodos[i].name == nombre){
            buscar_padres_aux(nodos[i]);
            return padres;
        }
    }
}

//This is an auxiliar function that receive a node of the buscar_padres function
//Check if a node have father and break the recursive loop if the father is undefined
function buscar_padres_aux(nodo){
    if (nodo.parent == undefined){
        return;
    }    
    else{
        get_padre_name(nodo.parent);
        buscar_padres_aux(nodo.parent);
    }
}

//Load the name of the fathers in the padres array
function get_padre_name(nodo){
    padres++;
}