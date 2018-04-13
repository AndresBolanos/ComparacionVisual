

int width;
int height;
conguencia [] CongruenciaIzquierdos;
conguencia [] CongruenciaDerechos;
void setup(){
    width = availableWidth;
    height = availableHeight;
    size(width*2,height+200);
    background(255); 
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//This function is to draw the congruency lines en the canvas
//Check the name, the author and de record_scrutiny_date and paint blue lines
//Then check name and author and paint the light-blue lines
void drawCongruency(){
	Object [] izquierdos = nodesLeft;
    Object [] derechos = nodesRight;
    CongruenciaDerechos = [];
    CongruenciaIzquierdos = [];
    stroke(23, 18, 196);
    noFill();
    curveTightness(-2);
    strokeWeight(0);
    smooth();
    for (int i = 0;i<izquierdos.length;i++){
    	for (int j = 0;j<derechos.length;j++){
    		if (izquierdos[i].name == derechos[j].name && izquierdos[i].author == derechos[j].author && izquierdos[i].record_scrutiny_date == derechos[j].record_scrutiny_date){
                stroke(23, 18, 196);
				int x1 = izquierdos[i].x+textWidth(izquierdos[i].name);
		    	int y1 = izquierdos[i].y-5;
		    	float x2 = derechos[j].x+anchoDiv;
		    	int y2 = derechos[j].y-5;
		    	curve(x1*3, y1-50,x1,y1,x2-5,y2,x2/3,y2+50);
                congruencia nodoI = new conguencia(izquierdos[i],"Azul");
                congruencia nodoD = new conguencia(derechos[j],"Azul");
                append(CongruenciaIzquierdos,nodoI);
                append(CongruenciaDerechos,nodoD);
    		}
            else if (izquierdos[i].name == derechos[j].name && izquierdos[i].author == derechos[j].author){
                stroke(0, 227, 255);
                int x1 = izquierdos[i].x+textWidth(izquierdos[i].name);
                int y1 = izquierdos[i].y-5;
                float x2 = derechos[j].x+anchoDiv;
                int y2 = derechos[j].y-5;
                curve(x1*3, y1-50,x1,y1,x2-5,y2,x2/3,y2+50);
                congruencia nodoI = new conguencia(izquierdos[i],"Celeste");
                congruencia nodoD = new conguencia(derechos[j],"Celeste");
                append(CongruenciaIzquierdos,nodoI);
                append(CongruenciaDerechos,nodoD);
            }
    	}
    }
}

void retornarIzquierdosConguencia(){
    return CongruenciaIzquierdos;
}

void retornarDerechosConguencia(){
    return CongruenciaDerechos;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
    stroke(255, 0, 191);
    noFill();
    curveTightness(-2);
    strokeWeight(-1);
    smooth();
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
			    	curve(x1*3, y1-50,x1,y1,x2-5,y2,x2/3,y2+50);
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
///////////////////////////////////////////////////////////////////////////////////////////////////////

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
    stroke(R, G, B);
    noFill();
    curveTightness(-2);
    strokeWeight(-1);
    smooth();
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
                for (int j = 0; j < padresD.length;j++){
                    if (padresD[j] != padresI[j]){
                        flag = false;
                    }
                }
                //Check if the flag is  of Move() or Rename()
                if (flag == bandera){
                    if (bandera == false){
                        cantidadMoves = cantidadMoves+1;
                    }
                    if (bandera == true){
                        cantidadRenames = cantidadRenames+1;
                    }
                    append(Move_RenameLPainted,nodosIzquierdos[0]);
                    append(Move_RenameRPainted,nodosDerechos[0]);
                    //Pintar
                    int x1 = nodosIzquierdos[0].x+textWidth(nodosIzquierdos[0].name);
                    int y1 = nodosIzquierdos[0].y-5;
                    float x2 = nodosDerechos[0].x+anchoDiv;
                    int y2 = nodosDerechos[0].y-5;
                    curve(x1*3, y1-50,x1,y1,x2-5,y2,x2/3,y2+50);
                }
            }
        }
        nodosDerechos = [];
        nodosIzquierdos = [];
    }
}

/////////////////////////////////////////////////////////
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
        if(izquierdos[nodeL].name == nombre && izquierdos[nodeL].author && izquierdos[nodeL].record_scrutiny_date == date){
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
    stroke(255, 145, 0);
    noFill();
    curveTightness(-2);
    strokeWeight(-1);
    smooth();
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
                    curve(x1*3, y1-50,x1,y1,x2-5,y2,x2/3,y2+50);
                }
            }
            cont = 0;
            izquierdo = []; 
        }  
    }
}


/////////////////////////////////////////////////////////////////////////////////
//Selected node section

boolean painSelectedNode(name, author, date){
    Object [] izquierdos = nodesLeft;
    Object [] derechos = nodesRight;
    stroke(0, 103, 7);
    noFill();
    curveTightness(-2);
    strokeWeight(-1);
    smooth();
    for (int i = 0; i < nodesLeft.length; i++){
        if (izquierdos[i].name == name && izquierdos[i].author == author && izquierdos[i].record_scrutiny_date == date){
            for (int j = 0; j<derechos.length; j++){
                if (derechos[j].name == name && derechos[j].author == author && derechos[j].record_scrutiny_date == date){
                    int x1 = izquierdos[i].x+textWidth(izquierdos[i].name);
                    int y1 = izquierdos[i].y-5;
                    float x2 = derechos[j].x+anchoDiv;
                    int y2 = derechos[j].y-5;
                    curve(x1*3, y1-50,x1,y1,x2-5,y2,x2/3,y2+50);
                    return true;
                }
            }
        }
    }
    return false;
}


class conguencia{
    Oject nodo;
    String color;
    conguencia(Object node, String col){
        nodo = node;
        color = col;
    }
}