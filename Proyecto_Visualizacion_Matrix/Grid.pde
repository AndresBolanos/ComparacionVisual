int boxsize = 50;
int cols, rows;
color[][] colors;
int saved_i = -1;
int saved_j = -1;

boolean congruentes = false;
boolean splits = false;
boolean merges = false;
boolean moves = false;
boolean renames = false;
boolean iniciar = false;

boolean nuevos = false;
boolean exclusiones = false;

float scaleFactor = 0.2;
float translateX = 400.0;
float translateY = 180.0;

Object [] izquierdos = [];
Object [] derechos = [];

int[] widths = new int[izquierdos.length];
int maxWidth;

Object [] nodosIzquierdos;
Object [] nodosDerechos;

String archivo1 = "";
String archivo2 = "";

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

  size(availableWidth, 2000);  
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
    text(archivo1,-400,1000);
    text(archivo2,1400,-700);
    maxWidth = max(widths);

    //PROCEDIMIENTO PARA PINTAR LAS LINEAS
    stroke(107,110,107);
    for (int i = 1; i < nodosIzquierdos.length; i++){
      if (nodosIzquierdos[i].children != null){
        CalcularPosicionesLineas(i);
      }
    }
    stroke(0);
    for (int i=0; i<cols; i++) {
      for (int j=0; j<rows; j++) {
        fill(colors[i][j]);
        rect(i*boxsize+maxWidth+100, j*boxsize, boxsize, boxsize);      
      }
    }
     
    fill(0);
    textSize(30);
    smooth();
    nodosIzquierdos = nodesLeft;
    int yPrev = 0;
    
    for(int pos = 1; pos < nodosIzquierdos.length; pos++){
      fill(0);
      var existe = false;
      for (int i = 1; i < nodosDerechos.length; i++){
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
              fill(23, 18, 196);
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
      text(nodosIzquierdos[pos].name,nodosIzquierdos[pos].x+25,(nodosIzquierdos[pos].y*2.5)-50);     
      yPrev = nodosIzquierdos[pos].y;   
    }      

    rotate(-PI/2); 
    
    for(int pos = 1; pos < nodosDerechos.length; pos++){
      fill(0);
      var existe = false;
      for (int i = 1; i < nodosIzquierdos.length; i++){
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
          fill(23, 18, 196);
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

      text(nodosDerechos[pos].name,nodosDerechos[pos].x+25,nodosDerechos[pos].y*2.5+460);    
    }
    //PROCEDIMIENTO PARA PINTAR LAS LINEAS HORIZONTALES
    stroke(107,110,107);
    for (int i = 1; i < nodosDerechos.length; i++){
      if (nodosDerechos[i].children != null){
        CalcularPosicionesLineasHorizontal(i);
      }
    }
    stroke(0);
  }
  else{

  }
 
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    scaleFactor = 0.2;
    translateX =  400.0;
    translateY = 180.0;
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

//This function is to indicate if a node exist in a taxonomy
//Is a complement of the pintarNuevos() function
//Is used to check if exist in the left taxonomy a name that receive as parameter
boolean existeNombre(nombre){
    for (var nodeL = 0; nodeL < nodesLeft.length; nodeL++) {
        if(nodesLeft[nodeL].name == nombre ){
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
                        if (nameL == sinonimos[0] && autorL == autorR && dateL == fechaR){
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
                for (int i = 0; i < izquierdo.length;i++){
                    append(derechosPainted,derecho);
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
  int nivel = contadorNivel;
  contadorNivel = 1;
  for (int i = 0; i < nodosIzquierdos.length; i++){
    contadorNivel = 1;
    getNivel(nodosIzquierdos[i]);
    if (contadorNivel < nivel && i > pos){
       int y1 = 25;
        for (int x = 0; x < pos; x++){
          y1+=50;
        } 
        int y2 = 25;
        for (int x = 0; x < i; x++){
          y2+=50;
        }     
        //line(nodosIzquierdos[pos].x+40, nodosIzquierdos[pos].y*2.5, nodosIzquierdos[pos].x+40, nodosIzquierdos[i].y*2.5);
        if (contadorNivel > 3){
          line(nodosIzquierdos[pos].x+25,(y1+40)-50,nodosIzquierdos[pos].x+25,(y2-10)-60);
        }
        else{
          line(nodosIzquierdos[pos].x+25,(y1+40)-50,nodosIzquierdos[pos].x+25,(y2-10)-60);
        }
        return;
    }
    if (contadorNivel == nivel && i > pos){
        int y1 = 25;
        for (int x = 0; x < pos; x++){
          y1+=50;
        } 
        int y2 = 25;
        for (int x = 0; x < i; x++){
          y2+=50;
        }     
        //line(nodosIzquierdos[pos].x+40, nodosIzquierdos[pos].y*2.5, nodosIzquierdos[pos].x+40, nodosIzquierdos[i].y*2.5);
          line(nodosIzquierdos[pos].x+25,(y1+40)-50,nodosIzquierdos[pos].x+25,(y2-10)-60);
        return;
    }
    if (pos == 0){
        int y1 = 25;
        for (int x = 0; x < pos; x++){
          y1+=50;
        } 
        int y2 = 25;
        for (int x = 0; x < nodosIzquierdos.length; x++){
          y2+=50;
        }  
        if (pos == 0){
           line(nodosIzquierdos[nodosIzquierdos.length-1].x-20,(y1+40)-50,nodosIzquierdos[nodosIzquierdos.length-1].x-20,(y2-40)-60);
        }
        break;
    }
  }
}

void CalcularPosicionesLineasHorizontal(int pos){
  contadorNivel = 1;
  getNivel(nodosDerechos[pos]);
  int nivel = contadorNivel;
  contadorNivel = 1;
  for (int i = 0; i < nodosDerechos.length; i++){
    contadorNivel = 1;
    getNivel(nodosDerechos[i]);
    if (contadorNivel < nivel && i > pos){
       int y1 = 25;
        for (int x = 0; x < pos; x++){
          y1+=50;
        } 
        int y2 = 25;
        for (int x = 0; x < i; x++){
          y2+=50;
        }     
        //line(nodosIzquierdos[pos].x+40, nodosIzquierdos[pos].y*2.5, nodosIzquierdos[pos].x+40, nodosIzquierdos[i].y*2.5);
        if (contadorNivel > 3){
          line(nodosDerechos[pos].x+25,(y1+550)-50,nodosDerechos[pos].x+25,(y2+500)-60);
        }
        else{
          line(nodosDerechos[pos].x+25,(y1+550)-50,nodosDerechos[pos].x+25,(y2+500)-60);
        }
        return;
    }
    if (contadorNivel == nivel && i > pos){
        int y1 = 25;
        for (int x = 0; x < pos; x++){
          y1+=50;
        } 
        int y2 = 25;
        for (int x = 0; x < i; x++){
          y2+=50;
        }     
        //line(nodosIzquierdos[pos].x+40, nodosIzquierdos[pos].y*2.5, nodosIzquierdos[pos].x+40, nodosIzquierdos[i].y*2.5);
          line(nodosDerechos[pos].x+25,(y1+550)-50,nodosDerechos[pos].x+25,(y2+500)-60);
        return;
    }
    if (pos == 0){
        int y1 = 25;
        for (int x = 0; x < pos; x++){
          y1+=50;
        } 
        int y2 = 25;
        for (int x = 0; x < nodosDerechos.length; x++){
          y2+=50;
        }  
        if (pos == 0){
           line(nodosDerechos[nodosDerechos.length-1].x-20,(y1+550)-50,nodosDerechos[nodosDerechos.length-1].x-20,(y2+500)-60);
        }
        break;
    }
  }
}