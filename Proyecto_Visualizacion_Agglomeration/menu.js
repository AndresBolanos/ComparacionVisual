
//This file contains code to execute animation for the vertical menu that is hidden with the option to
//load the files.
var contador = 1;
 
function main(){
	// $('nav').toggle(); 
	if(contador == 1){
		$('nav').animate({
			marginLeft: '-70px'
		});
		contador = 0;
	} else {
		contador = 1;
		$('nav').animate({
			marginLeft: '-400px'
		});
	}
}
 