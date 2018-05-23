int boxsize = 50;
int cols, rows;
color[][] colors;
int saved_i = -1;
int saved_j = -1;

//Banderas para verificacion de pintado o no de la matriz
boolean congruentes = false;
boolean splits = false;
boolean merges = false;
boolean moves = false;
boolean renames = false;
boolean iniciar = false;

boolean nuevos = false;
boolean exclusiones = false;

//Definicion de variables para uso de zoom
float scaleFactor = 0.3;
float translateX = 200.0;
float translateY = 350.0;

Object [] izquierdos = [];
Object [] derechos = [];

int[] widths = new int[izquierdos.length];
int maxWidth;

Object [] nodosIzquierdos; //Almacena la estructura de los nodos izquierdos
Object [] nodosDerechos;  //Almacena la estructura de los nodos derechos
Posiciones [] ListaPosiciones_I; //Guarda las posiciones logicas de cada nodo de la izquierda
Posiciones [] ListaPosiciones_D; //Guarda las posiciones logicas de cada nodo de la izquierda
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

//Nombre de los archivos o taxonomias que se encuentran cargadas
String archivo1 = "";
String archivo2 = "";

int posicion_inicio_left;
int posicion_final_left;

//Funciones de seteo de variables desde processing
void setNuevos(boolean value){
  nuevos = value;
}

void set_Inicio(boolean value){
  iniciar = value;
}

void setMoves(boolean value){
  moves = value;
}

void setRenames(boolean value){
  renames = value;
}

void setSplits(boolean value){
  splits = value;
}

void setMerges(boolean value){
  merges = value;
}

void setCongruence(boolean value){
  congruentes = value;
}

void setExclusiones(boolean value){
  exclusiones = value;
}

void setNames(name1,name2){
    archivo1 = name1;
    archivo2 = name2;
}

void setup() { 
  background(255); 
  merges = false;
  splits = false;
  renames = false;
  moves = false;
  congruentes = false;

  izquierdos = nodesLeft;
  derechos = nodesRight;

  size(availableWidth*2, availableHeight*3);  
  cols = derechos.length-1;
  rows = izquierdos.length-1;

  colors = new color[cols][rows];  
  for (int i=0; i<cols; i++) {
    for (int j=0; j<rows; j++) {
      colors[i][j] = color(255);
    }
  }  
  
  for (int i = 0;i<izquierdos.length;i++){
    widths[i] = textWidth(izquierdos[i].name);
  }
  
   try {
     maxWidth = max(widths);
  } catch (IOException e) {
    
  }
  

  nodosIzquierdos = nodesLeft;
     for (int i = 0;i < nodosIzquierdos.length;i++){
        String nombre = nodosIzquierdos[i].name;      
        if (nodosIzquierdos[i].children != null){
            nombre = nombre;
            nodosIzquierdos[i].name = nombre;
        }
    }
    nodosDerechos = nodesRight;
     for (int i = 0; i < nodosDerechos.length;i++){
        String nombre = nodosDerechos[i].name;
        if (nodosDerechos[i].children != null){
            nombre = nombre;
            nodosDerechos[i].name = nombre;
        }
    }
    if (nodosIzquierdos.length > 0 && nodosDerechos.length > 0){ 
      ListaPosiciones_I = new ListaPosiciones_I[nodosIzquierdos.length-1]; 
      ListaPosiciones_D = new ListaPosiciones_D[nodosDerechos.length-1]; 
    }
    
    
}

//variables to on click function
int x1, y1, x2, y2;
final static color BG = #4080A0;
Object selectedObject;
int posl = 0;
int posr = 0;
String selectedL = "";
String selectedR = "";

