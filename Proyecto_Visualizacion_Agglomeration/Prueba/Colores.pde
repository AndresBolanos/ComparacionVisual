///////////////////////Variables//////////////////////////////////////////
Node [] nodosIzquierdos;
Node [] nodosDerechos;
Object [] nodosTenues;

int rightBaseR = 244;
int rightBaseG = 164;
int rightBaseB = 96;

int leftBaseR = 221;
int leftBaseG = 196;
int leftBaseB = 0;

float scaleFactor = 1.0;
float translateX = screen.width/2-200;
float translateY = 0.0;

String archivo1 = "";
String archivo2 = "";
boolean Congruence = false;   //Flag activates the printing according to selected congruence node
boolean moves = false;        //Flag activates the printing according to selected moves node
boolean renames = false;      //Flag activates the printing according to selected rename node
boolean exclusiones = false;  //Flag activates the printing according to selected exclusions node
boolean nuevos = false;       //Flag activates the printing according to selected news node
boolean splits = false;       //Flag activates the printing according to selected splits node
boolean merges = false;

Posiciones [] ListaPosiciones_I;  //Guarda las posiciones logicas de cada nodo de la izquierda
Posiciones [] ListaPosiciones_D;  //Guarda las posiciones logicas de cada nodo de la izquierda
String [] ListaConguentesPainted_I = [];
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
Object [] ListaSeleccionados_Merges_I = [];//Almacena los nodos que se encuentran seleccionados en el momento de merges y izquierda
Object [] ListaSeleccionados_Merges_D = [];//Almacena los nodos que se encuentran seleccionados en el momento de merges y derecha

boolean found = false;

////////////////////////////////Functions///////////////////////////////////
void setNames(name1,name2){
    archivo1 = name1;
    archivo2 = name2;
}

//This function setup the configuration values of the frame 
void setup(){ 
  background(255);       
  izquierdos = nodesLeft;
  derechos = nodesRight; 
  nodosIzquierdos = new Node[izquierdos.length];
  nodosDerechos = new Node[derechos.length];   
  //agglomeration = new Node[izquierdos.length+derechos.length];  
  smooth();
  //Here load the nodes
  loadNodes(izquierdos,true);
  loadNodes(derechos,false);
  size (availableWidth,availableHeight+((nodesLeft.length+nodesRight.length)*15));
  Splits();
  getMergers();
  Moves();
  Exclusiones();
  News()
  Congruencia(); 
  if (nodosIzquierdos.length > 0 && nodosDerechos.length > 0){ 
      ListaPosiciones_I = new ListaPosiciones_I[nodosIzquierdos.length-1]; 
      ListaPosiciones_D = new ListaPosiciones_D[nodosDerechos.length-1]; 
  }
  Congruence = false;
  moves = false;
  renames = false;
  exclusiones = false;
  nuevos = false;
  splits = false;
  merges = false;
}

void draw(){   
  myFont = createFont("Times New Roman", 14);
  textFont(myFont); 
  translate(translateX,translateY);
  scale(scaleFactor);  
  background(255);
  createAgglomeration(izquierdos,derechos);     
  textSize(12);
  fill(130,80, 64);
  text(archivo1,-300,300);  
  fill(223, 209, 33);
  text(archivo2,450,300); 
  stroke(149,153,149);
  strokeWeight(-5);
  for (int i = 0; i < nodosTenues.length; i++){
    if (nodosTenues[i].children != undefined){
      CalcularPosicionesLineas(i);
    }
  }  
  Paleta_Colores();
}

void keyPressed() {
  if (key == 'r' ||  key == 'R') {
  scaleFactor = 1.0;
  translateX = screen.width/2-200;
  translateY = 0.0;
  }
  if (key == 'i' || key == 'I'){
    scaleFactor += 0.03;
  }
  if (key == 'o' || key == 'O'){
    scaleFactor -= 0.03;
  }
}

void mouseDragged(MouseEvent e) {
  translateX += mouseX - pmouseX;
  translateY += mouseY - pmouseY;
}

void cargarColores(){
  for(int nodeLeft=0;nodeLeft<nodosIzquierdos;nodeLeft++){    
    izquierdos[nodeLeft].R = nodosIzquierdos[nodeLeft].R;    
    izquierdos[nodeLeft].G = nodosIzquierdos[nodeLeft].G;
    izquierdos[nodeLeft].B = nodosIzquierdos[nodeLeft].B;
  }

  for(int nodeRight=0;nodeRight<nodosDerechos;nodeRight++){
    derechos[nodeRight].R = nodosDerechos[nodeRight].R;    
    derechos[nodeRight].G = nodosDerechos[nodeRight].G;
    derechos[nodeRight].B = nodosDerechos[nodeRight].B;
  } 
}

