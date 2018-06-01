  
import processing.serial.*;

/////////////////////////////////////////definicion de las variables de uso general
boolean moves = false;
boolean renames = false;
boolean exclusions = false;
boolean news = false;
boolean congruency = false;

//Boolean variables for click nodes
boolean congruency_click = false;
boolean moves_click = false;
boolean renames_click = false;
boolean exclusions_click = false;
boolean splits_click = false;
boolean merges_click = false;
boolean merges_click_auxiliary = false;
//this arrays store the data of click nodes
Object [] ListaSeleccionados_Conguentres_I = []; //Almacena los nodos que se encuentran seleccionados en el momento de congruencia y izquierdo
Object [] ListaSeleccionados_Conguentres_D = []; //Almacena los nodos que se encuentran seleccionados en el momento de congruenciay derecho
Object [] ListaSeleccionados_Moves_I = [];//Almacena los nodos que se encuentran seleccionados en el momento de moves y izquierdo
Object [] ListaSeleccionados_Moves_D = [];//Almacena los nodos que se encuentran seleccionados en el momento de moves y derecho
Object [] ListaSeleccionados_Rename_I = [];//Almacena los nodos que se encuentran seleccionados en el momento de renames y izquierdo
Object [] ListaSeleccionados_Rename_D = [];//Almacena los nodos que se encuentran seleccionados en el momento de renames y derecho
Object [] ListaSeleccionados_Exclusiones = [];//Almacena los nodos que se encuentran seleccionados en el momento de exclusiones
Object [] ListaSeleccionados_Nuevos = [];//Almacena los nodos que se encuentran seleccionados en el momento de nuevos
Object [] ListaSeleccionados_Splits_I = [];//Almacena los nodos que se encuentran seleccionados en el momento de splits y izquierda
Object [] ListaSeleccionados_Splits_D = [];//Almacena los nodos que se encuentran seleccionados en el momento de splits y derecha

boolean moves_Second = false;
boolean renames_Second = false;
boolean news_Second = false;
boolean congruency_Second = false;
boolean splits_Second = false;
boolean merges_Second = false;

boolean splits = false;
boolean splitsAux = false;
boolean splitsAux2 = false;
boolean mergers = false;
boolean Final = false;
boolean inicio = true;
Node [] nodosIzquierdos;
Node [] nodosDerechos;
Node [] izquierdos_aux;
Object [] izquierdos;
Object [] derechos;
Merge []  Listamergers; // arreglo de bjetos de tipo merges un atributo nodo que tiene el nodo de la derecha y un atributo de lista de nombre de los de la izquierda
Move [] ListaMoves;
Move [] ListaRenames;
Split [] ListaSplits;
Node[] ListaSplitsA;
Node [] HistorialSplits = [];
Excl_News [] ListaExcluidos;
Excl_News [] ListaNuevos;
Node [] ListaCongruency1;
Node [] ListaGeneral = [];
float scaleFactor = 1.0;  //Cercanía que tiene la pantalla
float translateX = -100.0;   //Draw on X point
float translateY = 50.0;  //Draw on Y pointW
float incrX = 0;          //Increase this variable to moves the nodes, step size on X
float incrY = 0;          //Increase this variable to moves the nodes, step size on Y 
//This variables store the amount of each operation to show it in the page
int cantidadMoves;
int cantidadRenames;
int cantidadSplits;
int cantidadMerges;
int cantidadNews;
int cantidadExclusiones;
int catidadCongruentes;
Node nodo;
boolean one_by_one = false; //Flag on true move the nodes one by one, else move all at same time 
boolean animar = false;     //this variable is set true when the animation begin
boolean terminado = false;
//Name of the files loaded
String archivo1 = "";        
String archivo2 = "";

int posicionNuevos = 0;
int posicionExclusiones = 0;
int posicionCongruentes = 0;
int posicionMoves = 0;
int posicionRename = 0;
int posicionMerges = 0;
int posicionSplits = 0;

//This functions return the values of statistics to ScriptCarga.js
int returnCantidadMoves(){
  return cantidadMoves;
}

int returnCantidadRenames(){
  return cantidadRenames;
}

int returnCantidadSplits(){
  return cantidadSplits;
}

int returnCantidadMerges(){
  return cantidadMerges;
}

int returnCantidadNews(){
  return cantidadNews;
}

int returnCantidadExclusiones(){
  return cantidadExclusiones;
}

boolean returnTerminado(){
  return terminado;
}

boolean setTerminado(boolean valor){
  terminado = valor;
}

//This function Apply the value of the slider in javascript lo the variable of move
void setValueSlider(int valueSlider){
  if (valueSlider == 0){
  }
  else{
    incrX = abs(valueSlider);
    incrY = abs(valueSlider);
    incrX = incrX-(abs(valueSlider*0.5))
    incrY = incrY-(abs(valueSlider*0.5))
  }
}

//Begin the animation, called from (ScriptCarga.js)
void beginAnimation(){
 // inicio = true;
  if (merges_click || splits_click || renames_click || moves_click || exclusions_click || conguencyG || congruency_click || splitsG || mergersG || movesG || renamesG || exclusionsG || newsG){
    setup();
    animar = true;
    inicio = true;
    terminado = false;
  }
}

//Set one by one variable, called from Javascript (ScriptCarga.js)
void StopAnimation(){
  animar = false;
  inicio = false;
}

//Set one by one variable, called from Javascript (ScriptCarga.js)
void setValueOneByOne(boolean valor){
  //Setea el valo booleano
  one_by_one = valor;
}

//Set the names of the files, called from Javascript (ScriptCarga.js)
void setNames(name1,name2){
    archivo1 = name1;
    archivo2 = name2;
}

//Setup the variables and functions before begin the draw
void setup(){
  animar = false;
  inicio = false;
  terminado = true;
  congruency_click = false;
  moves_click = false;
  renames_click = false;
  exclusions_click = false;
  splits_click = false;
  merges_click = false;
  merges_click_auxiliary = false;

  moves_Second = false;
  renames_Second = false;
  news_Second = false;
  congruency_Second = false;
  splits_Second = false;

  posicionNuevos = 0;
  posicionExclusiones = 0;
  posicionCongruentes = 0;
  posicionMoves = 0;
  posicionRename = 0;
  posicionMerges = 0;
  posicionSplits = 0;
  mergers = false;
  moves = false;
  renames = false;
  news = false;
  congruency = false;
  splits = false;
  splitsAux = false;
  ListaSplitsA = false;
  exclusions = false;
  inicio = true;
  size (availableWidth,2000);
  Final = false;
  izquierdos = nodesLeft;
  derechos = nodesRight;
  nodosIzquierdos = new Node[izquierdos.length];
  izquierdos_aux =  new Node[izquierdos.length]
  nodosDerechos = new Node[derechos.length];
  smooth();
  //Here load the nodes
  loadNodes(izquierdos,true);
  loadNodes(derechos,false);
  News();
  Exclusiones();
  getMergers();
  Moves();
  Splits();
  Congruencia();
  posicionNuevos = 0;
}

