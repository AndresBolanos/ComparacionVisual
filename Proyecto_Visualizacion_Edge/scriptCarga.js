

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
var Click = false;
var autoclick = false;
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

//This function is activated on reload page to reset de information page and switchers

function CargaBitacora(){
    setTimeout(function() {
        loadFiles('AmphibiaTest1.json','AmphibiaTest2.json');
       /* if (window.sessionStorage.getItem('File1_E') != null && window.sessionStorage.getItem('File2_E') != null){
           loadFiles (window.sessionStorage.getItem('File1_E'), window.sessionStorage.getItem('File2_E'));
        }/*/
        setTimeout(function() {
            if (window.sessionStorage.getItem('All_E') == "true"  || (window.sessionStorage.getItem('Congruencia_E') == "true"
                && (window.sessionStorage.getItem('Splits_E') == "true")
                && (window.sessionStorage.getItem('Merges_E') == "true")
                && (window.sessionStorage.getItem('Nuevos_E') == "true")
                && (window.sessionStorage.getItem('Moves_E') == "true")
                && (window.sessionStorage.getItem('Renames_E') == "true")
                && (window.sessionStorage.getItem('Exclusions_E') == "true"))
                )
                {
                     document.getElementById("All").checked = true;
                }
            if (window.sessionStorage.getItem('Congruencia_E') == "true" ){
                 document.getElementById("Congruencia").checked = true;
            }
             if (window.sessionStorage.getItem('Splits_E') == "true" ){
                 document.getElementById("Splits").checked = true;
            }
            if (window.sessionStorage.getItem('Merges_E') == "true" ){
                 document.getElementById("Mergers").checked = true;
            }
            if (window.sessionStorage.getItem('Nuevos_E') == "true" ){
                 document.getElementById("News").checked = true;
            }
            if (window.sessionStorage.getItem('Moves_E') == "true" ){
                 document.getElementById("Moves").checked = true;
            }
            if (window.sessionStorage.getItem('Renames_E') == "true" ){
                 document.getElementById("Renames").checked = true;
            }
            if (window.sessionStorage.getItem('Exclusions_E') == "true" ){
                 document.getElementById("Exclusions").checked = true;
            }
                 VerificarChecks();
                  $(window).trigger('click'); 
                  $(window).trigger('click'); 
        }, 1000);
    },1000);
}


//This function reset de text taxonomies put the font on 12 pixels
function resetText(){
     for (var node1 = 0; node1 < nodesLeft.length; node1++){
         document.getElementById(nodesLeft[node1].name+"1").style.fontSize = "12px";
    }
     for (var node1 = 0; node1 < nodesRight.length; node1++){
         document.getElementById(nodesRight[node1].name+"2").style.fontSize = "12px";
     }
}

//This function reset de text taxonomies put the font on 12 pixels and black\
//Also, if Click variable is true clear the switchers
function resetTextFull(){
    if (Click == true){
        document.getElementById("Splits").checked = false;
        document.getElementById("News").checked = false;
        document.getElementById("Congruencia").checked = false;    
        document.getElementById("Mergers").checked = false;
        document.getElementById("Moves").checked = false;
        document.getElementById("Renames").checked = false;
        document.getElementById("Exclusions").checked = false;
        document.getElementById("All").checked = false;
        splits = false;
        moves = false;
        renames = false;
        exclusions = false;
        merges = false;
        congruencia= false;
        nuevos = false;
        Click = false;
        autoclick = false;
    }
     for (var node1 = 0; node1 < nodesLeft.length; node1++){
        document.getElementById(nodesLeft[node1].name+"1").style.color ="black";
        document.getElementById(nodesLeft[node1].name+"1").style.fontSize = "12px";
    }
     for (var node1 = 0; node1 < nodesRight.length; node1++){
        document.getElementById(nodesRight[node1].name+"2").style.color ="black";
        document.getElementById(nodesRight[node1].name+"2").style.fontSize = "12px";
     }
}