void draw() { 
  myFont = createFont("Times New Roman", 30);
  textFont(myFont);
  if (iniciar == true){
    background();
    translate(translateX,translateY);
    scale(scaleFactor);
    background(255);

    for (int i = 0;i<izquierdos.length;i++){
      widths[i] = textWidth(izquierdos[i].name);
    }
    textSize(40);
    fill(0);
   
   /* text(archivo1,-400,1000);
    text(archivo2,1400,-1000);
    */

    text(archivo1,-120,-80);

    textAlign(CENTER, CENTER);
    int largo_nombre = archivo2.length;
    int y_largo = -20;
    while(largo_nombre >= 0){
      //println(nombre[largo]);
      y_largo = y_largo-40;
      largo_nombre = largo_nombre -1;
      text(archivo2[largo_nombre],400,y_largo);
    }
    
    maxWidth = max(widths);

    //PROCEDIMIENTO PARA PINTAR LAS LINEAS
    stroke(107,110,107);
    for (int i = 0; i < nodosIzquierdos.length; i++){
      if (nodosIzquierdos[i].children != null){
        CalcularPosicionesLineas(i);
      }
    }
   // CalcularPosicionesLineas(1);


    stroke(0);
    for (int i=0; i<cols; i++) {
      for (int j=0; j<rows; j++) {
        fill(colors[i][j]);
        rect(i*boxsize+maxWidth+120, j*boxsize, boxsize, boxsize);      
      }
    }
     
    fill(0);
    textSize(30);
    smooth();
    nodosIzquierdos = nodesLeft;
    int yPrev = 0;
    
    for(int pos = 0; pos < nodosIzquierdos.length; pos++){
      fill(0);
      var existe = false;
      for (int i = 0; i < nodosDerechos.length; i++){
        if (nodosIzquierdos[pos].name == nodosDerechos[i].name && nodosIzquierdos[pos].author == nodosDerechos[i].author && pos > 0){
          existe = true;
        }
        else{
          String [] sinonimos = nodosDerechos[i].Synonym;
          for (int j = 0; j < sinonimos.length; j++){
            if (sinonimos[j] == nodosIzquierdos[pos].name){
              existe = true;
            }
          }
        }
      }
      if (existe == false && pos > 0 && exclusiones == true){
        fill(223,1,1);
      } 
      else{
            if (congruentes){
              for (int i = 1; i < nodosDerechos.length; i++){
                if (nodosIzquierdos[pos].name == nodosDerechos[i].name && nodosIzquierdos[pos].author == nodosDerechos[i].author && pos > 0){
                    fill(23, 18, 196);
                }
            }
          }
      } 

      if (merges){
         for (int m = 0; m < izquierdosPainted.length; m++){
          if (nodosIzquierdos[pos].name == izquierdosPainted[m].name){
            fill(255, 145, 0);
          }
        }
      }
      if (renames){
        for (int r = 0; r < RenameLPainted.length; r++){
          if (nodosIzquierdos[pos].name == RenameLPainted[r].name){
            fill(91, 255, 142);
          }
        }
      }
      if (moves){
         for (int m = 0; m < Move_LPainted.length; m++){
            if (nodosIzquierdos[pos].name == Move_LPainted[m].name){
              fill(10, 228, 237);
            }
          }
      }
      if (splits){
        for (int s = 0; s < splitslPainted.length; s++){
          if (nodosIzquierdos[pos].name == splitslPainted[s].name){
            fill(255, 0, 191);
          }
        } 
      }

      //Verifica si hubo o no click en un nodo de congruentes a la izquierda
      for (int p = 0; p < ListaSeleccionados_Conguentres_I.length; p++){
          if (nodosIzquierdos[pos].name == ListaSeleccionados_Conguentres_I[p].name){
            fill(23, 18, 196);
          }
      }

      //Verifica si hubo o no click en un nodo de moves a la izquierda
      for (int m = 0; m < ListaSeleccionados_Moves_I.length; m++){
        if (nodosIzquierdos[pos].name == ListaSeleccionados_Moves_I[m].name){
          fill(10, 228, 237);
        }
      }

      //Verifica si hubo o no click en un nodo de renames a la izquierda
      for (int r = 0; r < ListaSeleccionados_Rename_I.length; r++){
        if (nodosIzquierdos[pos].name == ListaSeleccionados_Rename_I[r].name){
          fill(91, 255, 142);
        }
      } 

      //Verifica si hubo o no click en un nodo de exclisions
      for (int r = 0; r < ListaSeleccionados_Exclusiones.length; r++){
        if (nodosIzquierdos[pos].name == ListaSeleccionados_Exclusiones[r].name){
          fill(223,1,1);
        }
      } 

      //Verifica si hubo o no click en un nodo de splits
      for (int s = 0; s < ListaSeleccionados_Splits_I.length; s++){
        if (nodosIzquierdos[pos].name == ListaSeleccionados_Splits_I[s].name){
          fill(255, 0, 191);
        }
      } 

      //Verifica si hubo o no click en un nodo de merges
      for (int m = 0; m < ListaSeleccionados_Merges_I.length; m++){
        if (nodosIzquierdos[pos].name == ListaSeleccionados_Merges_I[m].name){
          fill(255, 145, 0);
        }
      } 
      textAlign(LEFT);
      text(nodosIzquierdos[pos].name,nodosIzquierdos[pos].x-60,(nodosIzquierdos[pos].y*2.5)-50);
      fill(166, 166, 166);
      if (pos > 1){
        text("― ",nodosIzquierdos[pos].x-85,(nodosIzquierdos[pos].y*2.5)-50);
      }
      ListaPosiciones_I[pos] = new Posiciones(nodosIzquierdos[pos].name,nodosIzquierdos[pos].x-60,(nodosIzquierdos[pos].y*2.5)-50);      
    }      

    //rotate(-PI/2); //Si se quiere doblado hay q activarlo
    
    for(int pos = 0; pos < nodosDerechos.length; pos++){
      fill(0);
      var existe = false;
      for (int i = 0; i < nodosIzquierdos.length; i++){
        if (nodosDerechos[pos].name == nodosIzquierdos[i].name && nodosDerechos[pos].author == nodosIzquierdos[i].author && pos > 0){
          existe = true;
        }
        else{
          String [] sinonimos = nodosDerechos[pos].Synonym;
          for (int j = 0; j < sinonimos.length; j++){
            if (sinonimos[j] == nodosIzquierdos[i].name){
              existe = true;
            }
          }
        }
      }
      if (existe == false && pos > 0 && nuevos == true){
        fill(8,138,0);
      } 
      else{
        if (congruentes){
          for (int i = 1; i < nodosIzquierdos.length; i++){
                if (nodosDerechos[pos].name == nodosIzquierdos[i].name && nodosDerechos[pos].author == nodosIzquierdos[i].author && pos > 0){
                    fill(23, 18, 196);
                }
            }
        }
      }
      if (merges){
        for (int m = 0; m < derechosPainted.length; m++){
          if (nodosDerechos[pos].name == derechosPainted[m].name){
            fill(255, 145, 0);
          }
        }
      }
      if (renames){
         for (int r = 0; r < RenameRPainted.length; r++){
              if (nodosDerechos[pos].name == RenameRPainted[r].name){
                fill(91, 255, 142);
              }
            }
      }
      if(moves){
         for (int m = 0; m < Move_RPainted.length; m++){
            if (nodosDerechos[pos].name == Move_RPainted[m].name){
              fill(10, 228, 237);
            }
          }
      }
      if (splits){
          for (int s = 0; s < splitsRPainted.length; s++){
            if (nodosDerechos[pos].name == splitsRPainted[s].name){
              fill(255, 0, 191);
            }
          }
      }

      //Verifica si hubo o no click en un nodo de congruencia
      for (int p = 0; p < ListaSeleccionados_Conguentres_D.length; p++){
          if (nodosDerechos[pos].name == ListaSeleccionados_Conguentres_D[p].name){
            fill(23, 18, 196);
          }
      }

      //Verifica si hubo o no click en un nodo de moves
      for (int m = 0; m < ListaSeleccionados_Moves_D.length; m++){
        if (nodosDerechos[pos].name == ListaSeleccionados_Moves_D[m].name){
          fill(10, 228, 237);
        }
      }

        //Verifica si hubo o no click en un nodo de renames a la izquierda
       for (int r = 0; r < ListaSeleccionados_Rename_D.length; r++){
          if (nodosDerechos[pos].name == ListaSeleccionados_Rename_D[r].name){
            fill(91, 255, 142);
          }
        } 

      //Verifica si hubo o no click en un nodo de news
      for (int n = 0; n < ListaSeleccionados_Nuevos.length; n++){
        if (nodosDerechos[pos].name == ListaSeleccionados_Nuevos[n].name){
          fill(8,138,0);
        }
      }

      //Verifica si hubo o no click en un nodo de splits
      for (int s = 0; s < ListaSeleccionados_Splits_D.length; s++){
        if (nodosDerechos[pos].name == ListaSeleccionados_Splits_D[s].name){
          fill(255, 0, 191);
        }
      }

      //Verifica si hubo o no click en un nodo de merges
      for (int m = 0; m < ListaSeleccionados_Merges_D.length; m++){
        if (nodosDerechos[pos].name == ListaSeleccionados_Merges_D[m].name){
          fill(255, 145, 0);
        }
      }
       // ESTA ES LA SECCION DONDE SE DIBUJABAN LAS LINEAS PEQUEÑAS PARA CADA NODO
      //ESTA COMENTADO PUES AUN NO ESTA CORREGIDO
      //ESTO PARA LOS NODOS HORIZONTALES
      //PROCEDIMIENTO PARA PINTAR LAS LINEAS HORIZONTALES
        textAlign(CENTER, CENTER);
        String nombre = nodosDerechos[pos].name;
        int largo = nombre.length;
        y = -1*nodosDerechos[pos].x-30;
        while(largo >= 0){
          //println(nombre[largo]);
          y = y-25;
          largo = largo -1;
          text(nombre[largo],nodosDerechos[pos].y*2.5+450,y);
        }
        rotate(-PI/2);
        fill(166, 166, 166);
        if (pos > 1){
           text("― ",nodosDerechos[pos].x+22,nodosDerechos[pos].y*2.5+450);
        }
        rotate(PI/2);
        ListaPosiciones_D[pos] = new Posiciones(nodosDerechos[pos].name,nodosDerechos[pos].y*2.5+450,-1*nodosDerechos[pos].x-30);  //queda igual para los dos metodos
    }
    textAlign(LEFT);
    rotate(-PI/2);
    
    stroke(107,110,107);
    for (int i = 0; i < nodosDerechos.length; i++){
      if (nodosDerechos[i].children != null){
        CalcularPosicionesLineasHorizontal(i);
      }
    }
    stroke(0);
  }
 
}