void createAgglomeration(leftStructure,rightStructure){  
  Object [] agglomeration = [];

  for(int node=0;node<leftStructure.length;node++){  
    
    if(leftStructure[node].has_parent=="yes"){             
      //println("Append "+ leftStructure[node].name + " parent IZQUIERDA");
      append(agglomeration, leftStructure[node]);     
      
      for(int nodeTwo=0;nodeTwo<rightStructure.length;nodeTwo++){
        
        if(rightStructure[nodeTwo].name == leftStructure[node].name){

          if(rightStructure[nodeTwo].has_parent=="yes"){
            //println("ENCONTRE MISMO NODO DERECHA " + leftStructure[nodeTwo].name + ", EVALUO SIGUIENTE");
            found = true;
          }                 
        }                                 
        
        else{

          if(found){
            if(rightStructure[nodeTwo].has_parent=="yes"){
              //println("ENCONTRE PADRE SEGUIDO " + rightStructure[nodeTwo].name + ", ME SALGO DE LA DERECHA"); 
              nodeTwo = rightStructure.length;
            }            
            else {
              //println("Append "+ rightStructure[nodeTwo].name + "NO parent DERECHA"); 
              append(agglomeration, rightStructure[nodeTwo]);
            }
          }         
        }
      }
      found = false;
    } 
    else{            
      //println("Append "+ leftStructure[node].name + " NO parent IZQUIERDA"); 
      append(agglomeration, leftStructure[node]);     
    }
  }    

  int AbsoluteY = 20; 
  
  for(int nodeLeft=0;nodeLeft<nodosIzquierdos.length;nodeLeft++){        
    izquierdos[nodeLeft].R = nodosIzquierdos[nodeLeft].R;    
    izquierdos[nodeLeft].G = nodosIzquierdos[nodeLeft].G;
    izquierdos[nodeLeft].B = nodosIzquierdos[nodeLeft].B;    
  }

  for(int nodeRight=0;nodeRight<nodosDerechos.length;nodeRight++){
    derechos[nodeRight].R = nodosDerechos[nodeRight].R;    
    derechos[nodeRight].G = nodosDerechos[nodeRight].G;
    derechos[nodeRight].B = nodosDerechos[nodeRight].B;
  }
  nodosTenues = agglomeration;
  int posI = 1;
  int posD = 1;
  for (int i = 0; i < agglomeration.length; i++){ 
    if(agglomeration[i]==null){
      break
    }
    else{
     if(agglomeration[i].position=="left"){
        fill(130,80, 64);
        if (splitsG){
          int r = agglomeration[i].R;
          int g = agglomeration[i].G;
          int b = agglomeration[i].B;
          if (r == 255 && g == 13 && b == 255){
            fill(agglomeration[i].R, agglomeration[i].G, agglomeration[i].B);
          }
        }
        if (splits){
          for (int s = 0; s < ListaSeleccionados_Splits_I.length; s++){
            if (agglomeration[i].name == ListaSeleccionados_Splits_I[s].name){
              int r = agglomeration[i].R;
              int g = agglomeration[i].G;
              int b = agglomeration[i].B;
              if (r == 255 && g == 13 && b == 255){
                fill(agglomeration[i].R, agglomeration[i].G, agglomeration[i].B);
              }
            }
          }
        }
        if (mergersG){
          int r = agglomeration[i].R;
          int g = agglomeration[i].G;
          int b = agglomeration[i].B;
          if (r == 255 && g == 166 && b == 86){
            fill(agglomeration[i].R, agglomeration[i].G, agglomeration[i].B);
          }
        }
        if (movesG){
          int r = agglomeration[i].R;
          int g = agglomeration[i].G;
          int b = agglomeration[i].B;
          if (r == 9 && g == 212 && b == 212){
            fill(agglomeration[i].R, agglomeration[i].G, agglomeration[i].B);
          }
        }
        if(merges){
          for (int m = 0; m < ListaSeleccionados_Merges_I.length; m++){
            if (agglomeration[i].name == ListaSeleccionados_Merges_I[m].name){
              int r = agglomeration[i].R;
              int g = agglomeration[i].G;
              int b = agglomeration[i].B;
              if (r == 255 && g == 166 && b == 86){
                fill(agglomeration[i].R, agglomeration[i].G, agglomeration[i].B);
              }
            }
          }
        }
        if (moves){
          for (int m = 0; m < ListaSeleccionados_Moves_I.length; m++){
            if (agglomeration[i].name == ListaSeleccionados_Moves_I[m].name){
              int r = agglomeration[i].R;
              int g = agglomeration[i].G;
              int b = agglomeration[i].B;
              if (r == 9 && g == 212 && b == 212){
                fill(agglomeration[i].R, agglomeration[i].G, agglomeration[i].B);
              }
            }
          }
        }
        if (renamesG){
          int r = agglomeration[i].R;
          int g = agglomeration[i].G;
          int b = agglomeration[i].B;
          if (r == 234 && g == 170 && b == 165){
            fill(agglomeration[i].R, agglomeration[i].G, agglomeration[i].B);
          }
        }
        if (renames){
          for (int r = 0; r < ListaSeleccionados_Rename_I.length; r++){
            if (agglomeration[i].name == ListaSeleccionados_Rename_I[r].name){
              int r = agglomeration[i].R;
              int g = agglomeration[i].G;
              int b = agglomeration[i].B;
              if (r == 234 && g == 170 && b == 165){
                fill(agglomeration[i].R, agglomeration[i].G, agglomeration[i].B);
              }
            }
          }
        }
        if (exclusionsG){
            int r = agglomeration[i].R;
            int g = agglomeration[i].G;
            int b = agglomeration[i].B;
            if (r == 223 && g == 1 && b == 1){
              fill(agglomeration[i].R, agglomeration[i].G, agglomeration[i].B);
            }
        }
        if (exclusiones){
          for (int e = 0; e < ListaSeleccionados_Exclusiones.length; e++){
            if (agglomeration[i].name == ListaSeleccionados_Exclusiones[e].name){
              int r = agglomeration[i].R;
              int g = agglomeration[i].G;
              int b = agglomeration[i].B;
              if (r == 223 && g == 1 && b == 1){
                fill(agglomeration[i].R, agglomeration[i].G, agglomeration[i].B);
              }
            }
          }
        }
        if (conguencyG ){
          int r = agglomeration[i].R;
          int g = agglomeration[i].G;
          int b = agglomeration[i].B;
          if (r == 14 && g == 80 && b == 217){
            fill(agglomeration[i].R, agglomeration[i].G, agglomeration[i].B);
          }
        }
        if (Congruence){
          for (int c = 0; c < ListaSeleccionados_Conguentres_I.length; c++){
            if (ListaSeleccionados_Conguentres_I[c].name == agglomeration[i].name){
              int r = agglomeration[i].R;
              int g = agglomeration[i].G;
              int b = agglomeration[i].B;
              if (r == 14 && g == 80 && b == 217){
                fill(agglomeration[i].R, agglomeration[i].G, agglomeration[i].B);
              }
            }
          }

        }
        text(agglomeration[i].name, agglomeration[i].x+30,AbsoluteY+20);
        fill(166, 166, 166);
        if (i > 1){
          text(" ― ",  agglomeration[i].x+2,AbsoluteY+20);
        }
        ListaPosiciones_I[posI] = new Posiciones(agglomeration[i].name, agglomeration[i].x+30,AbsoluteY+20);
        posI = posI+1;
        AbsoluteY = AbsoluteY+20;
      }
     else{
        fill(223, 209, 33);
        if (splitsG){
          int r = agglomeration[i].R;
          int g = agglomeration[i].G;
          int b = agglomeration[i].B;
          if (r == 181 && g == 9 && b == 95){
            fill(agglomeration[i].R, agglomeration[i].G, agglomeration[i].B);
          }
        }
        if (splits){
          for (int s = 0; s < ListaSeleccionados_Splits_D.length; s++){
            if (agglomeration[i].name == ListaSeleccionados_Splits_D[s].name){
              int r = agglomeration[i].R;
              int g = agglomeration[i].G;
              int b = agglomeration[i].B;
              if (r == 181 && g == 9 && b == 95){
                fill(agglomeration[i].R, agglomeration[i].G, agglomeration[i].B);
              }
            }
          }
        }
         if (mergersG){
          int r = agglomeration[i].R;
          int g = agglomeration[i].G;
          int b = agglomeration[i].B;
          if (r == 255 && g == 101 && b == 54){
            fill(agglomeration[i].R, agglomeration[i].G, agglomeration[i].B);
          }
        }
        if (merges){
          for (int m = 0; m < ListaSeleccionados_Merges_D.length; m++){
            if (agglomeration[i].name == ListaSeleccionados_Merges_D[m].name){
              int r = agglomeration[i].R;
              int g = agglomeration[i].G;
              int b = agglomeration[i].B;
              if (r == 255 && g == 101 && b == 54){
                fill(agglomeration[i].R, agglomeration[i].G, agglomeration[i].B);
              }
            }
          }
        }
        if (movesG){
          int r = agglomeration[i].R;
          int g = agglomeration[i].G;
          int b = agglomeration[i].B;
          if (r == 5 && g == 143 && b == 135){
            fill(agglomeration[i].R, agglomeration[i].G, agglomeration[i].B);
          }
        }
        if (moves){
          for (int m = 0; m < ListaSeleccionados_Moves_D.length; m++){
            if (agglomeration[i].name == ListaSeleccionados_Moves_D[m].name){
            int r = agglomeration[i].R;
            int g = agglomeration[i].G;
            int b = agglomeration[i].B;
              if (r == 5 && g == 143 && b == 135){
                fill(agglomeration[i].R, agglomeration[i].G, agglomeration[i].B);
              }
            }
          }
        }
        if (renamesG){
            int r = agglomeration[i].R;
            int g = agglomeration[i].G;
            int b = agglomeration[i].B;
            if (r == 255  && g == 139 && b == 148){
              fill(agglomeration[i].R, agglomeration[i].G, agglomeration[i].B);
            }
        }
        if (renames){
           for (int r = 0; r < ListaSeleccionados_Rename_D.length; r++){
            if (agglomeration[i].name == ListaSeleccionados_Rename_D[r].name){
              int r = agglomeration[i].R;
              int g = agglomeration[i].G;
              int b = agglomeration[i].B;
              if (r == 255  && g == 139 && b == 148){
                fill(agglomeration[i].R, agglomeration[i].G, agglomeration[i].B);
              }
            }
          }
        }
         if (newsG){
            int r = agglomeration[i].R;
            int g = agglomeration[i].G;
            int b = agglomeration[i].B;
            if (r == 7 && g == 101 && b == 0){
              fill(agglomeration[i].R, agglomeration[i].G, agglomeration[i].B);
            }
        }
        if (nuevos){
           for (int n = 0; n < ListaSeleccionados_Nuevos.length; n++){
            if (agglomeration[i].name == ListaSeleccionados_Nuevos[n].name){
              int r = agglomeration[i].R;
              int g = agglomeration[i].G;
              int b = agglomeration[i].B;
              if (r == 7 && g == 101 && b == 0){
                fill(agglomeration[i].R, agglomeration[i].G, agglomeration[i].B);
              }
            }
          }
        }
        if (conguencyG){
          int r = agglomeration[i].R;
          int g = agglomeration[i].G;
          int b = agglomeration[i].B;
          if (r == 13 && g == 34 && b == 102){
            fill(agglomeration[i].R, agglomeration[i].G, agglomeration[i].B);
          }
        }
        if (Congruence){
          for (int c = 0; c < ListaSeleccionados_Conguentres_D.length; c++){
            if (agglomeration[i].name == ListaSeleccionados_Conguentres_D[c].name){
              int r = agglomeration[i].R;
              int g = agglomeration[i].G;
              int b = agglomeration[i].B;
              if (r == 13 && g == 34 && b == 102){
                fill(agglomeration[i].R, agglomeration[i].G, agglomeration[i].B);
              }
            }
          }
        }
         if (conguencyG){
          int r = agglomeration[i].R;
          int g = agglomeration[i].G;
          int b = agglomeration[i].B;
          if (r == 13 && g == 34 && b == 102){
            fill(agglomeration[i].R, agglomeration[i].G, agglomeration[i].B);
          }
        }
        text(agglomeration[i].name, agglomeration[i].x+30, AbsoluteY+20);
        fill(166, 166, 166);
        text(" ― ",  agglomeration[i].x+2,AbsoluteY+20)
        ListaPosiciones_D[posD] = new Posiciones(agglomeration[i].name, agglomeration[i].x+30, AbsoluteY+20);
        posD = posD+1;   
        AbsoluteY = AbsoluteY+20;
      }
    }     
  } 
}

