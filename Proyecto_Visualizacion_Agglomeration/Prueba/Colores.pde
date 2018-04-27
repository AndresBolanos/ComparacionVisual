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

boolean found = false;

void setNames(name1,name2){
    archivo1 = name1;
    archivo2 = name2;
}

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
  News();
  Congruencia(); 
  //cargarColores(izquierdos, derechos, nodosIzquierdos, nodosDerechos);   
  //createAgglomeration(izquierdos,derechos); 
  
}

void draw(){    
  translate(translateX,translateY);
  scale(scaleFactor);  
  background(255);
  createAgglomeration(izquierdos,derechos);     
  textSize(20);
  fill(130,80, 64);
  text(archivo1,-300,300);  
  fill(223, 209, 33);
  text(archivo2,450,300); 
  stroke(149,153,149);
  strokeWeight(-5);
  for (int i = 1; i < nodosTenues.length; i++){
    if (nodosTenues[i].children != undefined){
      CalcularPosicionesLineas(i);
    }
  }
  

  //println(agglomeration.length);     
}

void keyPressed() {
  if (key == 'r' ||  key == 'R') {
  scaleFactor = 1.0;
  translateX = screen.width/2-200;
  translateY = 0.0;
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
          //else{
            //println("SIGO BUSCANDO")                    
          //}          
        }
      }
      //println("SE ACABA FOR");
      found = false;
    } 
    else{            
      //println("Append "+ leftStructure[node].name + " NO parent IZQUIERDA"); 
      append(agglomeration, leftStructure[node]);     
    }
  }    
  /*
  for (int i = 0; i < nodosIzquierdos.length; i++){
    println(nodosIzquierdos[i].name+" = "+nodosIzquierdos[i].R+","+nodosIzquierdos[i].G+","+nodosIzquierdos[i].B);
    fill(nodosIzquierdos[i].R, nodosIzquierdos[i].G, nodosIzquierdos[i].B);
    text(nodosIzquierdos[i].name, nodosIzquierdos[i].x+20, nodosIzquierdos[i].y*2.5);
  } 
  */

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
  for (int i = 1; i < agglomeration.length; i++){ 
    /*println("Nodo "+agglomeration[i].name);
    if (agglomeration[i].parent != undefined){
      println("Padre "+agglomeration[i].parent.name);
    }*/
    if(agglomeration[i]==null){
      //println("Me vine a null :P");
      //println("Null");
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
        if (mergersG){
          int r = agglomeration[i].R;
          int g = agglomeration[i].G;
          int b = agglomeration[i].B;
          if (r == 255 && g == 78 && b == 0){
            fill(agglomeration[i].R, agglomeration[i].G, agglomeration[i].B);
          }
        }
        if (movesG){
            int r = agglomeration[i].R;
            int g = agglomeration[i].G;
            int b = agglomeration[i].B;
            if (r == 11 && g == 255 && b == 255){
              fill(agglomeration[i].R, agglomeration[i].G, agglomeration[i].B);
            }
        }
        if (renamesG){

            int r = agglomeration[i].R;
            int g = agglomeration[i].G;
            int b = agglomeration[i].B;
            if (r == 91 && g == 255 && b == 142){
              fill(agglomeration[i].R, agglomeration[i].G, agglomeration[i].B);
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
        if (conguencyG){
            int r = agglomeration[i].R;
            int g = agglomeration[i].G;
            int b = agglomeration[i].B;
            if (r == 14 && g == 80 && b == 217){
              fill(agglomeration[i].R, agglomeration[i].G, agglomeration[i].B);
            }
        }
         if (conguencyG){
            int r = agglomeration[i].R;
            int g = agglomeration[i].G;
            int b = agglomeration[i].B;
            if (r == 14 && g == 80 && b == 217){
              fill(agglomeration[i].R, agglomeration[i].G, agglomeration[i].B);
            }
        }
        //println(agglomeration[i].name+" = "+agglomeration[i].R+","+agglomeration[i].G+","+agglomeration[i].B);
        //println("Pinto a "+agglomeration[i].name+" lado: "+agglomeration[i].position+ " PosX: "+agglomeration[i].x+" PosY: "+agglomeration[i].y+" R: "+agglomeration[i].R+" G: "+agglomeration[i].G+" B: "+agglomeration[i].B);
        //fill(221, 198, 0);
        text(agglomeration[i].name, agglomeration[i].x+5,AbsoluteY+20);
        AbsoluteY = AbsoluteY+20;
      }
     else{
        //println(agglomeration[i].name+" = "+agglomeration[i].R+","+agglomeration[i].G+","+agglomeration[i].B);
        //println("Pinto a "+agglomeration[i].name+" lado: "+agglomeration[i].position+ " PosX: "+agglomeration[i].x+" PosY: "+agglomeration[i].y+" R: "+agglomeration[i].R+" G: "+agglomeration[i].G+" B: "+agglomeration[i].B);
        fill(223, 209, 33);
        if (splitsG){
          int r = agglomeration[i].R;
          int g = agglomeration[i].G;
          int b = agglomeration[i].B;
          if (r == 181 && g == 9 && b == 95){
            fill(agglomeration[i].R, agglomeration[i].G, agglomeration[i].B);
          }
        }
         if (mergersG){
          int r = agglomeration[i].R;
          int g = agglomeration[i].G;
          int b = agglomeration[i].B;
          if (r == 255 && g == 31 && b == 0){
            fill(agglomeration[i].R, agglomeration[i].G, agglomeration[i].B);
          }
        }
        if (movesG){
            int r = agglomeration[i].R;
            int g = agglomeration[i].G;
            int b = agglomeration[i].B;
            if (r == 7 && g == 194 && b == 184){
              fill(agglomeration[i].R, agglomeration[i].G, agglomeration[i].B);
            }
        }
        if (renamesG){
            int r = agglomeration[i].R;
            int g = agglomeration[i].G;
            int b = agglomeration[i].B;
            if (r == 66 && g == 184 && b == 102){
              fill(agglomeration[i].R, agglomeration[i].G, agglomeration[i].B);
            }
        }
         if (newsG){
            int r = agglomeration[i].R;
            int g = agglomeration[i].G;
            int b = agglomeration[i].B;
            if (r == 7 && g == 255 && b == 0){
              fill(agglomeration[i].R, agglomeration[i].G, agglomeration[i].B);
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
         if (conguencyG){
            int r = agglomeration[i].R;
            int g = agglomeration[i].G;
            int b = agglomeration[i].B;
            if (r == 13 && g == 34 && b == 102){
              fill(agglomeration[i].R, agglomeration[i].G, agglomeration[i].B);
            }
        }
        //fill(221, 198, 0);
        text(agglomeration[i].name, agglomeration[i].x+5, AbsoluteY+20);
        AbsoluteY = AbsoluteY+20;
      }
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
//Asignar colores splits
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

int returnAmountSplits(){
    return cantidadSplits;
}

//////////////////////////////////////////////////////////////////////////
//Funcion set color merges

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
          if (cont > 1){
            cantidadMergers = cantidadMergers+1;
            nodosDerechos[nodeR].setRGB(255,31,0);
            for (int i = 0; i < nodosIzquierdos.length; i++){
              for (int j = 0; j < izquierdo.length; j++){
                if (nodosIzquierdos[i].name == izquierdo[j].name){
                  nodosIzquierdos[i].setRGB(255,78,0);
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
           nodosIzquierdos[left].setRGB(11,255,255);
        }
      }
    }
    for (int left = 0; left < nodosDerechos.length; left++){
      for (int leftAux = 0; leftAux < listaDerechosM.length; leftAux++){
        if (nodosDerechos[left].name == listaDerechosM[leftAux].name){
           nodosDerechos[left].setRGB(7,194,184);
        }
      }
    }
    for (int left = 0; left < nodosIzquierdos.length; left++){
      for (int leftAux = 0; leftAux < listaIzquierdosR.length; leftAux++){
        if (nodosIzquierdos[left].name == listaIzquierdosR[leftAux].name){
           nodosIzquierdos[left].setRGB(91,255,142);
        }
      }
    }
    for (int left = 0; left < nodosDerechos.length; left++){
      for (int leftAux = 0; leftAux < listaDerechosR.length; leftAux++){
        if (nodosDerechos[left].name == listaDerechosR[leftAux].name){
           nodosDerechos[left].setRGB(66,184,102);
        }
      }
    }
  }

//////////////////////////////////////////////////////////////////////////
//Eclusiones pintar

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


int returnExclusiones(){
  return cantidadExclusiones;
}
/////////////////////////////////////////////////////////////////////////
//set color nuevos
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
        nodosDerechos[i].setRGB(7,255,0);
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
          nodosDerechos[i].setRGB(7,255,0);
           cantidadNuevos = cantidadNuevos+1;
        }
      }
    }
  }
}