void mouseClicked() {
  //Se limpia la matriz
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
  autoClickNuevos_OFF();
  autoClickCongruence_OFF();
  autoClickSplits_OFF();
  autoClickMerges_OFF();
  autoClickMoves_OFF();
  autoClickRenames_OFF();
  autoClickExclusion_OFF();
  autoClickAll_OFF();
  nuevos = false;
  congruentes = false;
  splits = false;
  merges = false;
  moves = false;
  renames = false;
  exclusiones = false;

  int y = (mouseY - translateY) * (1/scaleFactor);
  int x = (mouseX - translateX) * (1/scaleFactor);
  Calcular_Nodo_Seleccionado(x,y); 

}


//Verifica cual nodo se esta seleccionado
void Calcular_Nodo_Seleccionado(x, y){
  for (int i=0; i<cols; i++) {
    for (int j=0; j<rows; j++) {
      colors[i][j] = color(255);
    }
  } 
  boolean existe_Elemento = false;
  if (y > ListaPosiciones_I[1].y-25 && x > ListaPosiciones_I[1].x ){ 
    for (int i = 1; i < ListaPosiciones_I.length; i++){
      if ((y <= ListaPosiciones_I[i].y && y >= ListaPosiciones_I[i].y-25) && (x > ListaPosiciones_I[i].x && x < (ListaPosiciones_I[i].x + textWidth(ListaPosiciones_I[i].name)))){
        //println(ListaPosiciones_I[i].name);
        drawCongruency_Selected([ListaPosiciones_I[i]]);
        drawMoves_Selected(false,108,27,232,ListaPosiciones_I[i].name,true);
        drawMoves_Selected(true,108,27,232,ListaPosiciones_I[i].name,true);
        Exclusiones(ListaPosiciones_I[i].name);
        drawSplits_Selected(ListaPosiciones_I[i].name,true);
        merge_Selected(ListaPosiciones_I[i].name,true);
        existe_Elemento = true;
        return;
      }
    }
  }
  else{
    for (int i = 1; i < ListaPosiciones_D.length; i++){
      if ((x >= ListaPosiciones_D[i].x-5 && x <= ListaPosiciones_D[i].x+15)  && (abs(y) >= abs(ListaPosiciones_D[i].y-20)) && abs(y) <= (abs(ListaPosiciones_D[i].y-20)+((ListaPosiciones_D[i].name.length)*25 ) ) ){
        drawCongruency_Selected([ListaPosiciones_D[i]]);
        drawSplits_Selected(ListaPosiciones_D[i].name,false);
        drawMoves_Selected(false,108,27,232,ListaPosiciones_D[i].name,false);
        drawMoves_Selected(true,108,27,232,ListaPosiciones_D[i].name,false);
        Nuevos(ListaPosiciones_D[i].name);
        merge_Selected(ListaPosiciones_D[i].name,false);
        existe_Elemento = true;
        return;
      }
    }
  }

  if (existe_Elemento == false && splits == false && moves == false && renames == false && congruentes == false && merges == false){
    for (int i=0; i<cols; i++) {
      for (int j=0; j<rows; j++) {
        colors[i][j] = color(255);
      }
    } 
  }
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    scaleFactor = 0.3;
    translateX =  200.0;
    translateY = 350.0;
  }
  if (key == 'i' || key == 'I'){
    scaleFactor += 0.03;
    //translateX -= mouseX-150;
    //translateY -= mouseY-150;
  }
  if (key == 'o' || key == 'O'){
    //if (scaleFactor > 1.0){
    scaleFactor -= 0.03;
      //translateX -= mouseX-150;
      //translateY -= mouseY-150;
    //}
  }
}

void mouseDragged(MouseEvent e) {
  translateX += mouseX - pmouseX;
  translateY += mouseY - pmouseY;
}

int posIzquierda(String nombre){
  for(int i=0; i<izquierdos.length;i++){
    if(izquierdos[i].name == nombre){
      return i-1;
    }    
  }
}


int posDerecha(String nombre){
  for(int i=0; i<derechos.length;i++){
    if(derechos[i].name == nombre){
      return i-1;
    }
  }
}