//This function is executed all time, everything in this function is excuted all time.
void draw() {
  myFont = createFont("Times New Roman", 30);
  textFont(myFont);
  translate(translateX,translateY);
  scale(scaleFactor);
  background(255);
  pintarNodos(true);
  pintarNodos(false);
  textSize(22);
  fill(0);
  text(archivo1,300,-10);
  text(archivo2,900,-10);
  if (one_by_one){
    if (animar) {
        if (inicio){
            inicio = false;
            congruency = true;
        }
        if (mergers || (merges_click && merges)){
          if (mergersG || merges_click){
            boolean paro = false;
            if (Listamergers.length == 0){
               mergers = false;
               moves = true;
            }
              int [] posiciones = getPosicionesMergers();
              for (int i = 0; i < posiciones.length; i++){
                //for (int j = 0; j < Listamergers.length; j++){
                if (mergers == false){
                        break;
                      }
                   String [] nombres = Listamergers[posicionMerges].nodosMergeIzquierdos;
                   for (int k = 0; k < nombres.length; k++){
                      try{
                        if(nombres[k] == nodosIzquierdos[posiciones[i]].name){
                         nodosIzquierdos[posiciones[i]].move(Listamergers[posicionMerges].nodoMergeDerecho.x,Listamergers[posicionMerges].nodoMergeDerecho.y);
                         if (nodosIzquierdos[posiciones[i]].x >= Listamergers[posicionMerges].nodoMergeDerecho.x-10 && (nodosIzquierdos[posiciones[i]].y >= Listamergers[posicionMerges].nodoMergeDerecho.y-10 || nodosIzquierdos[posiciones[i]].y >= Listamergers[posicionMerges].nodoMergeDerecho.y+10)){
                            //removerNodos(posiciones);
                            int [] ListaEliminar = [];
                            for (int n = 0; n < nombres.length; n++){
                              for (int m = 0; m < nodosIzquierdos.length; m++){
                                 if (nombres[n] == nodosIzquierdos[m].name){
                                    append(ListaEliminar,m);
                                  }
                              }
                            }
                            removerNodos(ListaEliminar);
                            posicionMerges+=1;
                            if (posicionMerges == Listamergers.length){
                                mergers = false;
                                getMergers();
                                //merges_click = false;
                                moves = true;
                                paro = true;
                                break;
                            }
                          }
                      }
                    }
                    catch(e){
                      break;
                    }  
                      
                   }
                    if (paro){
                      break;
                    }
              }
          }
          else{
            mergers = false;
            moves = true;
          }
        }
        if (moves || (moves_click && moves)){
          if (movesG || moves_click){
              if (ListaMoves.length == 0){
                 moves = false;
                renames = true;
              }
              int [] posicionesMoves = getPosicionesMoves_Renames(ListaMoves);
              for (int i = 0; i < nodosIzquierdos.length; i++){
                  if (moves_click){
                    if (nodosIzquierdos[i].name == ListaSeleccionados_Moves_I[posicionMoves].name){
                      nodosIzquierdos[i].move(ListaSeleccionados_Moves_D[posicionMoves].x,ListaSeleccionados_Moves_D[posicionMoves].y);
                      if (nodosIzquierdos[i].x >= ListaSeleccionados_Moves_D[posicionMoves].x -6 && (nodosIzquierdos[i].y >= ListaSeleccionados_Moves_D[posicionMoves].y-6 || nodosIzquierdos[i].y >= ListaSeleccionados_Moves_D[posicionMoves].y+6)){
                        posicionMoves+=1;
                        removerNodos([i]);
                        if (posicionMoves == ListaSeleccionados_Moves_D.length){
                            moves = false;
                            //moves_click = false;
                            renames = true;
                            break;
                        }
                      }
                    }
                  }
                  else{
                      if (nodosIzquierdos[i].name == ListaMoves[posicionMoves].nodoIzquierdo.name){
                        nodosIzquierdos[i].move(ListaMoves[posicionMoves].nodoDerecho.x,ListaMoves[posicionMoves].nodoDerecho.y);
                        if (nodosIzquierdos[i].x >= ListaMoves[posicionMoves].nodoDerecho.x -6 && (nodosIzquierdos[i].y >= ListaMoves[posicionMoves].nodoDerecho.y-6 || nodosIzquierdos[i].y >= ListaMoves[posicionMoves].nodoDerecho.y+6)){
                          posicionMoves+=1;
                          removerNodos([i]);
                          if (posicionMoves == ListaMoves.length){
                              moves = false;
                              renames = true;
                              break;
                          }
                        }
                      }
                  }
              }
           }
           else{
              moves = false;
              //moves_click = false;
              renames = true;
           }
        }

        if (renames || (moves_click && moves)){
          if (renamesG || renames_click){
            if (ListaRenames.length == 0){
               renames = false;
               news = true;
            }

            int [] posicionesRenames = getPosicionesMoves_Renames(ListaRenames);
            for (int i = 0; i < nodosIzquierdos.length; i++){
              if (renames_click){
                if (nodosIzquierdos[i].name == ListaSeleccionados_Rename_I[posicionRename].name){
                  nodosIzquierdos[i].move(ListaSeleccionados_Rename_D[posicionRename].x,ListaSeleccionados_Rename_D[posicionRename].y);
                  if (nodosIzquierdos[i].x >= ListaSeleccionados_Rename_D[posicionRename].x-6 && (nodosIzquierdos[i].y >= ListaSeleccionados_Rename_D[posicionRename].y-6 || nodosIzquierdos[i].y >= ListaSeleccionados_Rename_D[posicionRename].y+6)){
                    posicionRename+=1;
                    removerNodos([i]);
                     if (posicionRename == ListaSeleccionados_Rename_D.length){
                        renames = false;
                        //renames_click = false;
                        news = true;
                        break;
                     }
                  }
                }
              }
              else{
                if (nodosIzquierdos[i].name == ListaRenames[posicionRename].nodoIzquierdo.name){
                  nodosIzquierdos[i].move(ListaRenames[posicionRename].nodoDerecho.x,ListaRenames[posicionRename].nodoDerecho.y);
                  if (nodosIzquierdos[i].x >= ListaRenames[posicionRename].nodoDerecho.x-6 && (nodosIzquierdos[i].y >= ListaRenames[posicionRename].nodoDerecho.y-6 || nodosIzquierdos[i].y >= ListaRenames[posicionRename].nodoDerecho.y+6)){
                    posicionRename+=1;
                    removerNodos([i]);
                     if (posicionRename == ListaRenames.length){
                        renames = false;
                        news = true;
                        break;
                     }
                  }
                }
              }
            }
          }
          else{
            renames = false;
            //renames_click = false;
            news = true;
          }
        }
        if (news){
          if (newsG){
            if (ListaNuevos.length == 0){
               news = false;
              exclusions = true;
            }
            
              for (int j = 0; j < nodosDerechos.length; j++){
                if ( ListaNuevos[posicionNuevos].nodoDerecha.name == nodosDerechos[j].name){
                    ListaNuevos[posicionNuevos].nodoDerecha.move(nodosDerechos[j].x,nodosDerechos[j].y);
                    if (ListaNuevos[posicionNuevos].nodoDerecha.x >= nodosDerechos[j].x-10){
                      posicionNuevos+=1;
                      if (posicionNuevos == ListaNuevos.length){
                         news = false;
                         exclusions = true;
                         break;
                      }
                    }
                }
              }
          }
          else{
            news = false;
            exclusions = true;
          }
        }
        if (exclusions || (exclusions_click && exclusions)){

          if (exclusionsG || exclusions_click){
            if (ListaExcluidos.length == 0){
              exclusions = false;
              terminado = true;
            }
            for (int i = 0; i < nodosIzquierdos.length; i++){
              if (exclusions_click){
                if (nodosIzquierdos[i].name == ListaSeleccionados_Exclusiones[posicionExclusiones].name){
                  nodosIzquierdos[i].move(600,nodosIzquierdos[i].y);
                  if (nodosIzquierdos[i].x >= 600){
                    posicionExclusiones+=1;
                    removerNodos([i]);
                    if (posicionExclusiones == ListaSeleccionados_Exclusiones.length){
                      exclusions = false;
                      exclusions_click = false;
                      terminado = true;
                      break;
                    }
                  }
                }
              }
              else{
                if (nodosIzquierdos[i].name == ListaExcluidos[posicionExclusiones].nombre){
                  nodosIzquierdos[i].move(600,nodosIzquierdos[i].y);
                  if (nodosIzquierdos[i].x >= 600){
                    posicionExclusiones+=1;
                    removerNodos([i]);
                    if (posicionExclusiones == ListaExcluidos.length){
                      exclusions = false;
                      exclusions_click = false;
                      terminado = true;
                      //cAMBIA LA IMAGEN DEL BOTON DE PLAY POR EL SIMBOLO DE PLAY
                      resetPlayButtom();
                      break;
                    }
                  }
                }
              }
            }
          }
         else{
           exclusions = false;
           terminado = true;
           //cAMBIA LA IMAGEN DEL BOTON DE PLAY POR EL SIMBOLO DE PLAY
           resetPlayButtom();
         }
        }
        if (splits ||  (splits_click && splits)){
          if (splitsG || splits_click){
            if (ListaSplits.length == 0){
               splits = false;
               mergers = true;
            }
            for (int i = 0; i < nodosIzquierdos.length; i++){
                 if (nodosIzquierdos[i].name == ListaSplits[posicionSplits].NodoIzquierdo.name){
                  if (nodosIzquierdos[i].x <= ListaSplits[posicionSplits].NodoIzquierdo.x+200){
                    nodosIzquierdos[i].move(ListaSplits[posicionSplits].NodoIzquierdo.x+600,nodosIzquierdos[i].y);
                  }
                  else{
                    removerNodos([i]);
                    splits = false;
                    splitsAux = true;
                  }
                }
            }
          }
          else{
            splits = false;
            splitsAux = false;
            mergers = true;
          }
        }
        if (splitsAux){
          ListaSplitsA = [];
            Node [] Lista = ListaSplits[posicionSplits].NodosDerechos;
            for (int i = 0; i < Lista.length; i++){
              append(nodosIzquierdos,Lista[i]);
              append(ListaSplitsA,Lista[i]);
            }
          splitsAux = false;
          splitsAux2 = true;
        }
        if (splitsAux2){
          for (int i = 0; i < nodosIzquierdos.length; i++){
            for (int j = 0; j < nodosDerechos.length; j++){
              if (nodosIzquierdos[i].name == nodosDerechos[j].name){
                for (int n = 0; n < ListaSplitsA.length; n++){
                  if (nodosDerechos[j].name == ListaSplitsA[n].name){
                    nodosIzquierdos[i].move(nodosDerechos[j].x, nodosDerechos[j].y);
                    if (nodosIzquierdos[i].x >= nodosDerechos[j].x-6 ){
                      removerNodos(getPosicionesFinalesSplit());
                      splitsAux2 = false;
                      splits = true;
                      posicionSplits+=1;
                      if (posicionSplits == ListaSplits.length){
                        splits = false;
                        splitsAux = false;
                        Splits();
                        mergers = true;
                        break;
                      }
                      break;
                    }
                  }
                  if (splitsAux2 == false){
                    break;
                  }
                }
              }
               if (splitsAux2 == false){
                  break;
              }
            }
          }
        }
        if (congruency || (congruency_click && congruency)){
          if (conguencyG || congruency_click){
              if (ListaCongruency1.length == 0){
                congruency = false;
                splits = true;
              }
              boolean eliminar = false;
              for (int i = 0; i < nodosIzquierdos.length; i++){
                if (congruency_click){
                  if (ListaSeleccionados_Conguentres_D[posicionCongruentes].name == nodosIzquierdos[i].name){
                    nodosIzquierdos[i].move(ListaSeleccionados_Conguentres_D[posicionCongruentes].x,ListaSeleccionados_Conguentres_D[posicionCongruentes].y);
                    if (nodosIzquierdos[i].x >= ListaSeleccionados_Conguentres_D[posicionCongruentes].x-6 && (nodosIzquierdos[i].y >= ListaSeleccionados_Conguentres_D[posicionCongruentes].y-6 || nodosIzquierdos[i].y >= ListaSeleccionados_Conguentres_D[posicionCongruentes].y+6)){
                      posicionCongruentes+=1;
                      removerNodos([i]);
                      if (posicionCongruentes == ListaSeleccionados_Conguentres_D.length){
                        congruency = false;
                        //congruency_click = false;
                        splits = true;
                        break;
                      }
                    }
                  }
                  posicionesCongruency = [];
                } 
                else{
                  if (ListaCongruency1[posicionCongruentes].name == nodosIzquierdos[i].name){
                      nodosIzquierdos[i].move(ListaCongruency1[posicionCongruentes].x,ListaCongruency1[posicionCongruentes].y);
                      if (nodosIzquierdos[i].x >= ListaCongruency1[posicionCongruentes].x-6 && (nodosIzquierdos[i].y >= ListaCongruency1[posicionCongruentes].y-6 || nodosIzquierdos[i].y >= ListaCongruency1[posicionCongruentes].y+6)){
                        posicionCongruentes+=1;
                        removerNodos([i]);
                        if (posicionCongruentes == ListaCongruency1.length){
                          congruency = false;
                          //congruency_click = false;
                          splits = true;
                          break;
                        }
                      }
                    }
                    posicionesCongruency = [];
                }
              }
            }
          else{
            congruency = false;
            //congruency_click = false;
            splits = true;
          }
        }
    }
  }
  else{
    if (animar){
        if (inicio){
          inicio = false;
          congruency = true;
        }
        if (mergers || (merges_click && merges)){
          if (mergersG || merges_click){
            merges_Second = true;
            if (Listamergers.length == 0){
               mergers = false;
               moves = true;
            }
              int [] posiciones = getPosicionesMergers();
              for (int i = 0; i < posiciones.length; i++){
                for (int j = 0; j < Listamergers.length; j++){
                   String [] nombres = Listamergers[j].nodosMergeIzquierdos;
                   for (int k = 0; k < nombres.length; k++){
                      if (mergers == false){
                        break;
                      }
                      if(nombres[k] == nodosIzquierdos[posiciones[i]].name){
                         nodosIzquierdos[posiciones[i]].move(Listamergers[j].nodoMergeDerecho.x,Listamergers[j].nodoMergeDerecho.y);
                         if (nodosIzquierdos[posiciones[i]].x >= Listamergers[j].nodoMergeDerecho.x-10 && (nodosIzquierdos[posiciones[i]].y >= Listamergers[j].nodoMergeDerecho.y-10 || nodosIzquierdos[posiciones[i]].y >= Listamergers[j].nodoMergeDerecho.y+10)){
                           removerNodos(posiciones);
                           mergers = false;
                           //merges_click = false;
                           moves = true;
                           getMergers();
                           break;
                          }
                      }
                   }
                }
              }
          }
          else{
            mergers = false;
            merges_click = false;
            getMergers();
            moves = true;
          }
        }
        if (moves || (moves_click && moves)){
          if (movesG || moves_click){
              moves_Second = true;
              if (ListaMoves.length == 0){
                 moves = false;
                renames = true;
              }
              int [] posicionesMoves = getPosicionesMoves_Renames(ListaMoves);
              for (int i = 0; i < nodosIzquierdos.length; i++){
                if (moves_click){
                  for (j = 0; j < ListaSeleccionados_Moves_I.length; j++){
                    if (nodosIzquierdos[i].name == ListaSeleccionados_Moves_I[j].name){
                      nodosIzquierdos[i].move(ListaSeleccionados_Moves_D[j].x,ListaSeleccionados_Moves_D[j].y);
                      if (nodosIzquierdos[i].x >= ListaSeleccionados_Moves_D[j].x -6 && (nodosIzquierdos[i].y >= ListaSeleccionados_Moves_D[j].y-6 || nodosIzquierdos[i].y >= ListaSeleccionados_Moves_D[j].y+6)){
                        removerNodos(posicionesMoves);
                        moves = false;
                        //moves_click = false;
                        renames = true;
                      }
                    }
                  }
                }
                else{
                  for (j = 0; j < ListaMoves.length; j++){
                    if (nodosIzquierdos[i].name == ListaMoves[j].nodoIzquierdo.name){
                      nodosIzquierdos[i].move(ListaMoves[j].nodoDerecho.x,ListaMoves[j].nodoDerecho.y);
                      if (nodosIzquierdos[i].x >= ListaMoves[j].nodoDerecho.x -6 && (nodosIzquierdos[i].y >= ListaMoves[j].nodoDerecho.y-6 || nodosIzquierdos[i].y >= ListaMoves[j].nodoDerecho.y+6)){
                        removerNodos(posicionesMoves);
                        moves = false;
                        //moves_click = false;
                        renames = true;
                      }
                    }
                  }
                }             
              }
           }
           else{
              moves = false;
              renames = true;
           }
        }
        if (renames || (renames_click && renames)){
          if (renamesG || renames_click){
            renames_Second = true;
            if (ListaRenames.length == 0){
               renames = false;
               news = true;
            }
            int [] posicionesRenames = getPosicionesMoves_Renames(ListaRenames);
            for (int i = 0; i < nodosIzquierdos.length; i++){
              if (renames_click){
                 for (j = 0; j < ListaSeleccionados_Rename_I.length; j++){
                  if (nodosIzquierdos[i].name == ListaSeleccionados_Rename_I[j].name){
                    nodosIzquierdos[i].move(ListaSeleccionados_Rename_D[j].x,ListaSeleccionados_Rename_D[j].y);
                    if (nodosIzquierdos[i].x >= ListaSeleccionados_Rename_D[j].x-6 && (nodosIzquierdos[i].y >= ListaSeleccionados_Rename_D[j].y-6 || nodosIzquierdos[i].y >= ListaSeleccionados_Rename_D[j].y+6)){
                      removerNodos(posicionesRenames);
                      renames = false;
                      //renames_click = false;
                      news = true;
                    }
                  }
                }
              }
              else{
                for (j = 0; j < ListaRenames.length; j++){
                  if (nodosIzquierdos[i].name == ListaRenames[j].nodoIzquierdo.name){
                    nodosIzquierdos[i].move(ListaRenames[j].nodoDerecho.x,ListaRenames[j].nodoDerecho.y);
                    if (nodosIzquierdos[i].x >= ListaRenames[j].nodoDerecho.x-6 && (nodosIzquierdos[i].y >= ListaRenames[j].nodoDerecho.y-6 || nodosIzquierdos[i].y >= ListaRenames[j].nodoDerecho.y+6)){
                      removerNodos(posicionesRenames);
                      renames = false;
                      news = true;
                    }
                  }
                }
              }
            }
          }
          else{
            renames = false;
            //renames_click = false;
            news = true;
          }
        }
        if (news){
          if (newsG){
            news_Second = true;
            if (ListaNuevos.length == 0){
               news = false;
              exclusions = true;
            }
            for (int i = 0; i < ListaNuevos.length; i++){
              for (int j = 0; j < nodosDerechos.length; j++){
                if ( ListaNuevos[i].nodoDerecha.name == nodosDerechos[j].name){
                    ListaNuevos[i].nodoDerecha.move(nodosDerechos[j].x,nodosDerechos[j].y);
                    if (ListaNuevos[i].nodoDerecha.x >= nodosDerechos[j].x-10){
                      news = false;
                      exclusions = true;
                    }
                }
              }
            }
          }
          else{
            news = false;
            exclusions = true;
          }
        }
        if (exclusions || (exclusions && exclusions_click)){
          if (exclusionsG || exclusions_click){
            if (ListaExcluidos.length == 0){
              exclusions = false;
              terminado = true;
            }
            for (int i = 0; i < nodosIzquierdos.length; i++){
              if (exclusions_click){
                for (int j = 0; j < ListaSeleccionados_Exclusiones.length; j++){
                  if (nodosIzquierdos[i].name == ListaSeleccionados_Exclusiones[j].name){
                    nodosIzquierdos[i].move(600,nodosIzquierdos[i].y);
                    if (nodosIzquierdos[i].x >= 600){
                      removerNodos(getPosicionesExclusion());
                      exclusions = false;
                      exclusions_click = false;
                      terminado = true;
                      break;
                    }
                  }
                }
              }
              else{
                for (int j = 0; j < ListaExcluidos.length; j++){
                  if (nodosIzquierdos[i].name == ListaExcluidos[j].nombre){
                    nodosIzquierdos[i].move(600,nodosIzquierdos[i].y);
                    if (nodosIzquierdos[i].x >= 600){
                      removerNodos(getPosicionesExclusion());
                      exclusions = false;
                      exclusions_click = false;
                      terminado = true;
                      //cAMBIA LA IMAGEN DEL BOTON DE PLAY POR EL SIMBOLO DE PLAY
                      resetPlayButtom();
                      break;
                    }
                  }
                }
              }
            }
          }
         else{
           exclusions = false;
           exclusions_click = false;
           terminado = true;
           //cAMBIA LA IMAGEN DEL BOTON DE PLAY POR EL SIMBOLO DE PLAY
           resetPlayButtom();
         }
        }
        if (splits || (splits_click && splits)){
          if (splitsG || splits_click){
            splits_Second = true;
            if (ListaSplits.length == 0){
               splits = false;
                splitsAux = true;
            }
            for (int i = 0; i < nodosIzquierdos.length; i++){
             for (int j = 0; j < ListaSplits.length; j++){
                 if (nodosIzquierdos[i].name == ListaSplits[j].NodoIzquierdo.name){
                  if (nodosIzquierdos[i].x <= ListaSplits[j].NodoIzquierdo.x+200){
                    nodosIzquierdos[i].move(ListaSplits[j].NodoIzquierdo.x+600,nodosIzquierdos[i].y);
                  }
                  else{
                    removerNodos(getPosicionesSplits());
                    splits = false;
                    splitsAux = true;
                    break;
                  }
                }
             }
            }
          }
          else{
            splits = false;
            mergers = true;
          }
        }
        if (splitsAux){
          ListaSplitsA = [];
          for (int j = 0; j < ListaSplits.length; j++){
            Node [] Lista = ListaSplits[j].NodosDerechos;
            for (int i = 0; i < Lista.length; i++){
              append(nodosIzquierdos,Lista[i]);
              append(ListaSplitsA,Lista[i]);
            }
          }
          splitsAux = false;
          splitsAux2 = true;
        }
        if (splitsAux2){
          for (int i = 0; i < nodosIzquierdos.length; i++){
            for (int j = 0; j < nodosDerechos.length; j++){
              if (nodosIzquierdos[i].name == nodosDerechos[j].name){
                for (int n = 0; n < ListaSplitsA.length; n++){
                  if (nodosDerechos[j].name == ListaSplitsA[n].name){
                    nodosIzquierdos[i].move(nodosDerechos[j].x, nodosDerechos[j].y);
                    if (nodosIzquierdos[i].x >= nodosDerechos[j].x-6 ){
                      removerNodos(getPosicionesFinalesSplit());
                      splitsAux2 = false;
                      mergers = true;
                      Splits();
                      //splits_click = false;
                      break;
                    }
                  }
                  if (splitsAux2 == false){
                    break;
                  }
                }
              }
               if (splitsAux2 == false){
                  break;
              }
            }
          }
        }
        if (congruency || (congruency_click && congruency)){
          if (conguencyG || congruency_click){
            congruency_Second = true;
              if (ListaCongruency1.length == 0){
                congruency = false;
                splits = true;
              }
              boolean eliminar = false;
              for (int i = 0; i < nodosIzquierdos.length; i++){
                if (congruency_click){
                  for (int j = 0; j < ListaSeleccionados_Conguentres_D.length; j++){
                    if (ListaSeleccionados_Conguentres_D[j].name == nodosIzquierdos[i].name){
                      nodosIzquierdos[i].move(ListaSeleccionados_Conguentres_D[j].x,ListaSeleccionados_Conguentres_D[j].y);
                      if (nodosIzquierdos[i].x >= ListaSeleccionados_Conguentres_D[j].x-6 && (nodosIzquierdos[i].y >= ListaSeleccionados_Conguentres_D[j].y-6 || nodosIzquierdos[i].y >= ListaSeleccionados_Conguentres_D[j].y+6)){
                        eliminar = true;
                      }
                    }
                  }
                }
                else{
                  for (int j = 0; j < ListaCongruency1.length; j++){
                    if (ListaCongruency1[j].name == nodosIzquierdos[i].name){
                      nodosIzquierdos[i].move(ListaCongruency1[j].x,ListaCongruency1[j].y);
                      if (nodosIzquierdos[i].x >= ListaCongruency1[j].x-6 && (nodosIzquierdos[i].y >= ListaCongruency1[j].y-6 || nodosIzquierdos[i].y >= ListaCongruency1[j].y+6)){
                        eliminar = true;
                      }
                    }
                  }
                }
                if (eliminar){
                  if (congruency_click){
                    removerNodos(getposicionesCongruengy(true));
                  }
                  else{
                    removerNodos(getposicionesCongruengy(false));
                  }
                  congruency = false;
                  //congruency_click = false;
                  splits = true;
                  break;
                }
                posicionesCongruency = [];
              }
            }
          else{
            congruency = false;
            //congruency_click = false;
            splits = true;
          }
        }
      }
    }
}

