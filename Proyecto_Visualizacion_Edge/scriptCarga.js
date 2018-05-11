

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
    if(splitsAux == false){
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
    }
    else{
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
        .childIndent(17)
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
            nodes.shift();
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
            for (var i = 0; i < nodesLeft.length; i++){
                if (nodesLeft[i].children != null){
                    CalcularPosicionesLineas(i, nodesLeft, Quantity_Nodes(nodesLeft));
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
                    tocado = true;
                    //mostrarTodos();
                    var processingInstance;
                    processingInstance = Processing.getInstanceById('CANVAS');
                    processingInstance.setup();
                    if (encendido){
                         resetTextFull();
                    }
                    //resetText();
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
                                        document.getElementById(arregloDerechos[i].name+"2").style.color ="#FF00BF";
                                        document.getElementById(arregloDerechos[i].name+"2").style.fontSize = "large";
                                    }
                                }
                            }
                        }     
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
                     else if (splits == false && exclusions == false && merges == false && renames == false && moves == false && congruencia == false){
                        resetTextFull();
                        nombres_Left = [];
                        if (autoclick == false){
                            autoclick = true;
                            $('#'+d.name+"2").click();
                        }
                        else{
                            autoclick = false;
                        }
                        for (var i = 0; i < nodesLeft.length; i++){
                            //document.getElementById(nodesLeft[i].name+"1").style.fontSize = "x-small";
                            if (nodesLeft[i].name == d.name){
                                Save_Parents_Names_Left(nodesLeft[i].children);
                            }
                        }
                        document.getElementById(d.name+"1").style.fontSize = "large";
                        Pintar_Nodos = Retornar_Nommbres_Left();
                        Pintar_Nodos.push(d.name);
                        processingInstance.drawCongruency_Auxiliar(Pintar_Nodos,1);
                        processingInstance.drawMoves_Auxiliar(false,10,228,237,Pintar_Nodos,1,d.name);
                        processingInstance.drawSplits_Aux(0.5,Pintar_Nodos);
                        processingInstance.merge_Aux(Pintar_Nodos,1);
                        exclusiones_Aux();
                        var izquierda_M = processingInstance.returnRename_MovesLeft();
                        var derecha_M = processingInstance.returnRename_MovesRight();
                        var izquierda_C = processingInstance.retornarIzquierdosConguencia();
                        processingInstance.drawMoves_Auxiliar(true,91,255,142,Pintar_Nodos,1,d.name);
                        var izquierda_R = processingInstance.returnRename_MovesLeft();
                        var izquierda_S = processingInstance.returnSplitsLeft();
                        var derecho_S = processingInstance.returnSplitsRight();
                        var izquierdo_Merge = processingInstance.returnIzquierdosMerge();
                        var derecho_Merge = processingInstance.returnDerechosMerge();
                        for (var i = 0; i < Pintar_Nodos.length; i++){
                            for (var left = 0; left < izquierda_C.length; left++){
                                 document.getElementById("Congruencia").checked = true;
                                if (izquierda_C[left].nodo.name == Pintar_Nodos[i]){
                                    document.getElementById(Pintar_Nodos[i]+"1").style.color ="#1712C4";
                                }
                            }
                            for (var left = 0; left < izquierda_M.length; left++){
                                document.getElementById("Moves").checked = true;
                                if (izquierda_M[left].name == Pintar_Nodos[i]){
                                    document.getElementById(Pintar_Nodos[i]+"1").style.color ="#0AE4ED";
                                     for (var right = 0; right < derecha_M.length; right++){
                                        document.getElementById(derecha_M[right].name+"2").style.color ="#0AE4ED";
                                        document.getElementById(derecha_M[right].name+"2").style.fontSize = "large";
                                    }
                                }
                            }
                            for (var left = 0; left < izquierda_R.length; left++){
                                document.getElementById("Renames").checked = true;
                                if (izquierda_R[left].name == Pintar_Nodos[i]){
                                    document.getElementById(Pintar_Nodos[i]+"1").style.color ="#5BFF8E";
                                }
                            }
                            for (var left = 0; left < arregloEclusiones.length; left++){
                                if (arregloEclusiones[left].name == Pintar_Nodos[i]){
                                    document.getElementById("Exclusions").checked = true;
                                    document.getElementById(Pintar_Nodos[i]+"1").style.color ="#DF0101";
                                }
                            }
                            for (var left = 0; left < izquierda_S.length; left++){
                                document.getElementById("Splits").checked = true;
                                if (izquierda_S[left].name == Pintar_Nodos[i]){
                                    document.getElementById(Pintar_Nodos[i]+"1").style.color ="#FF00BF";
                                }
                                for (var rigth = 0; rigth < derecho_S.length; rigth++){
                                    document.getElementById(derecho_S[rigth].name +"2").style.color ="#FF00BF";
                                    document.getElementById(derecho_S[rigth].name +"2").style.fontSize = "large";
                                }
                            }
                            for (var left = 0; left < izquierdo_Merge.length; left++){
                                document.getElementById("Mergers").checked = true;
                                document.getElementById(izquierdo_Merge[left].name +"1").style.color ="#FF9100";
                                document.getElementById(izquierdo_Merge[left].name +"1").style.fontSize = "large";
                                for (var rigth = 0; rigth < derecho_Merge.length; rigth++){
                                    document.getElementById(derecho_Merge[left].name +"2").style.color ="#FF9100";
                                    document.getElementById(derecho_Merge[left].name +"2").style.fontSize = "large";
                                }
                            }
                            document.getElementById(Pintar_Nodos[i]+"1").style.fontSize = "large";
                        }
                        Click = true;
                     }
                });
            //add arrows if it is a folder
            entered.append("span").style("font-size", "20px").attr("class", function (d) {

                var icon = d.children ? "glyphicon glyphicon-minus" // put the minus to the father node
                    : d._children ? "glyphicon glyphicon-minus" : "";
                return "caret glyphicon" + icon;//put the minus to the children nodes
            });
            entered.append("span").attr("class", "zoomTarget filename")
                .attr("id",function (d) { return d.name+"1"; })
                .html(function (d) { 
                    var nombre = "";
                    if (d.children == undefined){
                        nombre = "― "+d.name;
                    }
                    else{
                        nombre = d.name;
                    }
                    return nombre; });

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
                nodes.shift();
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
                     /*if (d.children == null){
                        x = d.x;
                        y = d.y-10; 
                         document.getElementById("CanvasLineasTenues2").innerHTML += '<line x1="'+(x+10)+'" y1="'+y+'" x2="'+(x+18)+'" y2="'+y+'" style="stroke:rgb(0,0,0);stroke-width:0.2" />';

                    }*/
                    d.id = d.id || ++id;
                    return d.id;
                });
                for (var i = 0; i < nodesRight.length; i++){
                    if (nodesRight[i].children != null){
                        CalcularPosicionesLineasDerecha(i, nodesRight, Quantity_Nodes(nodesLeft));
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
                        tocado = true;
                        var processingInstance;
                        processingInstance = Processing.getInstanceById('CANVAS');
                        processingInstance.setup();
                        if (encendido){
                             resetTextFull();
                        }
                        resetText();
                        if (renames == true){
                            processingInstance.drawMoves(true,91,255,142,d.name,2);
                            var congruente = [];
                            var arregloderecha = processingInstance.returnRename_MovesRight();
                            for (var i = 0; i < arregloderecha.length; i++){
                                if (arregloderecha[i].name == d.name){
                                    congruente = arregloderecha[i].Synonym;
                                    document.getElementById(d.name+"2").style.color ="#5BFF8E";
                                    document.getElementById(d.name+"2").style.fontSize = "large";
                                }
                            }
                            if (congruente.length > 0){
                                for (var s = 0; s < congruente.length; s++){
                                    document.getElementById(congruente[s]+"1").style.color ="#5BFF8E";
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
                          else if (splits == false && exclusions == false && merges == false && renames == false && moves == false && congruencia == false){
                                //This section is to include the clickable nodes taxonomies with off switchers
                            resetTextFull();
                            nombres_Right = [];
                            for (var i = 0; i < nodesRight.length; i++){
                                document.getElementById(nodesRight[i].name+"2").style.fontSize = "small";
                                if (nodesRight[i].name == d.name){
                                    Save_Parents_Names_Right(nodesRight[i].children);
                                }
                            }
                            if (autoclick == false){
                                autoclick = true;
                                $('#'+d.name+"1").click();
                            }
                            else{
                                autoclick = false;
                            }
                            
                            document.getElementById(d.name+"2").style.fontSize = "large";
                            Pintar_Nodos = Retornar_Nommbres_Right();
                            Pintar_Nodos.push(d.name);
                            processingInstance.drawCongruency_Auxiliar(Pintar_Nodos,1);
                            processingInstance.drawMoves_Auxiliar(false,10,228,237,Pintar_Nodos,1,d.name);
                            processingInstance.drawSplits_Aux(0.5,Pintar_Nodos);
                            processingInstance.merge_Aux(Pintar_Nodos,1);
                            Nuevos_Aux();
                            var derecha_M = processingInstance.returnRename_MovesRight();
                            var izquierda_M = processingInstance.returnRename_MovesLeft();
                            var izquierda_C = processingInstance.retornarDerechosConguencia();
                            processingInstance.drawMoves_Auxiliar(true,91,255,142,Pintar_Nodos,1,d.name);
                            var izquierda_R = processingInstance.returnRename_MovesRight();
                            var derecha_S = processingInstance.returnSplitsRight();
                            var izquierda_S = processingInstance.returnSplitsLeft();
                            var izquierdo_Merge = processingInstance.returnIzquierdosMerge();
                            var derecho_Merge = processingInstance.returnDerechosMerge();
                            for (var i = 0; i < Pintar_Nodos.length; i++){
                                for (var right = 0; right < izquierda_C.length; right++){
                                     document.getElementById("Congruencia").checked = true;
                                    if (izquierda_C[right].nodo.name == Pintar_Nodos[i]){
                                        document.getElementById(Pintar_Nodos[i]+"2").style.color ="#1712C4";
                                    }
                                }
                                for (var right = 0; right < derecha_M.length; right++){
                                    document.getElementById("Moves").checked = true;
                                    if (derecha_M[right].name == Pintar_Nodos[i]){
                                        document.getElementById(Pintar_Nodos[i]+"2").style.color ="#0AE4ED";
                                        for (var left = 0; left < derecha_M.length; left++){
                                            document.getElementById(izquierda_M[left].name+"1").style.color ="#0AE4ED";
                                            document.getElementById(izquierda_M[left].name+"1").style.fontSize = "large";
                                        }
                                    }
                                }
                                for (var right = 0; right < izquierda_R.length; right++){
                                    document.getElementById("Renames").checked = true;
                                    if (izquierda_R[right].name == Pintar_Nodos[i]){
                                        document.getElementById(Pintar_Nodos[i]+"2").style.color ="#5BFF8E";
                                    }
                                }
                                for (var right = 0; right < arregloNuevos.length; right++){
                                    if (arregloNuevos[right].name == Pintar_Nodos[i]){
                                        document.getElementById("News").checked = true;
                                        document.getElementById(Pintar_Nodos[i]+"2").style.color ="#088A00";
                                    }
                                }
                                for (var right = 0; right < derecha_S.length; right++){
                                    document.getElementById("Splits").checked = true;
                                    document.getElementById(derecha_S[right].name +"2").style.color ="#FF00BF";
                                    document.getElementById(derecha_S[right].name +"2").style.fontSize = "large";
                                    for (var j  = 0 ; j < izquierda_S.length;j++){
                                        document.getElementById(izquierda_S[j].name +"1").style.color ="#FF00BF";
                                        document.getElementById(izquierda_S[j].name +"1").style.fontSize = "large";
                                    }
                                }
                                 for (var left = 0; left < izquierdo_Merge.length; left++){
                                        document.getElementById("Mergers").checked = true;
                                        document.getElementById(izquierdo_Merge[left].name +"1").style.color ="#FF9100";
                                        document.getElementById(izquierdo_Merge[left].name +"1").style.fontSize = "large";
                                        for (var rigth = 0; rigth < derecho_Merge.length; rigth++){
                                            document.getElementById(derecho_Merge[left].name +"2").style.color ="#FF9100";
                                            document.getElementById(derecho_Merge[left].name +"2").style.fontSize = "large";
                                        }
                                    }
                                document.getElementById(Pintar_Nodos[i]+"2").style.fontSize = "large";
                            }
                            Click = true; 
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
                .html(function (d) { var nombre = "";
                    if (d.children == undefined){
                        nombre = "― "+d.name;
                    }
                    else{
                        nombre = d.name;
                    }
                    return nombre; });

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