////////////////////////////////////////////////////////////////
//set colo congruencia
int cantidadCongurentes = 0;

int returnCongruentes(){
  return cantidadCongurentes;
}

void Congruencia(){
  cantidadCongurentes = 0;
  for (int i = 0;i<nodosIzquierdos.length;i++){
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

  String parent;
  String position;

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
  //println("Analizando a "+nodosTenues[pos].name);
  contadorNivel = 1;
  getNivel(nodosTenues[pos]);
  int nivel = contadorNivel;
  //println("Su nivel es "+nivel);
  contadorNivel = 1;
  for (int i = 0; i < nodosTenues.length; i++){
    contadorNivel = 1;
    getNivel(nodosTenues[i]);
    if (contadorNivel < nivel && i > pos){
       int y1 = 25;
        for (int x = 0; x < pos; x++){
          y1+=25;
        } 
        int y2 = 25;
        for (int x = 0; x < i; x++){
          y2+=25;
        }     
        //line(nodosIzquierdos[pos].x+40, nodosIzquierdos[pos].y*2.5, nodosIzquierdos[pos].x+40, nodosIzquierdos[i].y*2.5);
        line(nodosTenues[pos].x+10,y1-(pos*5),nodosTenues[pos].x+10,y2-(i*5)-20);
      
        return;
    }
    else if (contadorNivel == nivel && i > pos){
        int y1 = 25;
        for (int x = 0; x < pos; x++){
          y1+=25;
        } 
        int y2 = 25;
        for (int x = 0; x < i; x++){
          y2+=25;
        }     
        //line(nodosIzquierdos[pos].x+40, nodosIzquierdos[pos].y*2.5, nodosIzquierdos[pos].x+40, nodosIzquierdos[i].y*2.5);
          line(nodosTenues[pos].x+10,y1-(pos*5),nodosTenues[pos].x+10,y2-(i*5)-20);
        return;
    }
    else if (i == nodosTenues.length-1){
        int y1 = 25;
        for (int x = 0; x < pos; x++){
          y1+=25;
        } 
        int y2 = 25;
        for (int x = 0; x < i; x++){
          y2+=25;
        }  
        line(nodosTenues[pos].x+10,y1-(pos*5),nodosTenues[pos].x+10,y2-(i*5));
    }
  }
}