void mouseClicked() {
  setup();
  //Clean the variables that have the selected nodess
  ListaSeleccionados_Conguentres_I = [];
  ListaSeleccionados_Conguentres_D = [];
  ListaSeleccionados_Moves_I = [];
  ListaSeleccionados_Moves_D = [];
  ListaSeleccionados_Exclusiones = [];
  ListaSeleccionados_Rename_I = [];
  ListaSeleccionados_Rename_D = [];
  autoClickNuevos_OFF();
  autoClickCongruence_OFF();
  autoClickSplits_OFF();
  autoClickMerges_OFF();
  autoClickMoves_OFF();
  autoClickRenames_OFF();
  autoClickExclusion_OFF();
  autoClickAll_OFF();
  mergers = false;
  moves = false;
  renames = false;
  news = false;
  congruency = false;
  splits = false;
  splitsAux = false;
  exclusions = false;
  int y = (mouseY - translateY) * (1/scaleFactor);
  int x = (mouseX - translateX) * (1/scaleFactor);
  Calcular_Nodo_Seleccionado(x,y); 
}

//Verify wich nodes are selected
void Calcular_Nodo_Seleccionado(x, y){
  congruency_click = false;
  int offsetX = 300;
  int offsetY = 20;
  for (int i = 1; i < nodosIzquierdos.length; i++){
    if ((y <= nodosIzquierdos[i].y && y >= nodosIzquierdos[i].y-25) && (x > nodosIzquierdos[i].x && x < (nodosIzquierdos[i].x + textWidth(nodosIzquierdos[i].name)))){
      Congruencia_Selected(nodosIzquierdos[i].name);
      Moves_Selected(nodosIzquierdos[i].name);
      Exclusiones_Selected(nodosIzquierdos[i].name);
      Splits_Selected(nodosIzquierdos[i].name);
      getMergers_Selected(nodosIzquierdos[i].name);
      return;
    }
  }
  setup();

}