void Paleta_Colores(){
  textSize(12)
  //Color Congruence left
  noStroke();
  fill(14, 80, 217);
  ellipse(650, 50, 15, 15);
  //Color Congruence right
  fill(26, 4, 127);
  ellipse(770, 50, 15, 15);
   //Color Splits left
  fill(181, 9, 95);
  ellipse(770, 70, 15, 15);
  //Color Splits right
  fill(255, 13, 255);
  ellipse(650, 70, 15, 15);
   //Color Merges left
  fill(255, 166, 86);
  ellipse(650, 90, 15, 15);
  //Color Merges right
  fill(255, 101, 54);
  ellipse(770, 90, 15, 15);
  //Color Moves left
  fill(9, 212, 212);
  ellipse(650, 110, 15, 15);
  //Color Moves right
  fill(5, 143, 135);
  ellipse(770, 110, 15, 15);
   //Color Renames left
  fill(234, 170, 165);
  ellipse(650, 130, 15, 15);
  //Color Renames right
  fill(255, 139, 148);
  ellipse(770, 130, 15, 15);
  //Color Exclusiones 
  fill(208, 1, 1);
  ellipse(650, 150, 15, 15);
  //Color News 
  fill(7, 101, 0);
  ellipse(650, 170, 15, 15);

  fill(0);
  text(" is congruent with ", 665, 52);
  text("split into", 685, 72);
  text("merged into", 680, 92);
  text("was moved to", 675, 112);
  text("was renamed to", 675, 132);
  text("excluded", 685, 152);
  text("new", 695, 172);
  text("Legend", 695, 22);
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


void mouseClicked() {
  ListaConguentesPainted_I = [];
  //Clean the variables that have the selected nodess
  ListaSeleccionados_Conguentres_I = [];
  ListaSeleccionados_Conguentres_D = [];
  ListaSeleccionados_Moves_I = [];
  ListaSeleccionados_Moves_D = [];
  ListaSeleccionados_Rename_I = [];
  ListaSeleccionados_Rename_D = [];
  ListaSeleccionados_Exclusiones = [];
  ListaSeleccionados_Nuevos = [];
  ListaSeleccionados_Splits_I =  [];
  ListaSeleccionados_Splits_D = [];
  ListaSeleccionados_Merges_I = [];
  ListaSeleccionados_Merges_D = [];
  //Clean to turn off the sliders (autoClickSlider.js)
  autoClickNuevos_OFF();
  autoClickCongruence_OFF();
  autoClickSplits_OFF();
  autoClickMerges_OFF();
  autoClickMoves_OFF();
  autoClickRenames_OFF();
  autoClickExclusion_OFF();
  autoClickAll_OFF();
  //Set to false the flags, anything painted before click
  conguencyG = false;
  newsG = false;
  exclusionsG = false;
  renamesG = false;
  movesG = false;
  mergersG = false;
  splitsG = false;
  int y = (mouseY - translateY) * (1/scaleFactor);
  int x = (mouseX - translateX) * (1/scaleFactor);
  Calcular_Nodo_Seleccionado(x,y); 
}


//Verify wich nodes are selected
void Calcular_Nodo_Seleccionado(x, y){
  //Clean boolean flags to clear the canvas
  Congruence = false;
  moves = false;
  renames = false;
  exclusiones = false;
  nuevos = false;
  splits = false;
  merges = false;
  boolean existe_Elemento = false;
  for (int i = 1; i < ListaPosiciones_I.length; i++){
    if ((y <= ListaPosiciones_I[i].y && y >= ListaPosiciones_I[i].y-25) && (x > ListaPosiciones_I[i].x && x < (ListaPosiciones_I[i].x+15 + textWidth(ListaPosiciones_I[i].name)))){
      Congruencia_Selected(ListaPosiciones_I[i].name);
      Moves_Selected(false,ListaPosiciones_I[i].name,true);
      Moves_Selected(true,ListaPosiciones_I[i].name,true);
      Exclusiones_Selected(ListaPosiciones_I[i].name);
      News_Selected(ListaPosiciones_I[i].name);
      Splits_Selected(ListaPosiciones_I[i].name, true);
      getMergers_Selected(ListaPosiciones_I[i].name, true);
      return;
    }
  }
  for (int i = 1; i < ListaPosiciones_D.length; i++){
    if ((y <= ListaPosiciones_D[i].y && y >= ListaPosiciones_D[i].y-25) && (x > ListaPosiciones_D[i].x && x < (ListaPosiciones_D[i].x+15 + textWidth(ListaPosiciones_D[i].name)))){
      Congruencia_Selected(ListaPosiciones_D[i].name);
      Moves_Selected(false,ListaPosiciones_D[i].name,false);
      Moves_Selected(true,ListaPosiciones_D[i].name,false);
      News_Selected(ListaPosiciones_D[i].name);
      Splits_Selected(ListaPosiciones_D[i].name, false);
      getMergers_Selected(ListaPosiciones_D[i].name, false);
      return;
    }
  }
}

//Funcion para cargar los nodos al un arreglo de nodos
//si flag es true entonces cargar los izquierdos si es false carga los derechos
void loadNodes(nodos,flag){
  int y = round((availableHeight-40)/nodos.length);
  for (int i = 0; i < nodos.length; i++){
    if (flag){
      nodosIzquierdos[i] = new Node(nodos[i].name, nodos[i].x+300,y,nodos[i].Synonym,nodos[i].author, nodos[i].record_scrutiny_date, nodos[i].partent, nodos[i].position);
      y += round((availableHeight-40)/nodos.length);
    }
    else{
      nodosDerechos[i] = new Node(nodos[i].name, nodos[i].x+900,y,nodos[i].Synonym,nodos[i].author, nodos[i].record_scrutiny_date, nodos[i].partent, nodos[i].position);
      y += round((availableHeight-40)/nodos.length);
    }
  }
}


////////////////////////////////////////////////////////////////////////
//Set color splits
void verificarSinonimos(arreglo,nombre){
    for (int i=0; i<arreglo.length;i++){
        if (arreglo[i] == nombre){
            return true;
        }
    }
    return false;
}


int cantidadSplits = 0;
void Splits(){
  Object [] splitsL = [];
  Object [] splitsR = [];
  Node [] derechos = [];
  cantidadSplits = 0;
  for (int i = 0;i<nodosIzquierdos.length;i++){
    String name = nodosIzquierdos[i].name;
    String autor = nodosIzquierdos[i].author;
    String date = nodosIzquierdos[i].record_scrutiny_date;
    append(splitsL,nodosIzquierdos[i]);
    int cont = 0;
    for (int j = 0;j<nodosDerechos.length;j++){
      if ((name == nodosDerechos[j].name || verificarSinonimos(nodosDerechos[j].Synonym,name)) && autor == nodosDerechos[j].author && date == nodosDerechos[j].record_scrutiny_date){
        cont= cont+1;
        append(splitsR,nodosDerechos[j]);
      }
    }
     if (cont>1){
        for (int left = 0;left<nodosIzquierdos.length;left++){
          for (int leftAux = 0;leftAux<splitsL.length;leftAux++){
            if (nodosIzquierdos[left].name == splitsL[leftAux].name){
              cantidadSplits = cantidadSplits+1;
              nodosIzquierdos[left].setRGB(255,13,255);
            }
          }
        }
         for (int right = 0;right<nodosDerechos.length;right++){
          for (int rightAux = 0;rightAux<splitsR.length;rightAux++){
            if (nodosDerechos[right].name == splitsR[rightAux].name){
              nodosDerechos[right].setRGB(181,9,95);
            }
          }
        }
        splitsR=[];
        splitsL=[];
        derechos = [];
     }
     splitsR=[];
     splitsL=[];
  }
}

void Splits_Selected(nombre,taxonomia){
  Object [] splitsL = [];
  Object [] splitsR = [];
  Node [] derechos = [];
  cantidadSplits = 0;
  for (int i = 0;i<nodosIzquierdos.length;i++){
    String name = nodosIzquierdos[i].name;
    String autor = nodosIzquierdos[i].author;
    String date = nodosIzquierdos[i].record_scrutiny_date;
    append(splitsL,nodosIzquierdos[i]);
    int cont = 0;
    for (int j = 0;j<nodosDerechos.length;j++){
      if ( (name == nodosDerechos[j].name || verificarSinonimos(nodosDerechos[j].Synonym,name)) && autor == nodosDerechos[j].author && date == nodosDerechos[j].record_scrutiny_date){
        cont= cont+1;
        append(splitsR,nodosDerechos[j]);
      }
    }
     if (cont>1){
      splits = true;
      if (taxonomia){
        boolean subarbol = false;
         for (int verify = 0;verify<splitsR.length;verify++){
          if (existe_Elemento_Array(nombre, buscar_padres(splitsR[verify].name, nodesRight))){
            subarbol = true;
          }
         }
        for (int left = 0;left<nodosIzquierdos.length;left++){
          for (int leftAux = 0;leftAux<splitsL.length;leftAux++){
            if (nodosIzquierdos[left].name == splitsL[leftAux].name && (splitsL[leftAux].name == nombre 
              || existe_Elemento_Array(nombre, buscar_padres(nodosIzquierdos[left].name, izquierdos))
              || subarbol ) ){
              cantidadSplits = cantidadSplits+1;
              //JavaScript function to turn on the slider (autoClickSlider.js)
              autoClickSplits_ON();
              append(ListaSeleccionados_Splits_I,nodosIzquierdos[left]);
              for (int right = 0; right<splitsR.length;right++){
                append(ListaSeleccionados_Splits_D,splitsR[right]);
              }
            }
          }
        }
      }
      else{
        boolean verificado = false;
        //Verify if the selected node exist y a less one element of right splits and if exist add the right node
        for (int verify = 0;verify<splitsR.length;verify++){
          if (splitsR[verify].name == nombre){
            verificado = true;
            for (int left = 0; left<splitsL.length;left++){
              //JavaScript function to turn on the slider (autoClickSlider.js)
              autoClickSplits_ON();
              append(ListaSeleccionados_Splits_I,splitsL[left]);
            }
          }
        }
         for (int right = 0;right<nodosDerechos.length;right++){
          for (int rightAux = 0;rightAux<splitsR.length;rightAux++){
            if (nodosDerechos[right].name == splitsR[rightAux].name && verificado){
              append(ListaSeleccionados_Splits_D,splitsR[rightAux]);
              //nodosDerechos[right].setRGB(181,9,95);
            }
          }
        }
      } 
        splitsR=[];
        splitsL=[];
        derechos = [];
     }
     splitsR=[];
     splitsL=[];
  }
}

int returnAmountSplits(){
    return cantidadSplits;
}

//////////////////////////////////////////////////////////////////////////
//Function set color merges

boolean existeNombre_Complejo(nombre,autor,date){
    Object [] izquierdos = nodosIzquierdos;
    for (int nodeL = 0; nodeL < izquierdos.length; nodeL++) {
        if(izquierdos[nodeL].name == nombre){
            append(izquierdo,izquierdos[nodeL]);
            return false;
        }
    }
    return true;
}

object [] izquierdo = [];
int cantidadMergers = 0;

int returnCantidadMergers(){
    return cantidadMergers;
}

void getMergers(){
  cantidadMergers = 0;
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
            //Color Merges left
          if (cont > 1){
            cantidadMergers = cantidadMergers+1;
            nodosDerechos[nodeR].setRGB(255,101,54);
            for (int i = 0; i < nodosIzquierdos.length; i++){
              for (int j = 0; j < izquierdo.length; j++){
                if (nodosIzquierdos[i].name == izquierdo[j].name){
                  nodosIzquierdos[i].setRGB(255,166,86);
                }
              }
            }
          }
          izquierdo = []; 
      } 
   }
}