////////////////////////////S P L I T S/////////////////////////////////////////////////////////////////////////////////////
//Here i have the splits funcions to draw the lines in the canvas
//splitslPainted and splitsRPainted are global variables to call from Javascript
//the variables are obtained using the returnSplitsLeft and returnSplitsRight functions
Object [] splitslPainted = [];
Object [] splitsRPainted = [];
int cantidadSplits = 0;
void drawSplits(){
    cantidadSplits = 0;
    Object [] izquierdos = nodesLeft;
    Object [] derechos = nodesRight;
    Object [] splitsL = [];
    Object [] splitsR = [];
    //stroke(255, 0, 191);
    //noFill();
    //curveTightness(-2);
    //strokeWeight(-1);
    //smooth();
  for (int nodeL = 0;nodeL<izquierdos.length;nodeL++){
     String name = izquierdos[nodeL].name;
     String autor = izquierdos[nodeL].author;
     String date = izquierdos[nodeL].record_scrutiny_date;
         append(splitsL,izquierdos[nodeL]);
         int cont = 0;
         for (int nodeR = 0;nodeR<derechos.length;nodeR++){
           if ((name == derechos[nodeR].name || verificarSinonimos(derechos[nodeR].Synonym,name)) && autor == derechos[nodeR].author && date == derechos[nodeR].record_scrutiny_date){
             cont= cont+1;
             append(splitsR,derechos[nodeR]);
           }
         }
         if (cont>1){
           for (int i = 0;i<splitsL.length;i++){
                append(splitslPainted,splitsL[i]);
                cantidadSplits = cantidadSplits+1;
             for (int j = 0;j<splitsR.length;j++){
               append(splitsRPainted,splitsR[j]);
               int x1 = splitsL[i].x+textWidth(splitsL[i].name);
               int y1 = splitsL[i].y-5;
               float x2 = splitsR[j].x+anchoDiv;
               int y2 = splitsR[j].y-5;
               //curve(x1*3, y1-50,x1,y1,x2-5,y2,x2/3,y2+50);
               posIzq = posIzquierda(splitsL[i].name);
               posDer = posDerecha(splitsR[j].name);
               colors[posDer][posIzq]=color(255, 0, 191);
               
             }
             splitsR=[];
             splitsL=[];
           }
         }
        splitsR=[];
        splitsL=[];   
  }
}

void drawSplits_Selected(nombre,taxonomia){
    cantidadSplits = 0;
    Object [] izquierdos = nodesLeft;
    Object [] derechos = nodesRight;
    Object [] splitsL = [];
    Object [] splitsR = [];
  for (int nodeL = 0;nodeL<izquierdos.length;nodeL++){
     String name = izquierdos[nodeL].name;
     String autor = izquierdos[nodeL].author;
     String date = izquierdos[nodeL].record_scrutiny_date;
         append(splitsL,izquierdos[nodeL]);
         int cont = 0;
         for (int nodeR = 0;nodeR<derechos.length;nodeR++){
          if ((name == derechos[nodeR].name || verificarSinonimos(derechos[nodeR].Synonym,name)) && autor == derechos[nodeR].author && date == derechos[nodeR].record_scrutiny_date){
             cont= cont+1;
             append(splitsR,derechos[nodeR]);
           }
         }
         if (cont>1){
           for (int i = 0;i<splitsL.length;i++){
              if (taxonomia){
                if (existe_Elemento_Array(nombre, buscar_padres(izquierdos[nodeL].name, izquierdos)) || nombre == splitsL[i].name){
                    append(ListaSeleccionados_Splits_I,splitsL[i]);
                    cantidadSplits = cantidadSplits+1;
                    for (int j = 0;j<splitsR.length;j++){
                        autoClickSplits_ON();
                       append(ListaSeleccionados_Splits_D,splitsR[j]);
                       int x1 = splitsL[i].x+textWidth(splitsL[i].name);
                       int y1 = splitsL[i].y-5;
                       float x2 = splitsR[j].x+anchoDiv;
                       int y2 = splitsR[j].y-5;
                       //curve(x1*3, y1-50,x1,y1,x2-5,y2,x2/3,y2+50);
                       posIzq = posIzquierda(splitsL[i].name);
                       posDer = posDerecha(splitsR[j].name);
                       colors[posDer][posIzq]=color(255, 0, 191);
                       
                     }
                     splitsR=[];
                     splitsL=[];
                  }
              }
              else{
                for (int r = 0; r < splitsR.length; r++){
                  if (existe_Elemento_Array(nombre, buscar_padres(splitsR[r].name, derechos)) || nombre == splitsR[r].name){
                        append(ListaSeleccionados_Splits_I,splitsL[i]);
                        cantidadSplits = cantidadSplits+1;
                        for (int j = 0;j<splitsR.length;j++){
                          //Javascript function tha turn on the sliders
                           autoClickSplits_ON();
                           append(ListaSeleccionados_Splits_D,splitsR[j]);
                           int x1 = splitsL[i].x+textWidth(splitsL[i].name);
                           int y1 = splitsL[i].y-5;
                           float x2 = splitsR[j].x+anchoDiv;
                           int y2 = splitsR[j].y-5;
                           //curve(x1*3, y1-50,x1,y1,x2-5,y2,x2/3,y2+50);
                           posIzq = posIzquierda(splitsL[i].name);
                           posDer = posDerecha(splitsR[j].name);
                           colors[posDer][posIzq]=color(255, 0, 191);
                         }
                         splitsR=[];
                         splitsL=[];
                      }
                }
              }   
           }
         }
        splitsR=[];
        splitsL=[];   
  }
}

//This fucntion is to return the variable that contains the nodes of the splits in the left taxonomy
Object [] returnSplitsLeft(){
    return splitslPainted;
}
//This fucntion is to return the variable that contains the nodes of the splits in the roght taxonomy
Object [] returnSplitsRight(){
    return splitsRPainted;
}

//This function is to retun the cantidadSplits variable to Javascript
int returnAmountSplits(){
    return cantidadSplits;
}

//Tis function is to check that a name exist in an array of nodes
//Compare the names and return truen if are the same
void verificarSinonimos(arreglo,nombre){
    for (int i=0; i<arreglo.length;i++){
        if (arreglo[i] == nombre){
            return true;
        }
    }
    return false;
}
////////////////////////////S P L I T S/////////////////////////////////////////////////////////////////////////////////////

///////////////////////M O V E//////////////////////////////////

Object [] Move_LPainted = [];
Object [] Move_RPainted = [];
Object [] RenameLPainted = [];
Object [] RenameRPainted = [];
int cantidadRenames = 0;
int cantidadMoves = 0;
//Here i have the splits funcions to draw the lines in the canvas

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


