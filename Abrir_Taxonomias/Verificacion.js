function VerificarDatos(){
	//try{
		var e1 = document.getElementById("file1");
		var file1 = e1.options[e1.selectedIndex].value; 
		var e2 = document.getElementById("file2");
		var file2 = e2.options[e2.selectedIndex].value;
		//var n = file1.lastIndexOf(".");
		console.log("File 1>>"+file1);
		console.log("File 2>>"+file2);
		//console.log(window.opener);
		window.opener.file1 = file1;
		window.opener.file2 = file2;
		//window.opener.getElementById('ExclusionStatsValue').innerHTML = "25"; 
		window.close();
		
	/*}
	catch{
		alert("Invalid Files");
	}*/
}