//This function is used when merge nodes is clicked
void getMergers_Selected(nombre, taxonomia){
  izquierdo = []; 
  cantidadMergers = 0;
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
            if(taxonomia == false){
              if (nodosDerechos[nodeR].name == nombre){
                merges = true;
                cantidadMergers = cantidadMergers+1;
                //JavaScript function to turn on the slider (autoClickSlider.js)
                autoClickSplits_ON();
                append(ListaSeleccionados_Merges_D,nodosDerechos[nodeR]);
                for (int i = 0; i < nodosIzquierdos.length; i++){
                  for (int j = 0; j < izquierdo.length; j++){
                    if (nodosIzquierdos[i].name == izquierdo[j].name){
                      append(ListaSeleccionados_Merges_I,izquierdo[j]);
                    }
                  }
                }
              }
            }
            else{
              boolean subarbol = false;
              boolean verificado = false;
              for (int j = 0; j < izquierdo.length; j++){
                if (existe_Elemento_Array(nombre, buscar_padres(izquierdo[j].name, izquierdos))){
                  subarbol = true;
                }
                if (nombre == izquierdo[j].name || subarbol){
                  verificado = true;
                  merges = true;
                  //JavaScript function to turn on the slider (autoClickSlider.js)
                  autoClickMerges_ON();
                  append(ListaSeleccionados_Merges_D,nodosDerechos[nodeR]);
                }
              }
              if (verificado){
                 for (int j = 0; j < izquierdo.length; j++){
                    append(ListaSeleccionados_Merges_I,izquierdo[j]);
                  }
              }

            } 
            
          }
          izquierdo = []; 
      } 
   }
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

