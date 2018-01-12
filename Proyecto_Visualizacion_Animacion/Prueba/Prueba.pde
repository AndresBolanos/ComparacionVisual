
//definicion de las variables de uso general
boolean moves = false;
boolean renames = false;
boolean exclusions = false;
boolean news = false;
boolean congruency = false;
boolean splits = false;
boolean splitsAux = false;
boolean splitsAux2 = false;
boolean mergers = false;
boolean Final = false;
boolean inicio = false;
Node [] nodosIzquierdos;
Node [] nodosDerechos;
Object [] izquierdos;
Object [] derechos;
Merge []  Listamergers; // en este arreglo se guardan los objetos de tipo merges un atributo nodo que tiene el nodo de la derecha y un atributo de lista de nombre de los de la izquierda
Move [] ListaMoves;
Move [] ListaRenames;
Split [] ListaSplits;
Node[] ListaSplitsA;
Node [] HistorialSplits = [];
Excl_News [] ListaExcluidos;
Excl_News [] ListaNuevos;
Node [] ListaCongruency1;
Node [] ListaGeneral = [];
float scaleFactor = 1.0;
float translateX = 0.0;
float translateY = 0.0;
float incrX = 0; //Have the pair numbres
float incrY = 0;
int cantidadMoves;
int cantidadRenames;
int cantidadSplits;
int cantidadMerges;
int cantidadNews;
int cantidadExclusiones;
int catidadCongruentes;
Node nodo;
boolean one_by_one = false;

int posicionNuevos = 0;
int posicionExclusiones = 0;
int posicionCongruentes = 0;
int posicionMoves = 0;
int posicionMerges = 0;
int posicionSplits = 0;

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
//This function Apply the value of the slider in javascript lo the variable of move
void setValueSlider(int valueSlider){
  if (valueSlider == 1){
    incrX = 1;
    incrY = 1;
  }
  if (valueSlider >= incrX){
    if (incrX == 0){
      incrX += abs(valueSlider/1);
      incrY += abs(valueSlider/1);
    }
    else{
      incrX += abs(valueSlider/incrX);
      incrY += abs(valueSlider/incrY);
    }
   }
   else{
     if (valueSlider == 0){
      if (incrX != 0){
        incrX -= abs(incrX/1);
        incrY -= abs(incrY/1);
      }
    }
    else{
      incrX -= abs(incrX/valueSlider);
      incrY -= abs(incrY/valueSlider);
    }
   }
}

void beginAnimation(){
  posicionNuevos = 0;
  posicionExclusiones = 0;
  posicionCongruentes = 0;
  posicionMoves = 0;
  posicionMerges = 0;
  posicionSplits = 0;
  inicio = true;
}

void StopAnimation(){
  inicio = false;
}

void setValueOneByOne(boolean valor){
  println(valor);
  one_by_one = valor;
}

