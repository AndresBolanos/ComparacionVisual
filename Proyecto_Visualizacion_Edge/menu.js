
console.log("Hola");
 
var contador = 1;
 
function main(){
	// $('nav').toggle(); 
	console.log("Pasa");
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
 