int cantidadRenames = 0;
int cantidadMoves = 0;

int returnMoves(){
    return cantidadMoves;
}

int returnRenames(){
    return cantidadRenames;
}

//Find the moves of slider buttoms
void Moves(){
   Object [] Derechos = [];
   Object [] Izquierdos = [];
   Object [] listaIzquierdosM = [];
   Object [] listaDerechosM = [];
   Object [] listaIzquierdosR = [];
   Object [] listaDerechosR = [];
   for (int nodeL = 0; nodeL < izquierdos.length;nodeL++){
      int cont = 0;
      String nameL = izquierdos[nodeL].name;
      String autorL = izquierdos[nodeL].author;
      String dateL = izquierdos[nodeL].record_scrutiny_date;
      for (nodeR=0;nodeR<nodosDerechos.length;nodeR++){
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
            cantidadMoves = cantidadMoves+1;
            append(listaIzquierdosM,Izquierdos[0]);
            append(listaDerechosM,Derechos[0]);
          }
          else{
            cantidadRenames = cantidadRenames+1;
            append(listaIzquierdosR,Izquierdos[0]);
            append(listaDerechosR,Derechos[0]);

          }
        }
      }
      Izquierdos = [];
      Derechos = [];
    }
    for (int left = 0; left < nodosIzquierdos.length; left++){
      for (int leftAux = 0; leftAux < listaIzquierdosM.length; leftAux++){
        if (nodosIzquierdos[left].name == listaIzquierdosM[leftAux].name){
           nodosIzquierdos[left].setRGB(9,212,212);
        }
      }
    }
    for (int left = 0; left < nodosDerechos.length; left++){
      for (int leftAux = 0; leftAux < listaDerechosM.length; leftAux++){
        if (nodosDerechos[left].name == listaDerechosM[leftAux].name){
           nodosDerechos[left].setRGB(5,143,135);
        }
      }
    }
    for (int left = 0; left < nodosIzquierdos.length; left++){
      for (int leftAux = 0; leftAux < listaIzquierdosR.length; leftAux++){
        if (nodosIzquierdos[left].name == listaIzquierdosR[leftAux].name){
           nodosIzquierdos[left].setRGB(234,170,165);
        }
      }
    }
    for (int left = 0; left < nodosDerechos.length; left++){
      for (int leftAux = 0; leftAux < listaDerechosR.length; leftAux++){
        if (nodosDerechos[left].name == listaDerechosR[leftAux].name){
           nodosDerechos[left].setRGB(255,139,148);
        }
      }
    }
  }