void setup(){
  mergers = false;
  moves = false;
  renames = false;
  news = false;
  congruency = false;
  splits = false;
  splitsAux = false;
  ListaSplitsA = false;
  exclusions = false;
  size (availableWidth,availableHeight);
  Final = false;
  izquierdos = nodesLeft;
  derechos = nodesRight;
  nodosIzquierdos = new Node[izquierdos.length];
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

void draw() {
  translate(translateX,translateY);
  scale(scaleFactor);
  background(255);
  pintarNodos(true);
  pintarNodos(false);
  if (one_by_one){
      if (inicio){
        if (nodosIzquierdos[0].x >= nodosDerechos[0].x){
          inicio = false;
          mergers = true;
          removerNodos([0]);

        }
        else{
          nodosIzquierdos[0].move(nodosDerechos[0].x,nodosDerechos[0].y);
        }
    }
    if (mergers){
      if (mergersG){
        if (Listamergers.length == 0){
           mergers = false;
          moves = true;
        }
          int [] posiciones = getPosicionesMergers();
          for (int i = 0; i < posiciones.length; i++){
            //for (int j = 0; j < Listamergers.length; j++){
               String [] nombres = Listamergers[posicionMerges].nodosMergeIzquierdos;
               for (int k = 0; k < nombres.length; k++){
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
                            moves = true;
                        }
                      }
                  }
               }
            //}
          }
      }
      else{
        mergers = false;
        moves = true;
      }
    }
    if (moves){
      if (movesG){
          if (ListaMoves.length == 0){
             moves = false;
            renames = true;
          }
          int [] posicionesMoves = getPosicionesMoves_Renames(ListaMoves);
          for (int i = 0; i < nodosIzquierdos.length; i++){
            //for (j = 0; j < ListaMoves.length; j++){
              if (nodosIzquierdos[i].name == ListaMoves[posicionMoves].nodoIzquierdo.name){
                nodosIzquierdos[i].move(ListaMoves[posicionMoves].nodoDerecho.x,ListaMoves[posicionMoves].nodoDerecho.y);
                if (nodosIzquierdos[i].x >= ListaMoves[posicionMoves].nodoDerecho.x -6 && (nodosIzquierdos[i].y >= ListaMoves[posicionMoves].nodoDerecho.y-6 || nodosIzquierdos[i].y >= ListaMoves[posicionMoves].nodoDerecho.y+6)){
                  //removerNodos(posicionesMoves);
                  posicionMoves+=1;
                  removerNodos([i]);
                  if (posicionMoves == ListaMoves.length){
                      moves = false;
                      renames = true;
                      break;
                  }
                }
              }
            //}
          }
       }
       else{
          moves = false;
          renames = true;
       }
    }

    if (renames){
      if (renamesG){
        if (ListaRenames.length == 0){
           renames = false;
           news = true;
        }

        int [] posicionesRenames = getPosicionesMoves_Renames(ListaRenames);
        for (int i = 0; i < nodosIzquierdos.length; i++){
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
      else{
        renames = false;
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
    if (exclusions){
      if (exclusionsG){
        if (ListaExcluidos.length == 0){
          exclusions = false;
          congruency = true;
        }
        for (int i = 0; i < nodosIzquierdos.length; i++){
          //for (int j = 0; j < ListaExcluidos.length; j++){
          if (nodosIzquierdos[i].name == ListaExcluidos[posicionExclusiones].nombre){
            nodosIzquierdos[i].move(600,nodosIzquierdos[i].y);
            if (nodosIzquierdos[i].x >= 600){
              posicionExclusiones+=1;
              removerNodos([i]);
              if (posicionExclusiones == ListaExcluidos.length){
                exclusions = false;
                congruency = true;
                break;
              }
            }
          }
          //}
        }
      }
     else{
       exclusions = false;
        congruency = true;
     }
    }
    if (splits){
      if (splitsG){
        if (ListaSplits.length == 0){
           splits = false;
            splitsAux = true;
        }
        for (int i = 0; i < nodosIzquierdos.length; i++){
         //for (int j = 0; j < ListaSplits.length; j++){
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
         //}
        }
      }
      else{
        splits = false;
        splitsAux = false;
      }
    }
    if (splitsAux){
      ListaSplitsA = [];
      //for (int j = 0; j < ListaSplits.length; j++){
        Node [] Lista = ListaSplits[posicionSplits].NodosDerechos;
        for (int i = 0; i < Lista.length; i++){
          append(nodosIzquierdos,Lista[i]);
          append(ListaSplitsA,Lista[i]);
        }
      //}
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
    if (congruency){
      if (conguencyG){
          if (ListaCongruency1.length == 0){
            congruency = false;
            splits = true;
          }
          boolean eliminar = false;
          for (int i = 0; i < nodosIzquierdos.length; i++){
            //for (int j = 0; j < ListaCongruency1.length; j++){
              if (ListaCongruency1[posicionCongruentes].name == nodosIzquierdos[i].name){
                nodosIzquierdos[i].move(ListaCongruency1[posicionCongruentes].x,ListaCongruency1[posicionCongruentes].y);
                if (nodosIzquierdos[i].x >= ListaCongruency1[posicionCongruentes].x-6 && (nodosIzquierdos[i].y >= ListaCongruency1[posicionCongruentes].y-6 || nodosIzquierdos[i].y >= ListaCongruency1[posicionCongruentes].y+6)){
                  posicionCongruentes+=1;
                  removerNodos([i]);
                  if (posicionCongruentes == ListaCongruency1.length){
                    congruency = false;
                    splits = true;
                    break;
                  }
                }
              }
            posicionesCongruency = [];
          }
        }
      else{
        congruency = false;
        splits = true;
      }
    }
  }
  else{
    if (inicio){
        if (nodosIzquierdos[0].x >= nodosDerechos[0].x){
          inicio = false;
          mergers = true;
          removerNodos([0]);

        }
        else{
          nodosIzquierdos[0].move(nodosDerechos[0].x,nodosDerechos[0].y);
        }
    }
    if (mergers){
      if (mergersG){
        if (Listamergers.length == 0){
           mergers = false;
          moves = true;
        }
          int [] posiciones = getPosicionesMergers();
          for (int i = 0; i < posiciones.length; i++){
            for (int j = 0; j < Listamergers.length; j++){
               String [] nombres = Listamergers[j].nodosMergeIzquierdos;
               for (int k = 0; k < nombres.length; k++){
                  if(nombres[k] == nodosIzquierdos[posiciones[i]].name){
                     nodosIzquierdos[posiciones[i]].move(Listamergers[j].nodoMergeDerecho.x,Listamergers[j].nodoMergeDerecho.y);
                     if (nodosIzquierdos[posiciones[i]].x >= Listamergers[j].nodoMergeDerecho.x-10 && (nodosIzquierdos[posiciones[i]].y >= Listamergers[j].nodoMergeDerecho.y-10 || nodosIzquierdos[posiciones[i]].y >= Listamergers[j].nodoMergeDerecho.y+10)){
                       removerNodos(posiciones);
                       mergers = false;
                       moves = true;
                      }
                  }
               }
            }
          }
      }
      else{
        mergers = false;
        moves = true;
      }
    }
    if (moves){
      if (movesG){
          if (ListaMoves.length == 0){
             moves = false;
            renames = true;
          }
          int [] posicionesMoves = getPosicionesMoves_Renames(ListaMoves);
          for (int i = 0; i < nodosIzquierdos.length; i++){
            for (j = 0; j < ListaMoves.length; j++){
              if (nodosIzquierdos[i].name == ListaMoves[j].nodoIzquierdo.name){
                nodosIzquierdos[i].move(ListaMoves[j].nodoDerecho.x,ListaMoves[j].nodoDerecho.y);
                if (nodosIzquierdos[i].x >= ListaMoves[j].nodoDerecho.x -6 && (nodosIzquierdos[i].y >= ListaMoves[j].nodoDerecho.y-6 || nodosIzquierdos[i].y >= ListaMoves[j].nodoDerecho.y+6)){
                  removerNodos(posicionesMoves);
                  moves = false;
                  renames = true;
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

    if (renames){
      if (renamesG){
        if (ListaRenames.length == 0){
           renames = false;
           news = true;
        }
        int [] posicionesRenames = getPosicionesMoves_Renames(ListaRenames);
        for (int i = 0; i < nodosIzquierdos.length; i++){
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
      else{
        renames = false;
        news = true;
      }
    }
    if (news){
      if (newsG){
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
    if (exclusions){
      if (exclusionsG){
        if (ListaExcluidos.length == 0){
          exclusions = false;
          congruency = true;
        }
        for (int i = 0; i < nodosIzquierdos.length; i++){
          for (int j = 0; j < ListaExcluidos.length; j++){
            if (nodosIzquierdos[i].name == ListaExcluidos[j].nombre){
              nodosIzquierdos[i].move(600,nodosIzquierdos[i].y);
              if (nodosIzquierdos[i].x >= 600){
                removerNodos(getPosicionesExclusion());
                exclusions = false;
                congruency = true;
              }
            }
          }
        }
      }
     else{
       exclusions = false;
        congruency = true;
     }
    }
    if (splits){
      if (splitsG){
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
     /* for (int i = 0; i < nodosDerechos.length; i++){
        for (int j = 0; j < ListaSplitsA.length; j++){
          if (nodosDerechos[i].name == ListaSplitsA[j].name){

          }
        }
      }*/
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
    if (congruency){
      if (conguencyG){
          if (ListaCongruency1.length == 0){
            congruency = false;
            splits = true;
          }
          boolean eliminar = false;
          for (int i = 0; i < nodosIzquierdos.length; i++){
            for (int j = 0; j < ListaCongruency1.length; j++){
              if (ListaCongruency1[j].name == nodosIzquierdos[i].name){
                nodosIzquierdos[i].move(ListaCongruency1[j].x,ListaCongruency1[j].y);
                if (nodosIzquierdos[i].x >= ListaCongruency1[j].x-6 && (nodosIzquierdos[i].y >= ListaCongruency1[j].y-6 || nodosIzquierdos[i].y >= ListaCongruency1[j].y+6)){
                  eliminar = true;
                }
              }
            }

            if (eliminar){
              removerNodos(getposicionesCongruengy());
              congruency = false;
              splits = true;
              break;
            }
            posicionesCongruency = [];
          }
        }
      else{
        congruency = false;
        splits = true;
      }
    }
  }

}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    scaleFactor = 1;
    translateX = 0.0;
    translateY = 0.0;
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

void mouseDragged(MouseEvent e) {
  translateX += mouseX - pmouseX;
  translateY += mouseY - pmouseY;
}

void mouseWheel(MouseEvent e) {
  translateX -= mouseX;
  translateY -= mouseY;
  float delta = e.getCount() > 0 ? 1.05 : e.getCount() < 0 ? 1.0/1.05 : 1.0;
  scaleFactor *= delta;
  translateX *= delta;
  translateY *= delta;
  translateX += mouseX;
  translateY += mouseY;
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
      nodosIzquierdos[i] = new Node(nodos[i].name, nodos[i].x+300,y,nodos[i].Synonym,nodos[i].author, nodos[i].record_scrutiny_date);
      y += round((availableHeight-40)/nodos.length)+5;
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
      textSize(12); 
      if (mergers){
        for (int m = 0; m < Listamergers.length; m++){
          if (one_by_one){
            if (m == posicionMerges){
                String [] nodos = Listamergers[m].nodosMergeIzquierdos;
                for (int s = 0; s < nodos.length; s++){
                  if (nodosIzquierdos[i].name == nodos[s]){
                    textSize(20); 
                    fill(255, 145, 0);
                  }
                }
            }
            else{
               String [] nodos = Listamergers[m].nodosMergeIzquierdos;
                for (int s = 0; s < nodos.length; s++){
                  if (nodosIzquierdos[i].name == nodos[s]){
                    fill(255, 145, 0);
                  }
                }
            }
          }
          else{
            String [] nodos = Listamergers[m].nodosMergeIzquierdos;
            for (int s = 0; s < nodos.length; s++){
              if (nodosIzquierdos[i].name == nodos[s]){
                textSize(20); 
                fill(255, 145, 0);
              }
            }
          }
        }
      }
      if (moves){
         for (int m = 0; m < ListaMoves.length; m++){
          if (one_by_one){
            if (ListaMoves[m].nodoIzquierdo.name == nodosIzquierdos[i].name && m == posicionMoves){
                textSize(20); 
                fill(10,228,237);
            }
            else if (ListaMoves[m].nodoIzquierdo.name == nodosIzquierdos[i].name){
              fill(10,228,237);
            }
          }
          else{
            if (ListaMoves[m].nodoIzquierdo.name == nodosIzquierdos[i].name){
              textSize(20); 
              fill(10,228,237);
             }
          }
         }
      }
      if (renames){
         for (int m = 0; m < ListaRenames.length; m++){
          if (ListaRenames[m].nodoIzquierdo.name == nodosIzquierdos[i].name){
            textSize(20); 
            fill(8,138,8);
           }
         }
      }
      if (exclusions){
        for (int m = 0; m < ListaExcluidos.length; m++){
          if (one_by_one){
            if (ListaExcluidos[m].nombre == nodosIzquierdos[i].name && m == posicionExclusiones){
              textSize(20); 
              fill(223,1,1);
            }
            else if (ListaExcluidos[m].nombre == nodosIzquierdos[i].name){
              fill(223,1,1);
            }
          }
          else{
            if (ListaExcluidos[m].nombre == nodosIzquierdos[i].name){
              textSize(20); 
              fill(223,1,1);
            }
          }
        }
      }
      if (congruency){
        for (int m = 0; m < ListaCongruency1.length; m++){
          if (one_by_one){
            if (ListaCongruency1[m].name == nodosIzquierdos[i].name && posicionCongruentes == m){
                textSize(20); 
                fill(23, 18, 196);
            }
            else if(ListaCongruency1[m].name == nodosIzquierdos[i].name){ 
              fill(23, 18, 196);
            }
          }
          else{
            if (ListaCongruency1[m].name == nodosIzquierdos[i].name){
                textSize(20); 
                fill(23, 18, 196);
              }
          }
        }
      }
      if (splits){
         for (int m = 0; m < ListaSplits.length; m++){
          if (one_by_one){
            if (ListaSplits[m].NodoIzquierdo.name == nodosIzquierdos[i].name && m == posicionSplits){
              textSize(20); 
              fill(255,0,191);
             }
             else if (ListaSplits[m].NodoIzquierdo.name == nodosIzquierdos[i].name){
              fill(255,0,191);
             }
          }
          else{
            if (ListaSplits[m].NodoIzquierdo.name == nodosIzquierdos[i].name){
              textSize(20); 
              fill(255,0,191);
             }
          }
         }
      }
      if (splitsAux2){
        for (int m = 0; m < ListaSplitsA.length; m++){
          if (ListaSplitsA[m].name == nodosIzquierdos[i].name){
             textSize(20); 
             fill(255,0,191);
          }
        }
        for (int m = 0; m < ListaSplits.length; m++){
            if (one_by_one){
              if (ListaSplits[m].NodoIzquierdo.name == nodosIzquierdos[i].name){
                fill(255,0,191);
              }
            }
          }
      }
      nodosIzquierdos[i].display();
    }
  }
  else{
     for (int i = 0; i < nodosDerechos.length; i++){
       textSize(12); 
      fill(124,122,122);
      if (mergers){
        for (int m = 0; m < Listamergers.length; m++){
          if (one_by_one){
            if (Listamergers[m].nodoMergeDerecho.name == nodosDerechos[i].name && m < posicionMerges){ 
              fill(255, 145, 0);
            }
          }
          else{
            if (Listamergers[m].nodoMergeDerecho.name == nodosDerechos[i].name){ 
              fill(255, 145, 0);
            }
          }
        }
      }
      if (moves){
         for (int m = 0; m < ListaMoves.length; m++){
          if (one_by_one){
            if (ListaMoves[m].nodoDerecho.name == nodosDerechos[i].name && m < posicionMoves){ 
              fill(10,228,237);
             }
          }
          else{
            if (ListaMoves[m].nodoDerecho.name == nodosDerechos[i].name){ 
              fill(10,228,237);
             }
          }
         }
      }
      if (renames){
         for (int m = 0; m < ListaRenames.length; m++){
          if (ListaRenames[m].nodoDerecho.name == nodosDerechos[i].name){
            textSize(20); 
            fill(8,138,8);
           }
         }
      }
      if (news){
         for (int m = 0; m < ListaNuevos.length; m++){
          if (one_by_one){
            if (ListaNuevos[m].nodoDerecha.name == nodosDerechos[i].name && m < posicionNuevos){
              fill(8,138,0);
            }
          }
          else{
            if (ListaNuevos[m].nodoDerecha.name == nodosDerechos[i].name){
              fill(8,138,0);
            }
          } 
        }
      }
      if (congruency){
        for (int m = 0; m < ListaCongruency1.length; m++){
          if (one_by_one){
            if (ListaCongruency1[m].name == nodosDerechos[i].name && m < posicionCongruentes){
                //textSize(20); 
                fill(23, 18, 196);
              }
          }
          else{
            if (ListaCongruency1[m].name == nodosDerechos[i].name){
               // textSize(20); 
                fill(23, 18, 196);
              }
          }
        }
      }
      if (splits){
        for (int m = 0; m < ListaSplits.length; m++){
            if (one_by_one){
              if (m < posicionSplits){
                Node [] lista = ListaSplits[m].NodosDerechos;
                for (int s = 0; s < lista.length; s++){
                  if (lista[s].name == nodosDerechos[i].name){
                     fill(255,0,191);
                  }
                }
              }
            }
          }
      }
      if (splitsAux2){
        for (int m = 0; m < ListaSplitsA.length; m++){
          if (one_by_one){
             if (ListaSplitsA[m].name == nodosDerechos[i].name){
                fill(255,0,191);
             }
          }
          else{
             if (ListaSplitsA[m].name == nodosDerechos[i].name){
              fill(255,0,191);
             }
          }
        }
        for (int m = 0; m < ListaSplits.length; m++){
            if (one_by_one){
              if (m < posicionSplits){
                Node [] lista = ListaSplits[m].NodosDerechos;
                for (int s = 0; s < lista.length; s++){
                  if (lista[s].name == nodosDerechos[i].name){
                     fill(255,0,191);
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
          textSize(20); 
          fill(8,138,0);
          ListaNuevos[i].nodoDerecha.display();
        }
      }
      else{
          textSize(20); 
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
          if (cont > 1){
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

boolean existeNombre_Complejo(nombre,autor,date){
    Object [] izquierdos = nodesLeft;
    for (int nodeL = 0; nodeL < izquierdos.length; nodeL++) {
        if(izquierdos[nodeL].name == nombre && izquierdos[nodeL].author == autor && izquierdos[nodeL].record_scrutiny_date == date){
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
          for (int j = 0; j < padresD.length;j++){
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
int [] getposicionesCongruengy(){
  int [] posiciones = [];
  for (int i = 0;i<nodosIzquierdos.length;i++){
    for (int j = 0;j<nodosDerechos.length;j++){
      if (nodosIzquierdos[i].name == nodosDerechos[j].name && nodosIzquierdos[i].author == nodosDerechos[j].author && nodosIzquierdos[i].record_scrutiny_date == nodosDerechos[j].record_scrutiny_date){
        append(posiciones,i);
      }
      else if(nodosIzquierdos[i].name == nodosDerechos[j].name && nodosIzquierdos[i].author == nodosDerechos[j].author){
        append(posiciones,i);
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