//This fucntion is to return the variable that contains the nodes of the renames or moves  in the left taxonomy
Object [] returnRename_MovesLeft(){
    return Move_RenameLPainted;
}
//This fucntion is to return the variable that contains the nodes of the renames or moves in the roght taxonomy
Object [] returnRename_MovesRight(){
    return Move_RenameRPainted;
}

int returnMoves(){
    return cantidadMoves;
}

int returnRenames(){
    return cantidadRenames;
}

//this fucntion draw the moves and renames lines in the processing canvas
void drawMoves(bandera,int R, int G,int B){
    cantidadRenames = 0;
    cantidadMoves = 0;
    Object [] nodosDerechos = [];
    Object [] nodosIzquierdos = [];
    Object [] izquierdos = nodesLeft;
    Object [] derechos = nodesRight;
    Move_RenameLPainted = [];
    Move_RenameRPainted = [];
    //stroke(R, G, B);
    //noFill();
    //curveTightness(-2);
    //strokeWeight(-1);
    //smooth();
    for (int nodeL = 0; nodeL < izquierdos.length;nodeL++){
        int cont = 0;
        String nameL = izquierdos[nodeL].name;
        String autorL = izquierdos[nodeL].author;
        String dateL = izquierdos[nodeL].record_scrutiny_date;
        for (nodeR=0;nodeR<derechos.length;nodeR++){
            String [] sinonimos = derechos[nodeR].Synonym;
            String nombreR = derechos[nodeR].name;
            String autorR = derechos[nodeR].author;
            String fechaR = derechos[nodeR].record_scrutiny_date;
            if (sinonimos.length == 1){
                if (nameL  == sinonimos[0] && autorL == autorR && dateL == fechaR){
                    cont = cont+1;
                    append(nodosDerechos,derechos[nodeR]);
                    append(nodosIzquierdos,izquierdos[nodeL]);
                }
            }
            else{
                int existe = 0;
                for (int i=0;i<sinonimos.length;i++){
                    if (existeNombre(sinonimos[i])==false){
                        existe = existe+1;
                        if (nameL == sinonimos[i] && autorL == autorR && dateL == fechaR && existe == 0){
                            cont = cont+1;
                            append(nodosDerechos,derechos[nodeR]);
                            append(nodosIzquierdos,izquierdos[nodeL]);
                        }
                    }
                }
            }
        }
        //Check that exist only one synonym
        if (cont == 1 ){
            String nombreL = nodosIzquierdos[0].name;
            String authorL = nodosIzquierdos[0].author;
            String dateL = nodosIzquierdos[0].record_scrutiny_date;
            String nombreR = nodosDerechos[0].name;
            String authorR = nodosDerechos[0].author;
            String dateR = nodosDerechos[0].record_scrutiny_date;
            String [] padresI = buscar_padres(nombreL,izquierdos);
            String [] padresD = buscar_padres(nombreR,derechos);
            if (padresI.length == padresD.length){
                boolean flag = true;
                for (int j = 0; j < padresD.length-1;j++){
                    if (padresD[j] != padresI[j]){
                        flag = false;
                    }
                }
                //Check if the flag is  of Move() or Rename()
                if (flag == bandera){
                    if (bandera == false){
                        cantidadMoves = cantidadMoves+1;
                         append(Move_LPainted,nodosIzquierdos[0]);
                          append(Move_RPainted,nodosDerechos[0]);
                    }
                    if (bandera == true){
                        cantidadRenames = cantidadRenames+1;
                         append(RenameLPainted,nodosIzquierdos[0]);
                         append(RenameRPainted,nodosDerechos[0]);
                    }
                    //Pintar
                    int x1 = nodosIzquierdos[0].x+textWidth(nodosIzquierdos[0].name);
                    int y1 = nodosIzquierdos[0].y-5;
                    float x2 = nodosDerechos[0].x+anchoDiv;
                    int y2 = nodosDerechos[0].y-5;
                    //curve(x1*3, y1-50,x1,y1,x2-5,y2,x2/3,y2+50);
                    posIzq = posIzquierda(nodosIzquierdos[0].name);
                    posDer = posDerecha(nodosDerechos[0].name);
                    if (bandera == true){ 
                      colors[posDer][posIzq]=color(91, 255, 142);
                    }
                    else{
                       colors[posDer][posIzq]=color(10, 228, 237);
                    }
                }
            }
        }
        nodosDerechos = [];
        nodosIzquierdos = [];
    }
}