//Find the moves and renames of seleted node
void Moves_Selected(bandera, nombre, taxonomia){
   Object [] Derechos = [];
   Object [] Izquierdos = [];
   Object [] listaIzquierdosM = [];
   Object [] listaDerechosM = [];
   Object [] listaIzquierdosR = [];
   Object [] listaDerechosR = [];
   for (int nodeL = 0; nodeL < izquierdos.length;nodeL++){
      int cont = 0;
      int cantidadNodos = 0;
      String nameL = izquierdos[nodeL].name;
      String autorL = izquierdos[nodeL].author;
      String dateL = izquierdos[nodeL].record_scrutiny_date;
      for (nodeR=0;nodeR<nodosDerechos.length;nodeR++){
          boolean subarbol = false;
          if (existe_Elemento_Array(nombre, buscar_padres(izquierdos[nodeL].name, izquierdos))){
            subarbol = true;
          }
          if (existe_Elemento_Array(nombre, buscar_padres(derechos[nodeR].name, derechos))){
            subarbol = true;
          }
          String [] sinonimos = nodosDerechos[nodeR].Synonym;
          String nombreR = nodosDerechos[nodeR].name;
          String autorR = nodosDerechos[nodeR].author;
          String fechaR = nodosDerechos[nodeR].record_scrutiny_date;
          if (sinonimos.length == 1){
            if (taxonomia){
              if (nameL  == sinonimos[0] && autorL == autorR){
                cont = cont+1;
              }
              if ((nameL  == sinonimos[0] && autorL == autorR) && (nameL == nombre  || subarbol)){
                cont = cont+1; //Exist one move
                append(Derechos,nodosDerechos[nodeR]);
                append(Izquierdos,izquierdos[nodeL]);
              }
            }
            else{
              if (nameL  == sinonimos[0] && autorL == autorR ){
                cont = cont+1;
              }
              if ((nameL  == sinonimos[0] && autorL == autorR ) && (nombreR == nombre  || subarbol)){
                cont = cont+1;
                append(Derechos,nodosDerechos[nodeR]);
                append(Izquierdos,izquierdos[nodeL]);
              }
            }    
          }
          else{ 
            int existe = 0;
            for (int i=0;i<sinonimos.length;i++){
              if(existeNombre(izquierdos,sinonimos[i])==false){
                if (taxonomia){
                  existe = existe+1;
                  if (nameL == sinonimos[i] && autorL == autorR){
                    cont = cont +1;
                  }
                  if (nameL == sinonimos[i] && autorL == autorR && (nameL == nombre  || subarbol) && existe == 0){
                    cont = cont+1;
                    append(Derechos,nodosDerechos[nodeR]);
                    append(Izquierdos,izquierdos[nodeL]);
                  }
                }
                else{
                  existe = existe+1;
                  if (nameL == sinonimos[i] && autorL == autorR){
                    cont = cont +1;
                  }
                  if (nameL == sinonimos[i] && autorL == autorR && (nombreR == nombre  || subarbol) && existe == 0){
                    cont = cont+1;
                    append(Derechos,nodosDerechos[nodeR]);
                    append(Izquierdos,izquierdos[nodeL]);
                  }
                }
            }
          }
        }
      }
      if (cont == 2){
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
             moves = true;
            cantidadMoves = cantidadMoves+1;
            //JavaScript function to turn on the slider (autoClickSlider.js)
            autoClickMoves_ON();
            append(ListaSeleccionados_Moves_I,Izquierdos[0]);
            append(ListaSeleccionados_Moves_D,Derechos[0]);
          }
          else{
            renames = true;
            //JavaScript function to turn on the slider (autoClickSlider.js)
            autoClickRenames_ON();
            cantidadRenames = cantidadRenames+1;
            append(ListaSeleccionados_Rename_I,Izquierdos[0]);
            append(ListaSeleccionados_Rename_D,Derechos[0]);

          }
        }
      }
      Izquierdos = [];
      Derechos = [];
    }
  }
