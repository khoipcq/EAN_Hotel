function popupCenter(url, width, height, name) {
  var left = (screen.width/2)-(width/2);
  var top = (screen.height/2)-(height/2);
  return window.open(url, name, "menubar=no,toolbar=no,status=no,width="+width+",height="+height+",toolbar=no,left="+left+",top="+top);
}

$("a.popup").click(function(e) {
  popupCenter($(this).attr("href"), $(this).attr("data-width"), $(this).attr("data-height"), "authPopup");
  e.stopPropagation();
  return false;
});


//String prototype
String.prototype.capitalize = function(){
	return this.charAt(0).toUpperCase() + this.slice(1);
}

jQuery.validator.addMethod("noSpace", function(value, element){
	return value.indexOf(" ") < 0 && value != "";
}, "Space are not allowed");