//Zoom in / zoom out and reset
void keyPressed() {
  if (key == 'r' || key == 'R') {
    scaleFactor = 1;
    translateX = -100.0;
    translateY = 50.0;
  }
  if (key == 'i' || key == 'I'){
    scaleFactor += 0.03;
    //translateX -= mouseX-150;
    //translateY -= mouseY-150;
  }
   if (key == 'o' || key == 'O'){
    if (scaleFactor > 0.06999999999999937){
      scaleFactor -= 0.03;
      //translateX -= mouseX-150;
      //translateY -= mouseY-150;
    }
  }
}

//Move the page according the mouse
void mouseDragged(MouseEvent e) {
  translateX += mouseX - pmouseX;
  translateY += mouseY - pmouseY;
}


////////////////////////////////AUXILIARY FUNCTIONS//////////////////////////////////////////////////////////
int [] getPosicionesMergers(){
  String [] nombre = [];
  int [] posiciones = [];
  for (int i = 0; i < Listamergers.length; i++){
    String [] arreglo = Listamergers[i].nodosMergeIzquierdos;
    for (int j = 0; j<arreglo.length; j++){
      append(nombre,arreglo[j]);
    }
  }
  for (int i = 0; i < nodosIzquierdos.length; i++){
    for (int j = 0; j < nombre.length; j++){
      if (nombre[j].equals(nodosIzquierdos[i].name)){
        append(posiciones,i);
      }
    }
  }
  return posiciones;
}

//Funcion para cargar los nodos al un arreglo de nodos
//si flag es true entonces cargar los izquierdos si es false carga los derechos
void loadNodes(nodos,flag){
  int y = round((availableHeight-40)/nodos.length)+5;
  for (int i = 0; i < nodos.length; i++){
    if (flag){
      if (i == 1){
        nodosIzquierdos[i] = new Node(nodos[i].name, nodos[i].x+300,y,nodos[i].Synonym,nodos[i].author, nodos[i].record_scrutiny_date);
        izquierdos_aux[i] = new Node(nodos[i].name, nodos[i].x+300,y,nodos[i].Synonym,nodos[i].author, nodos[i].record_scrutiny_date);
        y += round((availableHeight-40)/nodos.length)+5;
      }
      else{
        nodosIzquierdos[i] = new Node(nodos[i].name, nodos[i].x+300,y,nodos[i].Synonym,nodos[i].author, nodos[i].record_scrutiny_date);
        izquierdos_aux[i] = new Node(nodos[i].name,nodos[i].x+300,y,nodos[i].Synonym,nodos[i].author, nodos[i].record_scrutiny_date);
        y += round((availableHeight-40)/nodos.length)+5;
      }
      
    }
    else{
      nodosDerechos[i] = new Node(nodos[i].name, nodos[i].x+900,y,nodos[i].Synonym,nodos[i].author, nodos[i].record_scrutiny_date);
      y += round((availableHeight-40)/nodos.length)+5;
    }
  }
}