//This function is activated when the document is ready to execute and is clickable of anywhere place.
var tocado = true;
var splitsAux = false;
$(window).click(function(e) {
     if (!tocado){
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
});




$(window).resize(function() {
    window.location.href = window.location.href;
});


function limpiar(){
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
    $(".label1").text(file1.replace(".json", ""));
    $(".label2").text(file2.replace(".json", ""));
    $(".label1").css("visibility", "visible");
    $(".label2").css("visibility", "visible");
    d3.json("Archivos-Datos/"+file1, function (err, data) {
    var pannel = document.getElementById('Contenedor');
    availableWidth = $(window).width(); //size of the width of the screen
    widthRight =availableWidth*0.10;
    availableHeight = $(window).height()+(pannel.scrollHeight*3);

    document.getElementById('CanvasLineasTenues').setAttribute("height", availableHeight+"px");
    document.getElementById('CanvasLineasTenues2').setAttribute("height", availableHeight+"px");

    svg = d3.select("body").append("svg") //Declaration of the canvas that have the lines
            .attr("width",availableWidth)
            .attr("height",availableHeight)
            .attr("id","Canvas");

    var Ltree = d3.layout.treelist()
        .childIndent(25)
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
            
            //nodes.shift();
            
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
            contadorNivel = 0;
            getNivel(nodesLeft[1]);
            var nodeEls = ul.selectAll("li.node").data(nodes, function (d) {
                /*if (d.children == null){
                    x = d.x;
                    y = d.y-10; 
                     document.getElementById("CanvasLineasTenues").innerHTML += '<line x1="'+(x+12)+'" y1="'+y+'" x2="'+(x+19)+'" y2="'+y+'" style="stroke:rgb(0,0,0);stroke-width:0.2" />';
                }*/
                /*else{
                    x = d.x;
                    y = d.y-10; 
                     document.getElementById("CanvasLineasTenues").innerHTML += '<line x1="'+(x+12)+'" y1="'+y+'" x2="'+(x+17)+'" y2="'+y+'" style="stroke:rgb(0,0,0);stroke-width:0.2" />';
                }*/
                d.id = d.id || ++id;
                return d.id;
            });
            var mayor = MaximoNivel(nodesLeft);
            for (var i = 0; i < nodesLeft.length; i++){
                if (nodesLeft[i].children != null){
                    CalcularPosicionesLineas(i, nodesLeft, mayor-1);
                } 
            }
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
                    //on click left nodes selection funcion
                    tocado = true;
                    //mostrarTodos();
                    var processingInstance;
                    processingInstance = Processing.getInstanceById('CANVAS');
                    processingInstance.setup();
                    if (encendido){
                         resetTextFull();
                    }

                    Pintar_Nodos = [];
                    resetTextFull();
                    nombres_Left = [];
                    for (var i = 0; i < nodesLeft.length; i++){
                        //document.getElementById(nodesLeft[i].name+"1").style.fontSize = "x-small";
                        if (nodesLeft[i].name == d.name){
                            Save_Parents_Names_Left(nodesLeft[i].children);
                        }
                    }
                    document.getElementById(d.name+"1").style.fontSize = "large";
                    Pintar_Nodos = Retornar_Nommbres_Left();
                    Pintar_Nodos.push(d.name);
                    processingInstance.drawCongruency_Auxiliar([d],1);
                    processingInstance.drawMoves_Auxiliar(false,10,228,237,Pintar_Nodos,1,d.name);
                    processingInstance.drawSplits_Aux(0,Pintar_Nodos);
                    processingInstance.merge_Aux(Pintar_Nodos,1);
                    exclusiones_Aux();
                    var izquierda_M = processingInstance.returnRename_MovesLeft();
                    var derecha_M = processingInstance.returnRename_MovesRight();
                    var izquierda_C = processingInstance.retornarIzquierdosConguencia();
                    var derecha_C = processingInstance.retornarDerechosConguencia();
                    processingInstance.drawMoves_Auxiliar(true,234, 170, 165,Pintar_Nodos,1,d.name);
                    var izquierda_R = processingInstance.returnRename_MovesLeft();
                    var derecha_R = processingInstance.returnRename_MovesRight();
                    var izquierda_S = processingInstance.returnSplitsLeft();
                    var derecho_S = processingInstance.returnSplitsRight();
                    var izquierdo_Merge = processingInstance.returnIzquierdosMerge();
                    var derecho_Merge = processingInstance.returnDerechosMerge();

                    for (var left = 0; left < izquierda_C.length; left++){
                        document.getElementById("Congruencia").checked = true;
                        document.getElementById(izquierda_C[left].nodo.name+"1").style.color ="#0E50D9";
                        document.getElementById(izquierda_C[left].nodo.name+"1").style.fontSize = "large";
                    }
                    for (var right = 0; right < derecha_C.length; right++){
                        document.getElementById(derecha_C[right].nodo.name+"2").style.color ="#0E50D9";
                        document.getElementById(derecha_C[right].nodo.name+"2").style.fontSize = "large";
                    }
                    for (var left = 0; left < izquierda_M.length; left++){
                        document.getElementById("Moves").checked = true;
                        document.getElementById(izquierda_M[left].name+"1").style.color ="#09D4D4";
                        document.getElementById(izquierda_M[left].name+"1").style.fontSize = "large";
                         
                    }
                    for (var right = 0; right < derecha_M.length; right++){
                        document.getElementById(derecha_M[right].name+"2").style.color ="#09D4D4";
                        document.getElementById(derecha_M[right].name+"2").style.fontSize = "large";
                    }
                    for (var left = 0; left < izquierda_R.length; left++){
                        document.getElementById("Renames").checked = true;
                        document.getElementById(izquierda_R[left].name+"1").style.color ="#EAAAA5";
                        document.getElementById(izquierda_R[left].name+"1").style.fontSize = "large";
                    }
                    for (var right = 0; right < derecha_R.length; right++){
                        document.getElementById(derecha_R[right].name+"2").style.color ="#EAAAA5";
                        document.getElementById(derecha_R[right].name+"2").style.fontSize = "large";
                    }
                    for (var i = 0; i < Pintar_Nodos.length; i++){
                        for (var left = 0; left < arregloEclusiones.length; left++){
                            if (Pintar_Nodos[i] == arregloEclusiones[left].name){
                                document.getElementById("Exclusions").checked = true;
                                document.getElementById(arregloEclusiones[left].name+"1").style.color ="#D00101";
                                document.getElementById(arregloEclusiones[left].name+"1").style.fontSize = "large";
                            }
                        }
                    }
                    
                    for (var left = 0; left < izquierda_S.length; left++){
                        document.getElementById("Splits").checked = true;
                        document.getElementById(izquierda_S[left].name+"1").style.color ="#FF00BF";
                        document.getElementById(izquierda_S[left].name+"1").style.fontSize = "large";
                        
                    }
                    for (var rigth = 0; rigth < derecho_S.length; rigth++){
                        document.getElementById(derecho_S[rigth].name +"2").style.color ="#FF00BF";
                        document.getElementById(derecho_S[rigth].name +"2").style.fontSize = "large";
                    }
                    
                    for (var left = 0; left < izquierdo_Merge.length; left++){
                        document.getElementById("Mergers").checked = true;
                        document.getElementById(izquierdo_Merge[left].name +"1").style.color ="#FFA656";
                        document.getElementById(izquierdo_Merge[left].name +"1").style.fontSize = "large";
  
                    }
                    for (var rigth = 0; rigth < derecho_Merge.length; rigth++){
                        document.getElementById(derecho_Merge[rigth].name +"2").style.color ="#FFA656";
                        document.getElementById(derecho_Merge[rigth].name +"2").style.fontSize = "large";
                    }
                    Click = true;
                    tocado = true;
                });
            //add arrows if it is a folder
            entered.append("span").style("font-size", "15px").attr("class", function (d) {

                var icon = d.children ? "glyphicon glyphicon-minus" // put the minus to the father node
                    : d._children ? "glyphicon glyphicon-minus" : "";
                return "caret glyphicon" + icon;//put the minus to the children nodes
            });
            entered.append("span").attr("class", "zoomTarget filename")
                .attr("id",function (d) { return d.name+"1"; })
                .html(function (d) { 
                    if (d.children == undefined){
                        return "– "+d.name;
                    }
                    else{
                        return " "+d.name;
                    }
                     });

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
                .childIndent(25)
                .nodeHeight(20);
            var ul = d3.select("#rightSide").append("ul").classed("treelist", "true");
            function render(data, parent) {
                var nodes = Rtree.nodes(data),
                    duration = 1000;

                //nodes.shift(); //Si se quiere q salga de anura adelante

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
                    /* if (d.children == null){
                        x = d.x;
                        y = d.y-10; 
                         document.getElementById("CanvasLineasTenues2").innerHTML += '<line x1="'+(x+10)+'" y1="'+y+'" x2="'+(x+18)+'" y2="'+y+'" style="stroke:rgb(0,0,0);stroke-width:0.2" />';

                    }*/
                    d.id = d.id || ++id;
                    return d.id;
                });

                var mayor = MaximoNivel(nodesRight);
                for (var i = 0; i < nodesRight.length; i++){
                    if (nodesRight[i].children != null){
                        CalcularPosicionesLineasDerecha(i, nodesRight, mayor-1);
                    } 
                }
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
                        //on click right nodes selection funcion
                        tocado = true;
                        var processingInstance;
                        processingInstance = Processing.getInstanceById('CANVAS');
                        processingInstance.setup();
                        if (encendido){
                             resetTextFull();
                        }
                            //This section is to include the clickable nodes taxonomies with off switchers
                        resetTextFull();
                        nombres_Right = [];
                        for (var i = 0; i < nodesRight.length; i++){
                            document.getElementById(nodesRight[i].name+"2").style.fontSize = "small";
                            if (nodesRight[i].name == d.name){
                                Save_Parents_Names_Right(nodesRight[i].children);
                            }
                        }
                        Pintar_Nodos = [];
                        resetTextFull();
                        nombres_Right = [];
                        for (var i = 0; i < nodesRight.length; i++){
                            //document.getElementById(nodesLeft[i].name+"1").style.fontSize = "x-small";
                            if (nodesRight[i].name == d.name){
                                Save_Parents_Names_Right(nodesRight[i].children);
                            }
                        }
                        document.getElementById(d.name+"1").style.fontSize = "large";
                        Pintar_Nodos = Retornar_Nommbres_Right();
                        Pintar_Nodos.push(d.name);
                        processingInstance.drawCongruency_Auxiliar([d],1);
                        processingInstance.drawMoves_Auxiliar(false,10,228,237,Pintar_Nodos,1,d.name);
                        processingInstance.drawSplits_Aux(0.5,Pintar_Nodos);
                        processingInstance.merge_Aux(Pintar_Nodos,1);
                        Nuevos_Aux();
                        var izquierda_M = processingInstance.returnRename_MovesLeft();
                        var derecha_M = processingInstance.returnRename_MovesRight();
                        var izquierda_C = processingInstance.retornarIzquierdosConguencia();
                        var derecha_C = processingInstance.retornarDerechosConguencia();
                        processingInstance.drawMoves_Auxiliar(true,234, 170, 165,Pintar_Nodos,1,d.name);
                        var izquierda_R = processingInstance.returnRename_MovesLeft();
                        var derecha_R = processingInstance.returnRename_MovesRight();
                        var izquierda_S = processingInstance.returnSplitsLeft();
                        var derecho_S = processingInstance.returnSplitsRight();
                        var izquierdo_Merge = processingInstance.returnIzquierdosMerge();
                        var derecho_Merge = processingInstance.returnDerechosMerge();
                        for (var left = 0; left < izquierda_C.length; left++){
                            document.getElementById("Congruencia").checked = true;
                            document.getElementById(izquierda_C[left].nodo.name+"1").style.color ="#0E50D9";
                            document.getElementById(izquierda_C[left].nodo.name+"1").style.fontSize = "large";
                        }

                        for (var right = 0; right < derecha_C.length; right++){
                            document.getElementById(derecha_C[right].nodo.name+"2").style.color ="#0E50D9";
                            document.getElementById(derecha_C[right].nodo.name+"2").style.fontSize = "large";
                        }

                        for (var left = 0; left < izquierda_M.length; left++){
                            document.getElementById("Moves").checked = true;
                            document.getElementById(izquierda_M[left].name+"1").style.color ="#09D4D4";
                            document.getElementById(izquierda_M[left].name+"1").style.fontSize = "large";  
                        }

                        for (var right = 0; right < derecha_M.length; right++){
                            document.getElementById(derecha_M[right].name+"2").style.color ="#09D4D4";
                            document.getElementById(derecha_M[right].name+"2").style.fontSize = "large";
                        }

                        for (var left = 0; left < izquierda_R.length; left++){
                            document.getElementById("Renames").checked = true;
                            document.getElementById(izquierda_R[left].name+"1").style.color ="#EAAAA5";
                            document.getElementById(izquierda_R[left].name+"1").style.fontSize = "large";
                        }

                        for (var right = 0; right < derecha_R.length; right++){
                            document.getElementById(derecha_R[right].name+"2").style.color ="#EAAAA5";
                            document.getElementById(derecha_R[right].name+"2").style.fontSize = "large";
                        }

                        for (var i = 0; i < Pintar_Nodos.length; i++){
                            for (var right = 0; right < arregloNuevos.length; right++){
                                if (arregloNuevos[right].name == Pintar_Nodos[i]){
                                    document.getElementById("News").checked = true;
                                    document.getElementById(Pintar_Nodos[i]+"2").style.color ="#076501";
                                    document.getElementById(Pintar_Nodos[i]+"2").style.fontSize = "large";
                                }
                            }
                        }
                        
                        
                        for (var left = 0; left < izquierda_S.length; left++){
                            document.getElementById("Splits").checked = true;
                            document.getElementById(izquierda_S[left].name+"1").style.color ="#FF00BF";
                            document.getElementById(izquierda_S[left].name+"1").style.fontSize = "large";
                            
                        }

                        for (var rigth = 0; rigth < derecho_S.length; rigth++){
                            document.getElementById(derecho_S[rigth].name +"2").style.color ="#FF00BF";
                            document.getElementById(derecho_S[rigth].name +"2").style.fontSize = "large";
                        }
                        
                        for (var left = 0; left < izquierdo_Merge.length; left++){
                            document.getElementById("Mergers").checked = true;
                            document.getElementById(izquierdo_Merge[left].name +"1").style.color ="#FFA656";
                            document.getElementById(izquierdo_Merge[left].name +"1").style.fontSize = "large";
                        }

                        for (var rigth = 0; rigth < derecho_Merge.length; rigth++){
                            document.getElementById(derecho_Merge[rigth].name +"2").style.color ="#FFA656";
                            document.getElementById(derecho_Merge[rigth].name +"2").style.fontSize = "large";
                        }
                        Click = true;
                        tocado = true;       
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
                .html(function (d) { 
                    if (d.children == undefined){
                        return "–  "+d.name; 
                    }
                    else{
                        return "  "+d.name; 
                    }
                    });

                nodeEls.select("span").attr("class", function (d) {
                    var icon = d.children ? "glyphicon glyphicon-minus"
                        : d._children ? "glyphicon glyphicon-plus" : "";
                    return icon;
                });
                 var element  = document.getElementsByTagName("span");
                    for (var i = 0; i < element.length;i++){
                        element[i].setAttribute("data-targetsize","0.10");
                    }
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
        window.sessionStorage.setItem("File1_E", file1);
        window.sessionStorage.setItem("File2_E", file2);
}

var padres = 0;
function buscar_padres(nombre,nodos){
    padres = 0;
    for (var i = 1;i<nodos.length;i++){
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

//This functions is activated when page is full loaded.
$(window).bind("load", function() {
    CargaBitacora(); //Call the function that load the latest state of the page.
});