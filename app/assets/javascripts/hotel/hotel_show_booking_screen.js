jQuery(document).ready(function($) {
	
	$("#hotel_country_name").val("US");
	
	/**
	$("#agree").live('click', function(){
  	$("#agree_error").hide();
  });
 
  $("#first_name").live('change', function(){
  	$("#first_name_error").hide();
   });
  $("#last_name").live('change', function(){
  	$("#last_name_error").hide();
   });
  $("#email").live('change', function(){
  	$("#email_address_error").hide();
   });
  $("#phone").live('change', function(){
  	$("#phone_error").hide();
   });
  $("#p_first_name").live('change', function(){
  	$("#p_first_name_error").hide();
   });
  $("#p_last_name").live('change', function(){
  	$("#p_last_name_error").hide();
   });
  $("#p_card_num").live('change', function(){
  	$("#p_card_num_error").hide();
   });
  $("#p_csv_code").live('change', function(){
  	$("#p_csv_code_error").hide();
   });
  $("#ba_address").live('change', function(){
  	$("#ba_address_error").hide();
   });
  $("#ba_city").live('change', function(){
  	$("#ba_city_error").hide();
   });
  $("#ba_state").live('change', function(){
  	$("#ba_state_error").hide();
   });
  
  $("#ba_zip_code").live('change', function(){
  	$("#ba_zip_code_error").hide();
   });
  
  $("#creditCardExpirationMonth").live('change', function(){
    $("#expired_date_error").hide();
   });

  $("#creditCardExpirationYear").live('change', function(){
    $("#expired_date_error").hide();
   });

  $("#confirm").live('click', function(){
  	window.location = "/";
  });
    
  $("#book-btn").live('click', function(){
    $("#agree_error").hide();
    //get form tag
    var form  = $(this).closest("form");
    
    for(var i=1;i <= number_of_rooms;i++){
      var t = String(i);
      $("#r" + t + "_first_name").bind('change', function(){
	      $("#" + $(this).attr('id') + "_error").hide();
	    });
	    $("#r" + t + "_last_name").bind('change', function(){
	      $("#" + $(this).attr('id') + "_error").hide();
	    });
	  }
    var is_return = false;
    if($("#first_name").val().trim() == ""){
      $("#first_name_error").show();     
      $("#first_name").focus(); 
      is_return = true;
    }
    if($("#last_name").val().trim() == ""){
      $("#last_name_error").show();
      if(!is_return)
      	$("#last_name").focus();
      is_return = true;
    }
    if($("#email").val().trim() == ""){
      $("#email_address_error").show();
      if(!is_return)
      	$("#email").focus();
      is_return = true;
    }
    if($("#phone").val().trim() == ""){
      $("#phone_error").show();
      if(!is_return)
      	$("#phone").focus();
      is_return = true;
    }
    for(var i=1;i <= number_of_rooms;i++){
      if($("#r" + String(i) + "_first_name").val().trim() == ""){
        $("#r" + String(i) + "_first_name_error").show();
        if(!is_return)
      		$("#r" + String(i) + "_first_name").focus();
        is_return = true;
      }
      if($("#r" + String(i) + "_last_name").val().trim() == ""){
        $("#r" + String(i) + "_last_name_error").show();
        if(!is_return)
      		$("#r" + String(i) + "_last_name").focus();
        is_return = true;
      }

    }
    if($("#p_first_name").val().trim() == ""){
      $("#p_first_name_error").show();
      if(!is_return)
      	$("#p_first_name").focus();
      is_return = true;
    }
    if($("#p_last_name").val().trim() == ""){
      $("#p_last_name_error").show();
      if(!is_return)
      	$("#p_last_name").focus();
      is_return = true;
    }
    if($("#p_card_num").val().trim() == ""){
      $("#p_card_num_error").show();
      if(!is_return)
      	$("#p_card_num").focus();
      is_return = true;
    }
    if($("#p_csv_code").val().trim() == ""){
      $("#p_csv_code_error").show();
      if(!is_return)
      	$("#p_csv_code").focus();
      is_return = true;
    }
    if($("#creditCardExpirationMonth").val().trim() == ""){
      $("#expired_date_error").show();
      if(!is_return)
      	$("#creditCardExpirationMonth").focus();
      is_return = true;
    }
    
    if($("#creditCardExpirationYear").val().trim() == ""){
      $("#expired_date_error").show();
      if(!is_return)
      	$("#creditCardExpirationYear").focus();
      is_return = true;
    }
    
    if($("#ba_address").val().trim() == ""){
      $("#ba_address_error").show();
      if(!is_return)
      	$("#ba_address").focus();
      is_return = true;
    }
    if($("#ba_city").val().trim() == ""){
      $("#ba_city_error").show();
      if(!is_return)
      	$("#ba_city").focus();
      is_return = true;
    }
    if($("#ba_state").val().trim() == ""){
      $("#ba_state_error").show();
      if(!is_return)
      	$("#ba_state").focus();
      is_return = true;
    }
    if($("#ba_zip_code").val().trim() == ""){
      $("#ba_zip_code_error").show();
      if(!is_return)
      	$("#ba_zip_code").focus();
      is_return = true;
    }
    if(!$("#agree")[0].checked){
      $("#agree_error").show();
      if(!is_return)
      	$("#agree")[0].focus();
      is_return = true;
    }
    if(!is_return){
      var input = $("<input>").attr("type", "hidden").attr("name", 'authenticity_token').val(g_token);
      for(var i = 1; i <= number_of_rooms; i++){
        form.append($("<input>").attr("type", "hidden").attr("name",'r' + String(i) + '_bed_type_description').val($("#r" + String(i) + "_bed_type option:selected").text()));  
      }
      
      form.append($(input));
      form.submit();
    }
    // add token
    
  	});
  **/
});