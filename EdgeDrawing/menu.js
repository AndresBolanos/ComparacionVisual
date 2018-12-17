
 
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
 