//Funcion que impririme los diferentes nodos creados
void pintarNodos(flag){
  if (flag){
     for (int i = 0; i < nodosIzquierdos.length; i++){
      fill(0);
      textSize(14); 
      if (mergers || merges_click){
        if (mergersG || merges_click){
            for (int m = 0; m < Listamergers.length; m++){
              if (one_by_one){
                if (m == posicionMerges){
                    String [] nodos = Listamergers[m].nodosMergeIzquierdos;
                    for (int s = 0; s < nodos.length; s++){
                      if (nodosIzquierdos[i].name == nodos[s]){
                        textSize(16); 
                        fill(255, 166, 86);
                      }
                    }
                }
                else{
                   String [] nodos = Listamergers[m].nodosMergeIzquierdos;
                    for (int s = 0; s < nodos.length; s++){
                      if (nodosIzquierdos[i].name == nodos[s]){
                        fill(255, 166, 86);
                      }
                    }
                }
              }
              else{
                String [] nodos = Listamergers[m].nodosMergeIzquierdos;
                for (int s = 0; s < nodos.length; s++){
                  if (nodosIzquierdos[i].name == nodos[s]){
                    textSize(16); 
                    fill(255, 166, 86);
                  }
                }
              }
            }
        }
      }
      if (moves || moves_click){
        if (moves_click){
          for (int m = 0; m < ListaSeleccionados_Moves_I.length; m++){
            if (one_by_one){
              if (ListaSeleccionados_Moves_I[m].name == nodosIzquierdos[i].name && m == posicionMoves){
                  textSize(16); 
                  fill(9, 212, 212);
              }
              else if (ListaSeleccionados_Moves_I[m].name == nodosIzquierdos[i].name){
                fill(9, 212, 212);
              }
            }
            else{
              if (ListaSeleccionados_Moves_I[m].name == nodosIzquierdos[i].name){
                textSize(16); 
                fill(9, 212, 212);
              }
            }
          }
        }
        else{
          for (int m = 0; m < ListaMoves.length; m++){
            if (one_by_one){
              if (ListaMoves[m].nodoIzquierdo.name == nodosIzquierdos[i].name && m == posicionMoves){
                  textSize(16); 
                  fill(9, 212, 212);
              }
              else if (ListaMoves[m].nodoIzquierdo.name == nodosIzquierdos[i].name){
                fill(9, 212, 212);
              }
            }
            else{
              if (ListaMoves[m].nodoIzquierdo.name == nodosIzquierdos[i].name){
                textSize(16); 
                fill(9, 212, 212);
              }
            }
          }
        }
         
      }
      if (renames || renames_click){
        if (renames_click){
          for (int m = 0; m < ListaSeleccionados_Rename_I.length; m++){
           if (one_by_one){
              if (ListaSeleccionados_Rename_I[m].name == nodosIzquierdos[i].name && m == posicionRename){
                textSize(16); 
                fill(234, 170, 165);
               }
               else if (ListaSeleccionados_Rename_I[m].name == nodosIzquierdos[i].name){
                fill(234, 170, 165);
              }
           }
           else{
            if (ListaSeleccionados_Rename_I[m].name == nodosIzquierdos[i].name){
                textSize(16); 
                fill(234, 170, 165);
               }
           }
         }
        }
        else{
          for (int m = 0; m < ListaRenames.length; m++){
           if (one_by_one){
              if (ListaRenames[m].nodoIzquierdo.name == nodosIzquierdos[i].name && m == posicionRename){
                textSize(16); 
                fill(234, 170, 165);
               }
               else if (ListaRenames[m].nodoIzquierdo.name == nodosIzquierdos[i].name){
                fill(234, 170, 165);
              }
           }
           else{
            if (ListaRenames[m].nodoIzquierdo.name == nodosIzquierdos[i].name){
                textSize(16); 
                fill(234, 170, 165);
               }
           }
         }
        }
      }
      if (exclusions || exclusions_click){
        if (exclusions_click){
          for (int m = 0; m < ListaSeleccionados_Exclusiones.length; m++){
            if (one_by_one){
              if (ListaSeleccionados_Exclusiones[m].name == nodosIzquierdos[i].name && m == posicionExclusiones){
                textSize(16); 
                fill(208, 1, 1);
              }
              else if (ListaSeleccionados_Exclusiones[m].name == nodosIzquierdos[i].name){
                fill(208, 1, 1);
              }
            }
            else{
              if (ListaSeleccionados_Exclusiones[m].name == nodosIzquierdos[i].name){
                textSize(16); 
                fill(208, 1, 1);
              }
            }
          }
        }
        else{
          for (int m = 0; m < ListaExcluidos.length; m++){
            if (one_by_one){
              if (ListaExcluidos[m].nombre == nodosIzquierdos[i].name && m == posicionExclusiones){
                textSize(16); 
                fill(208, 1, 1);
              }
              else if (ListaExcluidos[m].nombre == nodosIzquierdos[i].name){
                fill(208, 1, 1);
              }
            }
            else{
              if (ListaExcluidos[m].nombre == nodosIzquierdos[i].name){
                textSize(16); 
                fill(208, 1, 1);
              }
            }
          }
        }
        
      }
      if (congruency || congruency_click){
        if (congruency_click){
          for (int m = 0; m < ListaSeleccionados_Conguentres_D.length; m++){
            if (one_by_one){
              if (ListaSeleccionados_Conguentres_D[m].name == nodosIzquierdos[i].name && posicionCongruentes == m){
                  textSize(16); 
                  fill(14,80,217);
              }
              else if(ListaSeleccionados_Conguentres_D[m].name == nodosIzquierdos[i].name){ 
                fill(14,80,217);
              }
            }
            else{
              if (ListaSeleccionados_Conguentres_D[m].name == nodosIzquierdos[i].name){
                  textSize(16); 
                  fill(14,80,217);
                }
            }
          }
        }
        else{
          for (int m = 0; m < ListaCongruency1.length; m++){
            if (one_by_one){
              if (ListaCongruency1[m].name == nodosIzquierdos[i].name && posicionCongruentes == m){
                  textSize(16); 
                  fill(14,80,217);
              }
              else if(ListaCongruency1[m].name == nodosIzquierdos[i].name){ 
                fill(14,80,217);
              }
            }
            else{
              if (ListaCongruency1[m].name == nodosIzquierdos[i].name){
                  textSize(16); 
                  fill(14,80,217);
                }
            }
          }
        }
      }
      if (splits || splits_click){
        if (splitsG || splits_click){
          for (int m = 0; m < ListaSplits.length; m++){
            if (one_by_one){
              if (ListaSplits[m].NodoIzquierdo.name == nodosIzquierdos[i].name && m == posicionSplits){
                textSize(16); 
                fill(255,13,255);
               }
               else if (ListaSplits[m].NodoIzquierdo.name == nodosIzquierdos[i].name){
                fill(255,13,255);
               }
            }
            else{
              if (ListaSplits[m].NodoIzquierdo.name == nodosIzquierdos[i].name){
                textSize(16); 
                fill(255,13,255);
               }
            }
           }
        }
      }
      if (splitsAux2){
        for (int m = 0; m < ListaSplitsA.length; m++){
          if (ListaSplitsA[m].name == nodosIzquierdos[i].name){
             textSize(16); 
             fill(255,13,255);
          }
        }
        for (int m = 0; m < ListaSplits.length; m++){
            if (one_by_one){
              if (ListaSplits[m].NodoIzquierdo.name == nodosIzquierdos[i].name){
                fill(255,13,255);
              }
            }
          }
      }
      nodosIzquierdos[i].display();
      for (int r = 1; r < izquierdos_aux.length; r++){
        if (nodosIzquierdos[i].name == izquierdos_aux[r].name && nodosIzquierdos[i].x > izquierdos_aux[r].x){
            izquierdos_aux[r].display();
            break;
        }
      }
    }
     for (int r = 1; r < izquierdos_aux.length; r++){
        boolean esta = false;
        for (int m = 1; m < nodosIzquierdos.length; m++){
            if (nodosIzquierdos[m].name == izquierdos_aux[r].name){
              esta = true;
            }
        }
        if (esta == false){
          textSize(12);
           fill(124,122,122);
           izquierdos_aux[r].display();
        }
      }
  }
  else{
     for (int i = 0; i < nodosDerechos.length; i++){
      textSize(14); 
      fill(124,122,122);
      if (mergers || merges_Second || merges_click || merges_click_auxiliary){
        if (mergersG || merges_click){
          for (int m = 0; m < Listamergers.length; m++){
            if (one_by_one){
              if (Listamergers[m].nodoMergeDerecho.name == nodosDerechos[i].name && m < posicionMerges){ 
                fill(255, 166, 86);
              }
            }
            else{
              if (Listamergers[m].nodoMergeDerecho.name == nodosDerechos[i].name){ 
                fill(255, 166, 86);
              }
            }
          }
        }
      }
      if (moves || moves_Second || moves_click){
        if (moves_click){
          for (int m = 0; m < ListaSeleccionados_Moves_D.length; m++){
            if (one_by_one){
              if (ListaSeleccionados_Moves_D[m].name == nodosDerechos[i].name && m < posicionMoves){ 
                fill(9, 212, 212);
               }
            }
            else{
              if (ListaSeleccionados_Moves_D[m].name == nodosDerechos[i].name){ 
                fill(9, 212, 212);
               }
            }
          }
        }
        else{
          for (int m = 0; m < ListaMoves.length; m++){
            if (one_by_one){
              if (ListaMoves[m].nodoDerecho.name == nodosDerechos[i].name && m < posicionMoves){ 
                fill(9, 212, 212);
               }
            }
            else{
              if (ListaMoves[m].nodoDerecho.name == nodosDerechos[i].name){ 
                fill(9, 212, 212);
               }
            }
           }
        }  
      }
      if (renames || renames_Second || renames_click){
        if (renames_click){
           for (int m = 0; m < ListaSeleccionados_Rename_D.length; m++){
            if (one_by_one){
                if (ListaSeleccionados_Rename_D[m].name == nodosDerechos[i].name && m < posicionRename){
                  fill(234, 170, 165);
                }
              }
              else{
                 if (ListaSeleccionados_Rename_D[m].name == nodosDerechos[i].name){
                  fill(234, 170, 165);
                }
              }
           }
        }
        else{
           for (int m = 0; m < ListaRenames.length; m++){
            if (one_by_one){
                if (ListaRenames[m].nodoDerecho.name == nodosDerechos[i].name && m < posicionRename){
                  fill(234, 170, 165);
                }
              }
              else{
                 if (ListaRenames[m].nodoDerecho.name == nodosDerechos[i].name){
                  fill(234, 170, 165);
                }
              }
           }
        }
      }
      if (news || news_Second){
         for (int m = 0; m < ListaNuevos.length; m++){
          if (one_by_one){
            if (ListaNuevos[m].nodoDerecha.name == nodosDerechos[i].name && m < posicionNuevos){
              fill(7, 101, 0);
            }
          }
          else{
            if (ListaNuevos[m].nodoDerecha.name == nodosDerechos[i].name){
              fill(7, 101, 0);
            }
          } 
        }
      }
      if (congruency || congruency_Second || congruency_click){
        if (congruency_click){
          for (int m = 0; m < ListaSeleccionados_Conguentres_D.length; m++){
            if (one_by_one){
              if (ListaSeleccionados_Conguentres_D[m].name == nodosDerechos[i].name && m < posicionCongruentes){
                  //textSize(20); 
                  fill(14,80,217);
                }
            }
            else{
              if (ListaSeleccionados_Conguentres_D[m].name == nodosDerechos[i].name){
               // textSize(20); 
                fill(14,80,217);
              }
            }
          }
        }
        else{
          for (int m = 0; m < ListaCongruency1.length; m++){
            if (one_by_one){
              if (ListaCongruency1[m].name == nodosDerechos[i].name && m < posicionCongruentes){
                  //textSize(20); 
                  fill(14,80,217);
                }
            }
            else{
              if (ListaCongruency1[m].name == nodosDerechos[i].name){
               // textSize(20); 
                fill(14,80,217);
              }
            }
          }
        }
      }
      if (splits || splits_click){
        if (splitsG || splits_click){
          for (int m = 0; m < ListaSplits.length; m++){
            if (one_by_one){
              if (m < posicionSplits){
                Node [] lista = ListaSplits[m].NodosDerechos;
                for (int s = 0; s < lista.length; s++){
                  if (lista[s].name == nodosDerechos[i].name){
                     fill(255,13,255);
                  }
                }
              }
            }
          }
        }
      }
      if (splitsAux2 || splits_Second){
        for (int m = 0; m < ListaSplitsA.length; m++){
          if (one_by_one){
             if (ListaSplitsA[m].name == nodosDerechos[i].name){
                fill(255,13,255);
             }
          }
          else{
             if (ListaSplitsA[m].name == nodosDerechos[i].name){
              fill(255,13,255);
             }
          }
        }
        for (int m = 0; m < ListaSplits.length; m++){
            if (one_by_one){
              if (m < posicionSplits){
                Node [] lista = ListaSplits[m].NodosDerechos;
                for (int s = 0; s < lista.length; s++){
                  if (lista[s].name == nodosDerechos[i].name){
                     fill(255,13,255);
                  }
                }
              }
            }
          }
      }
      if (Final){
        fill(0);
      }

      nodosDerechos[i].display();
    }
  }
  if (news){
    for (int i = 0; i < ListaNuevos.length; i++){
      if (one_by_one){
        if (i == posicionNuevos){
          textSize(16); 
          fill(8,138,0);
          ListaNuevos[i].nodoDerecha.display();
        }
      }
      else{
          textSize(16); 
          fill(8,138,0);
          ListaNuevos[i].nodoDerecha.display();
      }
    }
  }
}


