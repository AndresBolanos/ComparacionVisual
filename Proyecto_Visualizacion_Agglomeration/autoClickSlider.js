//This function is accesed from processing, to turn on the Moves slider on click
function autoClickRenames_ON(){
    document.getElementById("Renames").checked = true;
    checkAll();
}

//This function is accesed from processing, to turn off the Moves slideron click
function autoClickRenames_OFF(){
    document.getElementById("Renames").checked = false;
    //Almacenamiento del estado actual de la pagina en caso de cambio
    window.sessionStorage.setItem("Renames_Ag", false); 
}


//This function is accesed from processing, to turn on the Moves slider on click
function autoClickMoves_ON(){
    document.getElementById("Moves").checked = true;
    checkAll();
}

//This function is accesed from processing, to turn off the Moves slideron click
function autoClickMoves_OFF(){
    document.getElementById("Moves").checked = false;
    //Almacenamiento del estado actual de la pagina en caso de cambio
    window.sessionStorage.setItem("Moves_Ag", false); 
}

//This function is accesed from processing, to turn on the merges slider on click
function autoClickMerges_ON(){
    document.getElementById("Mergers").checked = true;
    checkAll();
}

//This function is accesed from processing, to turn off the merges slideron click
function autoClickMerges_OFF(){
    document.getElementById("Mergers").checked = false;
    //Almacenamiento del estado actual de la pagina en caso de cambio
    window.sessionStorage.setItem("Merges_Ag", false); 
}

//This function is accesed from processing, to turn on the splits slider on click
function autoClickSplits_ON(){
    document.getElementById("Splits").checked = true;
    checkAll();
}

//This function is accesed from processing, to turn off the splits slideron click
function autoClickSplits_OFF(){
    document.getElementById("Splits").checked = false;
    //Almacenamiento del estado actual de la pagina en caso de cambio
    window.sessionStorage.setItem("Splits_Ag", false); 
}

//This function is accesed from processing, to turn on the new slider on click
function autoClickNuevos_ON(){
    document.getElementById("News").checked = true;
    checkAll();
}

//This function is accesed from processing, to turn off the new slideron click
function autoClickNuevos_OFF(){
    document.getElementById("News").checked = false;
    window.sessionStorage.setItem("Nuevos_Ag", false);
}

//This function is accesed from processing, to turn on the congruence slider on click
function autoClickCongruence_ON(){
    document.getElementById("Congruencia").checked = true;
    checkAll();
}

//This function is accesed from processing, to turn off the congruence slideron click
function autoClickCongruence_OFF(){
    document.getElementById("Congruencia").checked = false;
    //Almacenamiento del estado actual de la pagina en caso de cambio
    window.sessionStorage.setItem("Congruencia_Ag", false);
}

//This function is accesed from processing, to turn on the congruence slider on click
function autoClickExclusion_ON(){
    document.getElementById("Exclusions").checked = true;
    checkAll();
}

//This function is accesed from processing, to turn off the congruence slideron click
function autoClickExclusion_OFF(){
    document.getElementById("Exclusions").checked = false;
    //Almacenamiento del estado actual de la pagina en caso de cambio
    window.sessionStorage.setItem("Exclusions_Ag", false);
}


//This function is accesed from processing, to turn on the congruence slider on click
function autoClickAll_ON(){
    document.getElementById("All").checked = true;
    //Almacenamiento del estado actual de la pagina en caso de cambio
    // window.sessionStorage.setItem("Congruencia_M", true);
}

//This function is accesed from processing, to turn off the congruence slideron click
function autoClickAll_OFF(){
    document.getElementById("All").checked = false;
    //Almacenamiento del estado actual de la pagina en caso de cambio
    window.sessionStorage.setItem("All_Ag", false);
}

//Check if all sliders are on and turn on the all slider
function checkAll(){
	if ( document.getElementById("Exclusions").checked == true 
		&& document.getElementById("Congruencia").checked == true 
		&& document.getElementById("News").checked == true
		&& document.getElementById("Splits").checked == true
		&& document.getElementById("Mergers").checked == true
		&& document.getElementById("Moves").checked == true
		&& document.getElementById("Renames").checked == true){
		autoClickAll_ON();
	}
}