//this fucntion draw the moves and renames lines in the processing canvas
void drawMoves_Selected(bandera,int R, int G,int B, nombre, taxonomia){
    cantidadRenames = 0;
    cantidadMoves = 0;
    Object [] nodosDerechos = [];
    Object [] nodosIzquierdos = [];
    Object [] izquierdos = nodesLeft;
    Object [] derechos = nodesRight;
    Move_RenameLPainted = [];
    Move_RenameRPainted = [];
    for (int nodeL = 0; nodeL < izquierdos.length;nodeL++){
        int cont = 0;
        String nameL = izquierdos[nodeL].name;
        String autorL = izquierdos[nodeL].author;
        String dateL = izquierdos[nodeL].record_scrutiny_date;
        for (nodeR=0;nodeR<derechos.length;nodeR++){
            boolean subarbol = false;
            if (taxonomia){
              if (existe_Elemento_Array(nombre, buscar_padres(izquierdos[nodeL].name, izquierdos))){
                subarbol = true;
              }
            }
            else{
              if (existe_Elemento_Array(nombre, buscar_padres(derechos[nodeR].name, derechos))){
                subarbol = true;
              }
            }
            String [] sinonimos = derechos[nodeR].Synonym;
            String nombreR = derechos[nodeR].name;
            String autorR = derechos[nodeR].author;
            String fechaR = derechos[nodeR].record_scrutiny_date;
            if (sinonimos.length == 1){
              if (taxonomia){
                if ((nameL  == sinonimos[0] && autorL == autorR) && (nameL == nombre  || subarbol)){
                    cont = cont+1;
                    append(nodosDerechos,derechos[nodeR]);
                    append(nodosIzquierdos,izquierdos[nodeL]);
                }
              }
              else{
                if ((nameL  == sinonimos[0] && autorL == autorR) && (nombreR == nombre  || subarbol) && (existe_Elemento_Array_Obj(nombreR, ListaSeleccionados_Splits_D) == false)){
                    cont = cont+1;
                    append(nodosDerechos,derechos[nodeR]);
                    append(nodosIzquierdos,izquierdos[nodeL]);
                }
              }
                
            }
            else{
                int existe = 0;
                for (int i=0;i<sinonimos.length;i++){
                    if (existeNombre(sinonimos[i])==false){
                        existe = existe+1;
                        if ((nameL == sinonimos[i] && autorL == autorR) && (nameL == nombre || nombreR == nombre || subarbol) && existe == 0){
                            cont = cont+1;
                            append(nodosDerechos,derechos[nodeR]);
                            append(nodosIzquierdos,izquierdos[nodeL]);
                        }
                    }
                }
            }
        }
        //Check that exist only one synonym
        if (cont == 1){
            String nombreL = nodosIzquierdos[0].name;
            String authorL = nodosIzquierdos[0].author;
            String dateL = nodosIzquierdos[0].record_scrutiny_date;
            String nombreR = nodosDerechos[0].name;
            String authorR = nodosDerechos[0].author;
            String dateR = nodosDerechos[0].record_scrutiny_date;
            String [] padresI = buscar_padres(nombreL,izquierdos);
            String [] padresD = buscar_padres(nombreR,derechos);
            if (padresI.length == padresD.length){
                boolean flag = true;
                for (int j = 0; j < padresD.length-1;j++){
                    if (padresD[j] != padresI[j]){
                        flag = false;
                    }
                }
                //Check if the flag is  of Move() or Rename()
                 //Check if the flag is  of Move() or Rename()
                if (flag == bandera){
                  if (bandera == false){
                      cantidadMoves = cantidadMoves+1;
                      autoClickMoves_ON();
                      append(ListaSeleccionados_Moves_I,nodosIzquierdos[0]);
                      append(ListaSeleccionados_Moves_D,nodosDerechos[0]);
                  }
                  if (bandera == true){
                      cantidadRenames = cantidadRenames+1;
                      autoClickRenames_ON();
                      append(ListaSeleccionados_Rename_I,nodosIzquierdos[0]);
                      append(ListaSeleccionados_Rename_D,nodosDerechos[0]);
                  }
                  //Pintar
                  int x1 = nodosIzquierdos[0].x+textWidth(nodosIzquierdos[0].name);
                  int y1 = nodosIzquierdos[0].y-5;
                  float x2 = nodosDerechos[0].x+anchoDiv;
                  int y2 = nodosDerechos[0].y-5;
                  //curve(x1*3, y1-50,x1,y1,x2-5,y2,x2/3,y2+50);
                  posIzq = posIzquierda(nodosIzquierdos[0].name);
                  posDer = posDerecha(nodosDerechos[0].name);
                  if (bandera == true){ 
                    colors[posDer][posIzq]=color(91, 255, 142);
                  }
                  else{
                     colors[posDer][posIzq]=color(10, 228, 237);
                  }
                }
                
            }
        }
        nodosDerechos = [];
        nodosIzquierdos = [];
    }
}

///////////////////////M O V E//////////////////////////////////

/////////////////////////////////C O N G R U E N T////////////////////////////////////////////////////////////////////////////////
//This function is to draw the congruency lines en the canvas
//Check the name, the author and de record_scrutiny_date and paint blue lines
//Then check name and author and paint the light-blue lines
int cantidadCongurentes = 0;
void drawCongruency(){
  cantidadCongurentes = 0;
    Object [] izquierdos = nodesLeft;
    Object [] derechos = nodesRight;
    //stroke(23, 18, 196);
    //noFill();
    //curveTightness(-2);
    //strokeWeight(0);
    //smooth();
    for (int i = 1;i<izquierdos.length;i++){
      boolean acepto = true;
      for (int j = 1;j<derechos.length;j++){
        String [] listaSinonimos = derechos[j].Synonym;
        for (int s = 0; s < listaSinonimos.length; s++){
                if (izquierdos[i].name == listaSinonimos[s]){
                    acepto = false;
                }
            }
        if (izquierdos[i].name == derechos[j].name && izquierdos[i].author == derechos[j].author && acepto == true){
                //stroke(23, 18, 196);
            int x1 = izquierdos[i].x+textWidth(izquierdos[i].name);
            int y1 = izquierdos[i].y-5;
            float x2 = derechos[j].x+anchoDiv;
            int y2 = derechos[j].y-5;
            //curve(x1*3, y1-50,x1,y1,x2-5,y2,x2/3,y2+50);
            posIzq = posIzquierda(izquierdos[i].name);
            posDer = posDerecha(derechos[j].name);
            colors[posDer][posIzq]=color(23, 18, 196);
            cantidadCongurentes += 1;
        }
        else if (izquierdos[i].name == derechos[j].name && izquierdos[i].author == derechos[j].author && acepto == true){

            //stroke(0, 227, 255);
            int x1 = izquierdos[i].x+textWidth(izquierdos[i].name);
            int y1 = izquierdos[i].y-5;
            float x2 = derechos[j].x+anchoDiv;
            int y2 = derechos[j].y-5;
            //curve(x1*3, y1-50,x1,y1,x2-5,y2,x2/3,y2+50);
            posIzq = posIzquierda(izquierdos[i].name);
            posDer = posDerecha(derechos[j].name);
            colors[posDer][posIzq]=color(23, 18, 196);
            cantidadCongurentes += 1;
        }
      }
    }
}

//Verifica si existe un elemento en un arreglo se strings
boolean existe_Elemento_Array(ele, arreglo){
  for (int i = 0; i < arreglo.length; i++){
    if (arreglo[i] == ele){
      return true;
    }
  }
  return false;
}

//Verifica si existe un elemento en un arreglo de objetos
boolean existe_Elemento_Array_Obj(ele, arreglo){
  for (int i = 0; i < arreglo.length; i++){
    if (arreglo[i].name == ele){
      return true;
    }
  }
  return false;
}