//////////////////////////////////////////////////////////////////////////
//Set color exclusions

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

int cantidadExclusiones = 0;
void Exclusiones(){
  cantidadExclusiones = 0;
  for (int i = 0; i < nodosIzquierdos.length; i++){
    if (existeNombreComplejo(nodosDerechos, nodosIzquierdos[i].name, nodosIzquierdos[i].author, nodosIzquierdos[i].record_scrutiny_date)){
      nodosIzquierdos[i].setRGB(223,1,1);
      cantidadExclusiones = cantidadExclusiones+1;
    }
  }
}

void Exclusiones_Selected(nombre){
  cantidadExclusiones = 0;
  for (int i = 0; i < nodosIzquierdos.length; i++){
    boolean subarbol = false;
    if (existe_Elemento_Array(nombre, buscar_padres(izquierdos[i].name, izquierdos))){
      subarbol = true;
    }
    if ((existeNombreComplejo(nodosDerechos, nodosIzquierdos[i].name, nodosIzquierdos[i].author, nodosIzquierdos[i].record_scrutiny_date)) && (nombre == nodosIzquierdos[i].name || subarbol) ){
      exclusiones = true;
      //JavaScript function to turn on the slider (autoClickSlider.js)
      autoClickExclusion_ON();
      append(ListaSeleccionados_Exclusiones, nodosIzquierdos[i]);
      cantidadExclusiones = cantidadExclusiones+1;
    }
  }
}


int returnExclusiones(){
  return cantidadExclusiones;
}
/////////////////////////////////////////////////////////////////////////
//set color news
int cantidadNuevos = 0;

int returnNuevos(){
  return cantidadNuevos;
}

boolean existeNombre_ComplejoNuevos(nombre,autor){
    Object [] izquierdos = nodosIzquierdos;
    for (int nodeL = 0; nodeL < izquierdos.length; nodeL++) {
        if(izquierdos[nodeL].name == nombre && izquierdos[nodeL].author == autor){
            append(izquierdo,izquierdos[nodeL]);
            return false;
        }
    }
    return true;
}

void News(){
  cantidadNuevos = 0;
  for (int i = 0; i < nodosDerechos.length; i++){
    if (existeNombre_ComplejoNuevos(nodosDerechos[i].name,nodosDerechos[i].author)){
      String [] sinonimos = nodosDerechos[i].Synonym;
      if (sinonimos.length == 0){
        nodosDerechos[i].setRGB(7,101,0);
        cantidadNuevos = cantidadNuevos+1;
      }
      else{
        boolean flag = true;
        for (int j = 0; j < sinonimos.length; j++){
          if (existeNombre(nodosIzquierdos,sinonimos[j]) == false){
            flag = false;
          }
        }
        if (flag){
          nodosDerechos[i].setRGB(7,101,0);
           cantidadNuevos = cantidadNuevos+1;
        }
      }
    }
  }
}

void News_Selected(nombre){
  cantidadNuevos = 0;
  for (int i = 0; i < nodosDerechos.length; i++){
    boolean subarbol = false;
    if (existe_Elemento_Array(nombre, buscar_padres(derechos[i].name, derechos))){
      subarbol = true;
    }
    if ((existeNombre_ComplejoNuevos(nodosDerechos[i].name,nodosDerechos[i].author)) && (nombre == nodosDerechos[i].name || subarbol)) {
      String [] sinonimos = nodosDerechos[i].Synonym;
      if (sinonimos.length == 0){
        //JavaScript function to turn on the slider (autoClickSlider.js)
        autoClickNuevos_ON();
        append(ListaSeleccionados_Nuevos,nodosDerechos[i]);
        cantidadNuevos = cantidadNuevos+1;
        nuevos = true;
      }
      else{
        boolean flag = true;
        for (int j = 0; j < sinonimos.length; j++){
          if (existeNombre(nodosIzquierdos,sinonimos[j]) == false){
            flag = false;
          }
        }
        if (flag){
          nuevos = true;
          //JavaScript function to turn on the slider (autoClickSlider.js)
          autoClickNuevos_ON();
          append(ListaSeleccionados_Nuevos,nodosDerechos[i]);
          cantidadNuevos = cantidadNuevos+1;
        }
      }
    }
  }
}