void removerNodos(int [] nodos){
    Node [] nodosAux;
    int cantidadLlevada = 0;
    int cantidad = nodosIzquierdos.length - nodos.length;
    nodosAux = new Node[cantidad];
    for (int i = 0; i < nodosIzquierdos.length; i++){
      boolean existe = false;
      for (int j = 0; j < nodos.length; j++){
          if (i == nodos[j]){
             existe = true;
             cantidadLlevada += 1;
          }
      }
      if (existe == false){
        nodosAux[i-cantidadLlevada] = new Node(nodosIzquierdos[i].name,nodosIzquierdos[i].x,nodosIzquierdos[i].y,nodosIzquierdos[i].Synonym,nodosIzquierdos[i].author,nodosIzquierdos[i].record_scrutiny_date);     
      }
    }
    nodosIzquierdos = nodosAux;
}

//Verify if exist an element in a String array
boolean existe_Elemento_Array(ele, arreglo){
  for (int i = 0; i < arreglo.length; i++){
    if (arreglo[i] == ele){
      return true;
    }
  }
  return false;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Funciones de mergers
int calcularCantidadNodos(){
    int cantidadMergers = 0;
    for (int nodeR = 0; nodeR < nodosDerechos.length; nodeR++){
       derecho = nodosDerechos[nodeR];
       String [] sinonimos = nodosDerechos[nodeR].Synonym;  
        int cont = 0;  
        if (sinonimos.length > 1){
             for (int nodeL = 0; nodeL < sinonimos.length;nodeL++){
                if (existeNombre_Complejo(sinonimos[nodeL],nodosDerechos[nodeR].author,nodosDerechos[nodeR].record_scrutiny_date)==false){
                    cont += 1;
                }
            }
            if (cont > 1){
              cantidadMergers += 1;
            }
            izquierdo = []; 
        } 
     }
     return cantidadMergers;
}

object [] izquierdo = [];
void getMergers(){
  cantidadMerges = 0;
  Listamergers = [];
  Listamergers = new Merge[calcularCantidadNodos()];
  int cantidadMergers = 0;
  for (int nodeR = 1; nodeR < nodosDerechos.length; nodeR++){
      derecho = nodosDerechos[nodeR];
      String [] sinonimos = nodosDerechos[nodeR].Synonym;  
      int cont = 0;  
      if (sinonimos.length > 1){
           for (int nodeL = 1; nodeL < sinonimos.length;nodeL++){
              if (existeNombre_Complejo(sinonimos[nodeL],nodosDerechos[nodeR].author,nodosDerechos[nodeR].record_scrutiny_date)==false){
                  cont += 1; 
              }
          }
          if (cont >= 1){
            cantidadMerges+=1;
            Node nodo = new Node(derecho.name, derecho.x, derecho.y);
            String [] izq = [];
            for (int s = 0; s < sinonimos.length; s++){
              append(izq,sinonimos[s]);
            }
            Listamergers[cantidadMergers] = new Merge(izq,nodo);
            append(ListaGeneral,nodo);
            cantidadMergers += 1;
          }
          izquierdo = []; 
      } 
   }
}

void getMergers_Selected(nombre){
  cantidadMerges = 0;
  int cantidadMergers = 0;
  Listamergers = [];
  String [] leftsNodes = [];
  for (int nodeR = 1; nodeR < nodosDerechos.length; nodeR++){
      derecho = nodosDerechos[nodeR];
      String [] sinonimos = nodosDerechos[nodeR].Synonym;  
      int cont = 0;  
      leftsNodes = [];
      if (sinonimos.length > 1){
           for (int nodeL = 0; nodeL < sinonimos.length;nodeL++){
              if (existeNombre_Complejo(sinonimos[nodeL],nodosDerechos[nodeR].author,nodosDerechos[nodeR].record_scrutiny_date)==false){
                  cont += 1; 
                  append(leftsNodes, sinonimos[nodeL]);
              }
          }
          if (cont >= 1){
            
            boolean subarbol = false;
            for (int s = 0; s < leftsNodes.length; s++){
              if (nombre == leftsNodes[s] || existe_Elemento_Array(nombre, buscar_padres(leftsNodes[s], izquierdos))){
                  subarbol = true;
                }
            }
            if (subarbol){
              //Javascript function to turn on the congruence slider (autoClickSlider.js)
              autoClickMerges_ON();
              merges_click = true;
              merges_click_auxiliary = true;
              cantidadMerges+=1;
              Node nodo = new Node(derecho.name, derecho.x, derecho.y);
              String [] izq = [];
              for (int s = 0; s < sinonimos.length; s++){
                append(izq,sinonimos[s]);
              }
              append(Listamergers,new Merge(izq,nodo));
              append(ListaGeneral,nodo);
              cantidadMergers += 1;
            }
            
          }
          izquierdo = []; 
      } 
   }
}

boolean existeNombre_Complejo(nombre,autor,date){
    Object [] izquierdos = nodesLeft;
    for (int nodeL = 0; nodeL < izquierdos.length; nodeL++) {
        if(izquierdos[nodeL].name == nombre){
            append(izquierdo,izquierdos[nodeL]);
            return false;
        }
    }
    return true;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//FUNCIONES DE MOVES
//This function is to get all the fathers of a species
//Use the buscar_padres function 
//Must be given a name of the species for which the parents wish to know
//So receive an array of nodes that is the complete taxonomy
String padres = [];
String [] buscar_padres(nombre,nodos){
    padres = [];
    for (int i = 0;i<nodos.length;i++){
        if (nodos[i].name == nombre){
            buscar_padres_aux(nodos[i]);
            return padres;
        }
    }
}

//This is an auxiliar function that receive a node of the buscar_padres function
//Check if a node have father and break the recursive loop if the father is undefined
void buscar_padres_aux(nodo){
    if (nodo.parent == undefined){
        return;
    }    
    else{
        get_padre_name(nodo.parent);
        buscar_padres_aux(nodo.parent);
    }
}

//Load the name of the fathers in the padres array
void get_padre_name(nodo){
    append(padres, nodo.name);
}

//Is the function that use Rename() and Move()
//Receive a flag dependig of the funcion that call this function and the color that is required
boolean existeNombre(nodos,nombre){
     for (int nodeL = 0;nodeL<nodos.length;nodeL++){
        if (nodos[nodeL].name == nombre){
            return false;
        }
        String [] sinonimos = nodos[nodeL].Synonym;
        for (int i = 0; i < sinonimos.length; i++){
          if (sinonimos[i]==nombre){
            return false;
          }
        }
     }
     return true;
}

int [] getPosicionesMoves_Renames(nodos){
  int [] posiciones = [];
  for (int i = 0; i < nodosIzquierdos.length; i++){
    for(int j = 0; j < nodos.length; j++){
      if (nodosIzquierdos[i].name == nodos[j].nodoIzquierdo.name){
        append(posiciones,i);
      }
    }
  }
  return posiciones;
}

void Moves(){
   cantidadRenames = 0;
   cantidadMoves = 0;
   Object [] Derechos = [];
   Object [] Izquierdos = [];
   Object [] listaIzquierdosM = [];
   Object [] listaDerechosM = [];
   Object [] listaIzquierdosR = [];
   Object [] listaDerechosR = [];
   int cantindadMoves = 0;
   int cantindadRenames = 0;
   for (int nodeL = 1; nodeL < izquierdos.length;nodeL++){
      int cont = 0;
      String nameL = izquierdos[nodeL].name;
      String autorL = izquierdos[nodeL].author;
      String dateL = izquierdos[nodeL].record_scrutiny_date;
      for (nodeR=1;nodeR<nodosDerechos.length;nodeR++){
          String [] sinonimos = nodosDerechos[nodeR].Synonym;
          String nombreR = nodosDerechos[nodeR].name;
          String autorR = nodosDerechos[nodeR].author;
          String fechaR = nodosDerechos[nodeR].record_scrutiny_date;
          if (sinonimos.length == 1){
            if (nameL  == sinonimos[0] && autorL == autorR && dateL == fechaR){
              cont = cont+1; //Ya hay un move
              //Hay q verificar si el sinonimo existe
              append(Derechos,nodosDerechos[nodeR]);
              append(Izquierdos,izquierdos[nodeL]);
            }
          }
          else{ 
            int existe = 0;
            for (int i=0;i<sinonimos.length;i++){
              if(existeNombre(izquierdos,sinonimos[i])==false){
                existe = existe+1;
                if (nameL == sinonimos[0] && autorL == autorR && dateL == fechaR){
                    cont = cont+1;
                    append(Derechos,nodosDerechos[nodeR]);
                    append(Izquierdos,izquierdos[nodeL]);
              }
            }
          }
        }
      }
      if (cont == 1){
        String nombreL = Izquierdos[0].name;
        String authorL = Izquierdos[0].author;
        String dateL = Izquierdos[0].record_scrutiny_date;
        String nombreR = Derechos[0].name;
        String authorR = Derechos[0].author;
        String dateR = Derechos[0].record_scrutiny_date;
        String [] padresI = buscar_padres(nombreL,izquierdos);
        String [] padresD = buscar_padres(nombreR,derechos);
        if (padresI.length == padresD.length){
          boolean flag = true;
          for (int j = 0; j < padresD.length-1;j++){
              if (padresD[j] != padresI[j]){
                  flag = false;
              }
          }
          if (flag == false){
            append(listaIzquierdosM,Izquierdos[0]);
            append(listaDerechosM,Derechos[0]);
            cantindadMoves+=1;
            cantidadMoves+=1;
          }
          else{
            append(listaIzquierdosR,Izquierdos[0]);
            append(listaDerechosR,Derechos[0]);
            cantindadRenames+=1;
            cantidadRenames+=1;
          }
        }
      }
      Izquierdos = [];
      Derechos = [];
    }
     ListaMoves = new Move[cantindadMoves];
      for (int i = 0; i < listaIzquierdosM.length; i++){
        Node nodoI = new Node(listaIzquierdosM[i].name,listaIzquierdosM[i].x, listaIzquierdosM[i].y);
        Node nodoD = new Node(listaDerechosM[i].name,listaDerechosM[i].x, listaDerechosM[i].y);
        ListaMoves[i] = new Move(nodoI,nodoD);
    }
    ListaRenames = new Move[cantindadRenames];
    for (int i = 0; i < listaIzquierdosR.length; i++){
      Node nodoI = new Node(listaIzquierdosR[i].name,listaIzquierdosR[i].x, listaIzquierdosR[i].y);
      Node nodoD = new Node(listaDerechosR[i].name,listaDerechosR[i].x, listaDerechosR[i].y);
      ListaRenames[i] = new Move(nodoI,nodoD);
    } 
  }

void Moves_Selected(nombre){
   cantidadRenames = 0;
   cantidadMoves = 0;
   Object [] Derechos = [];
   Object [] Izquierdos = [];
   Object [] listaIzquierdosM = [];
   Object [] listaDerechosM = [];
   Object [] listaIzquierdosR = [];
   Object [] listaDerechosR = [];
   int cantindadMoves = 0;
   int cantindadRenames = 0;
   for (int nodeL = 1; nodeL < izquierdos.length;nodeL++){
      int cont = 0;
      String nameL = izquierdos[nodeL].name;
      String autorL = izquierdos[nodeL].author;
      String dateL = izquierdos[nodeL].record_scrutiny_date;
      for (nodeR=1;nodeR<nodosDerechos.length;nodeR++){
          boolean subarbol = false;
          if (existe_Elemento_Array(nombre, buscar_padres(izquierdos[nodeL].name, izquierdos))){
            subarbol = true;
          }
          String [] sinonimos = nodosDerechos[nodeR].Synonym;
          String nombreR = nodosDerechos[nodeR].name;
          String autorR = nodosDerechos[nodeR].author;
          String fechaR = nodosDerechos[nodeR].record_scrutiny_date;
          if (sinonimos.length == 1){
            if (nameL  == sinonimos[0] && autorL == autorR && (nameL == nombre || subarbol)){
              cont = cont+1; //Ya hay un move
              append(Derechos,nodosDerechos[nodeR]);
              append(Izquierdos,izquierdos[nodeL]);
            }
          }
          else{ 
            int existe = 0;
            for (int i=0;i<sinonimos.length;i++){
              if(existeNombre(izquierdos,sinonimos[i])==false){
                existe = existe+1;
                if (nameL == sinonimos[0] && autorL == autorR && (nameL == nombre  || nombreR == nombre || subarbol) && existe == 0){
                    cont = cont+1;
                    append(Derechos,nodosDerechos[nodeR]);
                    append(Izquierdos,izquierdos[nodeL]);
              }
            }
          }
        }
      }
      if (cont == 1){
        String nombreL = Izquierdos[0].name;
        String authorL = Izquierdos[0].author;
        String dateL = Izquierdos[0].record_scrutiny_date;
        String nombreR = Derechos[0].name;
        String authorR = Derechos[0].author;
        String dateR = Derechos[0].record_scrutiny_date;
        String [] padresI = buscar_padres(nombreL,izquierdos);
        String [] padresD = buscar_padres(nombreR,derechos);
        if (padresI.length == padresD.length){
          boolean flag = true;
          for (int j = 0; j < padresD.length-1;j++){
              if (padresD[j] != padresI[j]){
                  flag = false;
              }
          }
          if (flag == false){
            //Javascript function to turn on the congruence slider (autoClickSlider.js)
            autoClickMoves_ON();
            append(ListaSeleccionados_Moves_I,Izquierdos[0]);
            append(ListaSeleccionados_Moves_D,Derechos[0]);
            moves_click =  true;
            cantindadMoves+=1;
            cantidadMoves+=1;
          }
          else{
            //Javascript function to turn on the congruence slider (autoClickSlider.js)
            autoClickRenames_ON();
            append(ListaSeleccionados_Rename_I,Izquierdos[0]);
            append(ListaSeleccionados_Rename_D,Derechos[0]);
            renames_click = true;
            cantindadRenames+=1;
            cantidadRenames+=1;
          }
        }
      }
      Izquierdos = [];
      Derechos = [];
    }
  }


///////////////////////////Exclusion functions////////////////////
int [] getPosicionesExclusion(){
  int [] posiciones = [];
  for (int i = 0; i < nodosIzquierdos.length; i++){
    if (existeNombreComplejo(nodosDerechos, nodosIzquierdos[i].name, nodosIzquierdos[i].author, nodosIzquierdos[i].record_scrutiny_date)){
      append(posiciones,i);
    }
  }
  return posiciones;
}

boolean existeNombreComplejo(nodos,nombre,author,date){
     for (int nodeL = 0;nodeL<nodos.length;nodeL++){
        if (nodos[nodeL].name == nombre && nodos[nodeL].author == author && nodos[nodeL].record_scrutiny_date == date){
            return false;
        }
        else if (nodos[nodeL].name == nombre && nodos[nodeL].author == author){
           return false;
        }
        String [] sinonimos = nodos[nodeL].Synonym;
        for (int i = 0; i < sinonimos.length; i++){
          if (sinonimos[i]==nombre){
            return false;
          }
        }
     }
     return true;
}

void Exclusiones(){
  int cantidad = 0;
  cantidadExclusiones = 0;
  for (int i = 1; i < nodosIzquierdos.length; i++){
    if (existeNombreComplejo(nodosDerechos, nodosIzquierdos[i].name, nodosIzquierdos[i].author, nodosIzquierdos[i].record_scrutiny_date)){
      cantidad+=1;
    }
  }
  ListaExcluidos = new Excl_News[cantidad];
  int pos = 0;
  for (int i = 1; i < nodosIzquierdos.length; i++){
    if (existeNombreComplejo(nodosDerechos, nodosIzquierdos[i].name, nodosIzquierdos[i].author, nodosIzquierdos[i].record_scrutiny_date)){
      ListaExcluidos[pos] = new Excl_News(nodosIzquierdos[i].name);
      pos+=1;
      cantidadExclusiones+=1;
    }
  }
}

void Exclusiones_Selected(nombre){
  cantidadExclusiones = 0;
  int pos = 0;
  for (int i = 1; i < nodosIzquierdos.length; i++){
    boolean subarbol = false;
    if (existe_Elemento_Array(nombre, buscar_padres(izquierdos[i].name, izquierdos))){
      subarbol = true;
    }
    if (existeNombreComplejo(nodosDerechos, nodosIzquierdos[i].name, nodosIzquierdos[i].author, nodosIzquierdos[i].record_scrutiny_date)  && (nombre == nodosIzquierdos[i].name || subarbol) ){
      append(ListaSeleccionados_Exclusiones, nodosIzquierdos[i]);
      //Javascript function to turn on the exclusions slider (autoClickSlider.js)
      autoClickExclusion_ON();
      exclusions_click = true;
      pos+=1;
      cantidadExclusiones+=1;
    }
  }
}
//////////////////News Functions/////////////////////////////////////

boolean existeNombre_ComplejoAux(nombre,autor,date){
    Object [] izquierdos = nodesLeft;
    for (int nodeL = 0; nodeL < izquierdos.length; nodeL++) {
        if(izquierdos[nodeL].name == nombre && izquierdos[nodeL].author == autor){
            return false;
        }
    }
    return true;
} 

void News(){
  cantidadNews = 0;
  Excl_News [] nodos = [];
  for (int i = 1; i < nodosDerechos.length; i++){
    if (existeNombre_ComplejoAux(nodosDerechos[i].name,nodosDerechos[i].author,nodosDerechos[i].record_scrutiny_date) == true){
      String [] sinonimos = nodosDerechos[i].Synonym;
      if (sinonimos.length == 0){
        Node nodo = new Node(nodosDerechos[i].name,550,nodosDerechos[i].y);
        Excl_News n = new Excl_News(nodosDerechos[i].name,550,nodosDerechos[i].y,nodo);
        append(nodos,n);
      }
      else{
        boolean flag = true;
        for (int j = 0; j < sinonimos.length; j++){
          if (existeNombre(nodosIzquierdos,sinonimos[j]) == false){
            flag = false;
          }
        }
        if (flag){
          Node nodo = new Node(nodosDerechos[i].name,550,nodosDerechos[i].y);
          Excl_News n = new Excl_News(nodosDerechos[i].name,550,nodosDerechos[i].y,nodo);
          append(nodos,n);
        }
      }
    }
  }
 ListaNuevos = nodos;
 cantidadNews = ListaNuevos.length;
}


/////////////////////////////////////////////Congruency functions/////////////////////////////////
int [] getposicionesCongruengy(click){
  int [] posiciones = [];
  for (int i = 1;i<nodosIzquierdos.length;i++){
    boolean acepto = true;
    if (click){
      for (int j = 0;j<ListaSeleccionados_Conguentres_D.length;j++){
        if (ListaSeleccionados_Conguentres_D[j].name == nodosIzquierdos[i].name){
          append(posiciones,i);
        }
      }
    }
    else{
      for (int j = 1;j<nodosDerechos.length;j++){
        String [] listaSinonimos = nodosDerechos[j].Synonym;
        for (int s = 0; s < listaSinonimos.length; s++){
            if (izquierdos[i].name == listaSinonimos[s]){
                acepto = false;
            }
        }
        if(nodosIzquierdos[i].name == nodosDerechos[j].name && nodosIzquierdos[i].author == nodosDerechos[j].author && acepto == true){
          append(posiciones,i);
        }
      }
    }
  }
  return posiciones;
}

void Congruencia(){
  ListaCongruency1 = [];
  cantidadCongruentes = 0;
  for (int i = 1;i<nodosIzquierdos.length;i++){
    boolean acepto = true;
    for (int j = 1;j<nodosDerechos.length;j++){
        String [] listaSinonimos = derechos[j].Synonym;
        for (int s = 0; s < listaSinonimos.length; s++){
            if (izquierdos[i].name == listaSinonimos[s]){
                acepto = false;
            }
        }
        if (nodosIzquierdos[i].name == nodosDerechos[j].name && nodosIzquierdos[i].author == nodosDerechos[j].author && acepto == true){
          append(ListaCongruency1,nodosDerechos[j]);
          cantidadCongruentes += 1;
        }
    }
  }
}

//Function to clicked nodes
void Congruencia_Selected(nombre){
  cantidadCongruentes = 0;
  for (int i = 1;i<nodosIzquierdos.length;i++){
    boolean acepto = true;
    for (int j = 1;j<nodosDerechos.length;j++){
      boolean subarbol = false;
      if (existe_Elemento_Array(nombre, buscar_padres(nodosDerechos[j].name, derechos))){
        subarbol = true;
      }
      if (existe_Elemento_Array(nombre, buscar_padres(nodosIzquierdos[i].name, izquierdos))){
        subarbol = true;
      }
      String [] listaSinonimos = derechos[j].Synonym;
      for (int s = 0; s < listaSinonimos.length; s++){
          if (izquierdos[i].name == listaSinonimos[s]){
              acepto = false;
          }
      }
      if ((nodosIzquierdos[i].name == nodosDerechos[j].name && nodosIzquierdos[i].author == nodosDerechos[j].author && acepto == true) && (nodosIzquierdos[i].name == nombre || nodosDerechos[j].name == nombre || subarbol)){
        cantidadCongruentes += 1;
        congruency_click = true;
        //Javascript function to turn on the congruence slider (autoClickSlider.js)
        autoClickCongruence_ON();
        append(ListaSeleccionados_Conguentres_I,nodosIzquierdos[i]);
        append(ListaSeleccionados_Conguentres_D,nodosDerechos[j]);
      }
    }
  }
}

int RetornarCantidadCongruentes(){
  return cantidadCongruentes;
}


/////////////////////////////////Splits Functions//////////////////////////////////////////
void verificarSinonimos(arreglo,nombre){
    for (int i=0; i<arreglo.length;i++){
        if (arreglo[i] == nombre){
            return true;
        }
    }
    return false;
}

int [] getPosicionesFinalesSplit(){
  int [] posiciones = [];
  for (int i = 0;i<nodosIzquierdos.length;i++){
    for(int j = 0; j < ListaSplitsA.length; j++){
      if (nodosIzquierdos[i].name == ListaSplitsA[j].name){
          append(posiciones, i);
      }
    }
  }
  return posiciones;
}

int [] getPosicionesSplits(){
  int [] posiciones = [];
  for (int i = 0;i<nodosIzquierdos.length;i++){
    String name = nodosIzquierdos[i].name;
    String autor = nodosIzquierdos[i].author;
    String date = nodosIzquierdos[i].record_scrutiny_date;
    int cont = 0;
    for (int j = 0;j<nodosDerechos.length;j++){
      if ((name == nodosDerechos[j].name || verificarSinonimos(nodosDerechos[j].Synonym,name)) && autor == nodosDerechos[j].author && date == nodosDerechos[j].record_scrutiny_date){
        cont= cont+1;
      }
    }
     if (cont>1){
        append(posiciones,i);
     }
  }
  return posiciones;
}

void Splits(){
  cantidadSplits =0;
  Object [] splitsL = [];
  Object [] splitsR = [];
  ListaSplits = [];
  Node [] derechos = [];
  for (int i = 1;i<nodosIzquierdos.length;i++){
    String name = nodosIzquierdos[i].name;
    String autor = nodosIzquierdos[i].author;
    String date = nodosIzquierdos[i].record_scrutiny_date;
    append(splitsL,nodosIzquierdos[i]);
    int cont = 0;
    for (int j = 1;j<nodosDerechos.length;j++){
      if ((name == nodosDerechos[j].name || verificarSinonimos(nodosDerechos[j].Synonym,name)) && autor == nodosDerechos[j].author && date == nodosDerechos[j].record_scrutiny_date){
        cont= cont+1;
        append(splitsR,nodosDerechos[j]);
      }
    }
     if (cont>1){
        Node nodoIzq = new Node(splitsL[0].name,splitsL[0].x,splitsL[0].y);
        //appencontd(ListaSplits,splitsL[m]);
        cantidadSplits+=1;
        int altura = 0;
        for (int n = 0; n < splitsR.length; n++){
          //splitsR[n].x = splitsL[0].x+200;
          Node nodoDer = new Node(splitsR[n].name,splitsR[n].x,splitsR[n].y);
          append(HistorialSplits,nodoIzq);
          nodoDer.x = splitsL[0].x+200;
          nodoDer.y = splitsL[0].y+altura;
          altura += 20; 
          append(derechos,nodoDer);
        }

        Split nodo = new Split(nodoIzq,derechos);
        append(ListaSplits,nodo);
        splitsR=[];
        splitsL=[];
        derechos = [];
     }
     splitsR=[];
     splitsL=[];
  }
}

void Splits_Selected(nombre){
  HistorialSplits = [];
  cantidadSplits =0;
  Object [] splitsL = [];
  Object [] splitsR = [];
  ListaSplits = [];
  Node [] derechos = [];
  for (int i = 1;i<nodosIzquierdos.length;i++){
    String name = nodosIzquierdos[i].name;
    String autor = nodosIzquierdos[i].author;
    String date = nodosIzquierdos[i].record_scrutiny_date;
    append(splitsL,nodosIzquierdos[i]);
    int cont = 0;
    for (int j = 1;j<nodosDerechos.length;j++){
      if ((name == nodosDerechos[j].name || verificarSinonimos(nodosDerechos[j].Synonym,name)) && autor == nodosDerechos[j].author && date == nodosDerechos[j].record_scrutiny_date){
        cont= cont+1;
        append(splitsR,nodosDerechos[j]);
      }
    }
     if (cont>1){
        boolean subarbol = false;
        for (int verify = 0;verify<splitsL.length;verify++){
          if (nombre == splitsL[verify].name || existe_Elemento_Array(nombre, buscar_padres(splitsL[verify].name, izquierdos))){
            subarbol = true;
          }
        }
        if (subarbol){
          //Javascript function to turn on the exclusions slider (autoClickSlider.js)
          autoClickSplits_ON();
          splits_click = true;
          Node nodoIzq = new Node(splitsL[0].name,splitsL[0].x,splitsL[0].y);
          //appencontd(ListaSplits,splitsL[m]);
          cantidadSplits+=1;
          int altura = 0;
          for (int n = 0; n < splitsR.length; n++){
            //splitsR[n].x = splitsL[0].x+200;
            Node nodoDer = new Node(splitsR[n].name,splitsR[n].x,splitsR[n].y);
            append(HistorialSplits,nodoIzq);
            nodoDer.x = splitsL[0].x+200;
            nodoDer.y = splitsL[0].y+altura;
            altura += 20; 
            append(derechos,nodoDer);
          }

          Split nodo = new Split(nodoIzq,derechos);
          append(ListaSplits,nodo);
          splitsR=[];
          splitsL=[];
          derechos = [];
        }
        
     }
     splitsR=[];
     splitsL=[];
  }
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Class node definition
class Node{
  String name;
  int x;
  int y;
  String [] Synonym;
  String author;
  String record_scrutiny_date;
  String color;
  Node(String nombre, int posx, int posy, String [] sin, String aut, String fec){
    name = nombre;
    x = posx;
    y = posy;
    Synonym = sin;
    author = aut;
    record_scrutiny_date = fec;
  }
  Node(String nombre, int posx, int posy){
    name = nombre;
    x = posx;
    y = posy;
  }
  void display(){
      text(name,x,y);
  }
  void move(int posx,int posy){
    if (x < posx){
      x += incrX;
    }
    if (y < posy){
      y += incrY;
    }
    if (y > posy){
      y -= incrY;
    }
  }
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Clase mergers
class Merge{
  String [] nodosMergeIzquierdos;
  Node nodoMergeDerecho;
  Merge(String [] izquierdo, Node derecho){
    nodosMergeIzquierdos = izquierdo;
    nodoMergeDerecho = derecho;
  }
}

////////////////////////////////////////////////////////////////////////////////
//Move and renames class
class Move{
  Node nodoIzquierdo;
  Node nodoDerecho;
  Move(Node izq, Node der){
    nodoDerecho = der;
    nodoIzquierdo = izq;
  }
}
/////////////////////////////////////////////////////////////
//Exclusion and news class
class Excl_News{
  String nombre;
  int x;
  int y;
  Node nodoDerecha;
  Excl_News(String nom){
    nombre = nom;
  }
  Excl_News(String nom,int X, int Y,Node nodo){
    nombre = nom;
    x = X;
    y = Y;
    nodoDerecha = nodo;
  }
}
////////////////////////////////////////////////////////////////
class Split{
  Node NodoIzquierdo;
  Node [] NodosDerechos;
  Split(Node izq, Node [] der){
    NodoIzquierdo = izq;
    NodosDerechos = der;
  }
}