//Funcion auxiliar, se activa cuando se da click a un determinado nodo
//unicamente permite los congruentes que se encuentran en la lista de nodos seleccionados
void drawCongruency_Selected(lista_nombres){
  cantidadCongurentes = 0;
    Object [] izquierdos = nodesLeft;
    Object [] derechos = nodesRight;
    for (int i = 1;i<izquierdos.length;i++){
      boolean acepto = true;
      for (int j = 1;j<derechos.length;j++){
        String [] listaSinonimos = derechos[j].Synonym;
        for (int s = 0; s < listaSinonimos.length; s++){
            if (izquierdos[i].name == listaSinonimos[s]){
                acepto = false;
            }
        }
        for (int pos = 0; pos < lista_nombres.length; pos++){
              boolean subarbol = false;
              if (existe_Elemento_Array(lista_nombres[pos].name, buscar_padres(izquierdos[i].name, izquierdos))){
                subarbol = true;
              }
              if (existe_Elemento_Array(lista_nombres[pos].name, buscar_padres(derechos[j].name, derechos))){
                subarbol = true;
              }
              if ((izquierdos[i].name == derechos[j].name && izquierdos[i].author == derechos[j].author && acepto == true)  && (izquierdos[i].name == lista_nombres[pos].name || derechos[j].name == lista_nombres[pos].name || subarbol)){
                  int x1 = izquierdos[i].x+textWidth(izquierdos[i].name);
                  int y1 = izquierdos[i].y-5;
                  float x2 = derechos[j].x+anchoDiv;
                  int y2 = derechos[j].y-5;
                  posIzq = posIzquierda(izquierdos[i].name);
                  posDer = posDerecha(derechos[j].name);
                  colors[posDer][posIzq]=color(23, 18, 196);
                  cantidadCongurentes += 1;
                  //Javascript function tha turn on the sliders
                  autoClickCongruence_ON();
                  append(ListaSeleccionados_Conguentres_I,izquierdos[i]);
                  append(ListaSeleccionados_Conguentres_D,derechos[j]);
              }
              else if ((izquierdos[i].name == derechos[j].name && izquierdos[i].author == derechos[j].author && acepto == true) && (izquierdos[i].name == lista_nombres[pos].name || derechos[j].name == lista_nombres[pos].name || subarbol)){
                  int x1 = izquierdos[i].x+textWidth(izquierdos[i].name);
                  int y1 = izquierdos[i].y-5;
                  float x2 = derechos[j].x+anchoDiv;
                  int y2 = derechos[j].y-5;
                  posIzq = posIzquierda(izquierdos[i].name);
                  posDer = posDerecha(derechos[j].name);
                   colors[posDer][posIzq]=color(23, 18, 196);
                  cantidadCongurentes += 1;
                  autoClickCongruence_ON();
                  append(ListaSeleccionados_Conguentres_I,izquierdos[i]);
                  append(ListaSeleccionados_Conguentres_D,derechos[j]);
              }
          }
        }
    }
}

int returnCongruentes(){

  return cantidadCongurentes;
}
/////////////////////////////////C O N G R U E N T////////////////////////////////////////////////////////////////////////////////

/////////////////////////M E R G E S////////////////////////////////
int cantidadMergers = 0;
object [] izquierdo = [];
object [] izquierdosPainted = [];
object [] derechosPainted = [];
//This function is to indicate if a node exist in a taxonomy
//Is a complement of the pintarNuevos() function
//Is used to check if exist in the left taxonomy a name that receive as parameter
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

object [] returnIzquierdosMerge(){
    return izquierdosPainted;
}

object [] returnDerechosMerge(){
    return derechosPainted;
}

int returnCantidadMergers(){
    return cantidadMergers;
}

//This function draw the mergers lines in the processing canvas
void merge(){
    cantidadMergers = 0;
    Object [] izquierdos = nodesLeft;
    Object [] derechos = nodesRight;
    String [] sinonimos = [];
    Object derecho;
    //stroke(255, 145, 0);
    //noFill();
    //curveTightness(-2);
    //strokeWeight(-1);
    //smooth();
    for (int nodeR = 0; nodeR<derechos.length;nodeR++){
        int cont = 0;
        derecho = derechos[nodeR];
        sinonimos = derechos[nodeR].Synonym;
        if (sinonimos.length > 1){
             for (int nodeL = 0; nodeL < sinonimos.length;nodeL++){
                if (existeNombre_Complejo(sinonimos[nodeL],derechos[nodeR].author,derechos[nodeR].record_scrutiny_date)==false){
                    cont = cont+1;
                }
            }
            if (cont > 1){
                cantidadMergers = cantidadMergers+1;
                append(derechosPainted,derecho);
                for (int i = 0; i < izquierdo.length;i++){
                    append(izquierdosPainted,izquierdo[i]);
                    int x1 = izquierdo[i].x+textWidth(izquierdo[i].name);
                    int y1 = izquierdo[i].y-5;
                    float x2 = derecho.x+anchoDiv;
                    int y2 = derecho.y-5;
                    //curve(x1*3, y1-50,x1,y1,x2-5,y2,x2/3,y2+50);
                    posIzq = posIzquierda(izquierdo[i].name);
                    posDer = posDerecha(derecho.name);
                    colors[posDer][posIzq]=color(255, 145, 0);
                }
            }
            cont = 0;
            izquierdo = []; 
        }
       
    }
}


void merge_Selected(nombre, taxonomia){
    cantidadMergers = 0;
    Object [] izquierdos = nodesLeft;
    Object [] derechos = nodesRight;
    String [] sinonimos = [];
    Object derecho;
    //stroke(255, 145, 0);
    //noFill();
    //curveTightness(-2);
    //strokeWeight(-1);
    //smooth();
    for (int nodeR = 0; nodeR<derechos.length;nodeR++){
        int cont = 0;
        derecho = derechos[nodeR];
        sinonimos = derechos[nodeR].Synonym;
        if (sinonimos.length > 1){
             for (int nodeL = 0; nodeL < sinonimos.length;nodeL++){
                if (existeNombre_Complejo(sinonimos[nodeL],derechos[nodeR].author,derechos[nodeR].record_scrutiny_date)==false){
                    cont = cont+1;
                }
            }
            if (cont > 1){
                cantidadMergers = cantidadMergers+1;
                boolean subarbol = false;
                if (taxonomia){
                   for (int i = 0; i < izquierdo.length;i++){
                       if (existe_Elemento_Array(nombre, buscar_padres(izquierdo[i].name, izquierdos)) || izquierdo[i].name == nombre){
                           subarbol = true;
                        }
                   }
                }
                if (existe_Elemento_Array(nombre, buscar_padres(derecho.name, derechos))){
                   subarbol = true;
                }
                if(subarbol || nombre == derecho.name){
                  append(ListaSeleccionados_Merges_D,derecho);
                  for (int i = 0; i < izquierdo.length;i++){
                      append(ListaSeleccionados_Merges_I,izquierdo[i]);
                      //Javascript function tha turn on the sliders
                      autoClickMerges_ON();
                      int x1 = izquierdo[i].x+textWidth(izquierdo[i].name);
                      int y1 = izquierdo[i].y-5;
                      float x2 = derecho.x+anchoDiv;
                      int y2 = derecho.y-5;
                      //curve(x1*3, y1-50,x1,y1,x2-5,y2,x2/3,y2+50);
                      posIzq = posIzquierda(izquierdo[i].name);
                      posDer = posDerecha(derecho.name);
                      colors[posDer][posIzq]=color(255, 145, 0);
                  }
                }
            }
            cont = 0;
            izquierdo = []; 
        }
       
    }
}
/////////////////////////M E R G E S////////////////////////////////