////////////////////////////////////////////////////////////////
//set color congruence
int cantidadCongurentes = 0;

int returnCongruentes(){
  return cantidadCongurentes;
}

void Congruencia(){
  cantidadCongurentes = 0;
  for (int i = 1;i<nodosIzquierdos.length;i++){
    for (int j = 0;j<nodosDerechos.length;j++){
      if (nodosIzquierdos[i].name == nodosDerechos[j].name && nodosIzquierdos[i].author == nodosDerechos[j].author && nodosIzquierdos[i].record_scrutiny_date == nodosDerechos[j].record_scrutiny_date){
        String [] sinonimos = nodosDerechos[j].Synonym;
        if (sinonimos.length == 0){
            nodosIzquierdos[i].setRGB(14,80,217);
            nodosDerechos[j].setRGB(13,34,102);
            cantidadCongurentes += 1;
        }
        else{
          boolean falg = true;
          for (int s = 0; s < sinonimos.length; s++){
            if (sinonimos[s]==nodosIzquierdos[i].name){
                flag = false;
            }
          }
          if (flag){
              nodosIzquierdos[i].setRGB(14,80,217);
              nodosDerechos[j].setRGB(13,34,102);
              cantidadCongurentes += 1;
          }
        }
      }
      else if(nodosIzquierdos[i].name == nodosDerechos[j].name && nodosIzquierdos[i].author == nodosDerechos[j].author){
       String [] sinonimos = nodosDerechos[j].Synonym;
        if (sinonimos.length == 0){
            nodosIzquierdos[i].setRGB(14,80,217);
            nodosDerechos[j].setRGB(13,34,102);
            cantidadCongurentes += 1;
        }
        else{
          boolean falg = true;
          for (int s = 0; s < sinonimos.length; s++){
            if (sinonimos[s]==nodosIzquierdos[i].name){
                flag = false;
            }
          }
          if (flag){
              nodosIzquierdos[i].setRGB(14,80,217);
              nodosDerechos[j].setRGB(13,34,102);
              cantidadCongurentes += 1;
          }
        }
      }
    }
  }
}

//This function search congruents nodes, according to the selected name passed as parameter
void Congruencia_Selected(nombre){
  cantidadCongurentes = 0;
  for (int i = 1;i<nodosIzquierdos.length;i++){
    for (int j = 0;j<nodosDerechos.length;j++){
      boolean subarbol = false;
      if (existe_Elemento_Array(nombre, buscar_padres(nodosDerechos[j].name, derechos))){
        subarbol = true;
      }
      if (existe_Elemento_Array(nombre, buscar_padres(nodosIzquierdos[i].name, izquierdos))){
        subarbol = true;
      }
      if (nodosIzquierdos[i].name == nodosDerechos[j].name && nodosIzquierdos[i].author == nodosDerechos[j].author && (nombre == nodosIzquierdos[i].name || nombre == nodosDerechos[j].name || subarbol)){
        String [] sinonimos = nodosDerechos[j].Synonym;
        if (sinonimos.length == 0){
            cantidadCongurentes += 1;
            Congruence = true;
            //JavaScript function to turn on the slider (autoClickSlider.js)
            autoClickCongruence_ON();
            append(ListaSeleccionados_Conguentres_I,nodosIzquierdos[i]);
            append(ListaSeleccionados_Conguentres_D,nodosDerechos[j]);
        }
        else{
          boolean falg = true;
          for (int s = 0; s < sinonimos.length; s++){
            if (sinonimos[s]==nodosIzquierdos[i].name){
                flag = false;
            }
          }
          if (flag){
            Congruence = true;
            //JavaScript function to turn on the slider (autoClickSlider.js)
            autoClickCongruence_ON();
            append(ListaSeleccionados_Conguentres_I,nodosIzquierdos[i]);
            append(ListaSeleccionados_Conguentres_D,nodosDerechos[j]);
            cantidadCongurentes += 1;
          }
        }
      }
    }
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
  int R;
  int G;
  int B;
  Node(String nombre, int posx, int posy, String [] sin, String aut, String fec, String par, String pos){
    name = nombre;
    x = posx;
    y = posy;
    Synonym = sin;
    author = aut;
    record_scrutiny_date = fec;
    parent = par;
    position = pos;
  }
  void display(){
      text(name,x,y);
  }
  void setRGB(int r,int g,int b){
    R = r;
    G = g;
    B = b
  }
}


//////////////////////////LIENAS TENUES///////////////////////////////

int contadorNivel = 1;
int getNivel(nodo){
  if (nodo.parent == undefined){
    return contadorNivel;
  }
  else{
    contadorNivel+=1;
    getNivel(nodo.parent);
  }
}

void CalcularPosicionesLineas(int pos){
  contadorNivel = 1;
  getNivel(nodosTenues[pos]);
  int nodoNivel = contadorNivel;
  int y1 = 0;
  int y2 = 45;
  int limit = 0;
  for (int x = 0; x < pos; x++){
    y2+=20;
  } 
  y1 = y2 + 20; 
  limit = y1;

  for (int i = 0; i < nodosTenues.length; i++){
    contadorNivel = 1;
    getNivel(nodosTenues[i]);
    int elementoNivel = contadorNivel;
    if (elementoNivel == nodoNivel+1 && i > pos){
      limit = y1;
    }
    if ((elementoNivel == nodoNivel && i > pos) || (i == nodosTenues.length - 1)){
      line(nodosTenues[pos].x+26,limit-8,nodosTenues[pos].x+26,y2);
      return;
    }
    else if (elementoNivel > nodoNivel && i > pos){
      y1+=20;
    }
  }
}

class Posiciones{
  String name;
  int x;
  int y;
  Posiciones (String name_e, int x_e, int y_e){
    name = name_e;
    x = x_e;
    y = y_e;
  }
} 