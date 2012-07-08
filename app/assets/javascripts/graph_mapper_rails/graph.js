// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
function add_comma(input){
	var output = String(input);
	var tmp = "";
  while (output != (tmp = output.replace(/^([+-]?\d+)(\d\d\d)/,"$1,$2"))){
    output = tmp;
  }
	return output;
}
