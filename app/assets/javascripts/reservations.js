jQuery(document).ready(function($) {

$("#confirm").live('click', function(){
	window.location= "/";
});

$("#cancel_booking").fancybox({
});

$("#btn-cancel").live('click', function(){
  var room_id = $('#choose-room input[type=radio]:checked').val();
  if(!room_id)
    return;
  query_str = "reservation_id=" + reservation_id +"&res_room=" + room_id;  
  window.location = new Array(cancel_path,query_str).join("?");
}); 

$("#btn-close").live('click', function(){
  $.fancybox.close();
});

$('#uncancel-booking').live('click', function(){
  window.location= "/";
});

$("#confirm-cancel").fancybox({
});

$("#confirm-cancel-ok").live('click', function(){
  var form = $(this).closest("form");
  form.submit();  
});



});