//////////////////////////R E N A M E///////////////////////////////

Object [] Move_RenameLPainted = [];
Object [] Move_RenameRPainted = [];
int cantidadRenames = 0;
int cantidadMoves = 0;
//Here i have the splits funcions to draw the lines in the canvas

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

//This function is to indicate if a node exist in a taxonomy
//Is a complement of the pintarNuevos() function
//Is used to check if exist in the left taxonomy a name that receive as parameter
boolean existeNombreNuevos(nombre,autor){
    for (var nodeL = 0; nodeL < nodesLeft.length; nodeL++) {
        if(nodesLeft[nodeL].name == nombre && nodesLeft[nodeL].author == autor){
            return false;
        }
    }
    return true;
}

//Is the function that use Rename() and Move()
//Receive a flag dependig of the funcion that call this function and the color that is required
boolean existeNombre(nombre){
     Object [] izquierdos = nodesLeft;
     for (int nodeL = 0;nodeL<izquierdos.length;nodeL++){
        if (izquierdos[nodeL].name == nombre){
            return false;
        }
     }
     return true;
}

//This fucntion is to return the variable that contains the nodes of the renames or moves  in the left taxonomy
Object [] returnRename_MovesLeft(){
    return Move_RenameLPainted;
}
//This fucntion is to return the variable that contains the nodes of the renames or moves in the roght taxonomy
Object [] returnRename_MovesRight(){
    return Move_RenameRPainted;
}

int returnMoves(){
    return cantidadMoves;
}

int returnRenames(){
    return cantidadRenames;
}

void Exclusiones(nombre){
  for (int left = 1; left < izquierdos.length; left++){
      var existe = false;
      for (int right = 1; right < derechos.length; right++){
        boolean subarbol = false;
        if (existe_Elemento_Array(nombre, buscar_padres(izquierdos[left].name, izquierdos))){
          subarbol = true;
        }
        if (izquierdos[left].name == derechos[right].name && izquierdos[left].author == derechos[right].author && left > 0){
          existe = true;
        }
        else{
          String [] sinonimos = derechos[right].Synonym;
          for (int j = 0; j < sinonimos.length; j++){
            if (sinonimos[j] == izquierdos[left].name){
              existe = true;
            }
          }
        }
      }
      if ((existe == false && subarbol) || (existe == false && nombre == izquierdos[left].name)){
        autoClickExclusion_ON();
        append(ListaSeleccionados_Exclusiones,izquierdos[left]);
      }
  }
}


void Nuevos(nombre){
  for (int rigth = 1; rigth < derechos.length; rigth++){
    var existe = false;
    for (int left = 1; left < izquierdos.length; left++){
        boolean subarbol = false;
        if (existe_Elemento_Array(nombre, buscar_padres(derechos[rigth].name, derechos))){
          subarbol = true;
        }
        if (derechos[rigth].name == izquierdos[left].name && derechos[rigth].author == izquierdos[left].author && rigth > 0){
          existe = true;
        }
        else{
          String [] sinonimos = derechos[rigth].Synonym;
          for (int j = 0; j < sinonimos.length; j++){
            if (sinonimos[j] == izquierdos[left].name){
              existe = true;
            }
          }
        }
      }
      if ((existe == false && subarbol) || (existe == false && nombre == derechos[rigth].name)){
        append(ListaSeleccionados_Nuevos,derechos[rigth]);
        autoClickNuevos_ON();
      } 
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
  getNivel(nodosIzquierdos[pos]);
  int nodoNivel = contadorNivel;
  int y1 = 0;
  int y2 = 10;
  int limit = 0;
  for (int x = 0; x < pos; x++){
    y2+=50;
  } 
  y1 = y2 + 50; 
  limit = y1;

  for (int i = 0; i < nodosIzquierdos.length; i++){
    contadorNivel = 1;
    getNivel(nodosIzquierdos[i]);
    int elementoNivel = contadorNivel;
    if (elementoNivel == nodoNivel+1 && i > pos){
      limit = y1;
    }
    if ((elementoNivel == nodoNivel && i > pos) || (i == nodosIzquierdos.length - 1)){
      line(nodosIzquierdos[pos].x-50,limit-15,nodosIzquierdos[pos].x-50,y2);
      return;
    }
    else if (elementoNivel > nodoNivel && i > pos){
      y1+=50;
    }
  }
}

void CalcularPosicionesLineasHorizontal(int pos){
  contadorNivel = 1;
  getNivel(nodosDerechos[pos]);
  int nodoNivel = contadorNivel;
  int y1 = 0;
  int y2 = 10;
  int limit = 0;
  for (int x = 0; x < pos; x++){
    y2+=50;
  } 
  y1 = y2 + 50; 
  limit = y1;

  for (int i = 0; i < nodosDerechos.length; i++){
    contadorNivel = 1;
    getNivel(nodosDerechos[i]);
    int elementoNivel = contadorNivel;
    if (elementoNivel == nodoNivel+1 && i > pos){
      limit = y1;
    }
    if ((elementoNivel == nodoNivel && i > pos) || (i == nodosDerechos.length - 1)){
      line(nodosDerechos[pos].x+44,limit+493,nodosDerechos[pos].x+44,y2+505);
      return;
    }
    else if (elementoNivel > nodoNivel && i > pos){
      y1+=50;
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