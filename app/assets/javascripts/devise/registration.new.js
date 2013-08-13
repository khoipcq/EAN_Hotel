$(document).ready(function(){
	$("form#new_user").validate({
		onfocusout:function(element) { $(element).valid(); },
		onfocusin: false,
		onkeyup: false,
		focusCleanup: true,
		onfocusout: function(element){$(element).valid();},
		rules:{
			"user[first_name]": {
				required: true,
				minlength:2,
				maxlength: 50
			},
			"user[last_name]": {
				required: true,
				minlength:2,
				maxlength: 50
			},
			"user[email]":{
				required: true,
				email: true
			},
			"user[password]": {
				required: true,
				minlength: 6,
				noSpace: true
			},
			"user[password_confirmation]": {
				equalTo: "#user_password"
			},
			"user[current_password]":{
				required: true
			}
		},
		messages:{
			"user[first_name]":{
				required: "Please enter First name",
				minlength: "Please enter at least 2 characters"
			},
			"user[last_name]": {
				required: "Please enter Last name",
				minlength: "Please enter at least 2 characters"
			},
			"user[email]":{
				required: "Please enter Email",
				email: "Email is invalid"
			},
			"user[password]":{
				required: "Please enter Password",
				minlength: "Please enter at least 6 characters, no space",
				noSpace: "Space are not allowed in password"
			},
			"user[password_confirmation]":{
				equalTo: "Password confirmation does not match"
			},
			"user[current_password]":{
				required: "Please enter Current password"
			}
		},
		errorPlacement: function(error, element){
			error.appendTo(element.parent());
		}
	})
  $("#user_email").keyup(function(){
    $("#email_error").hide();
  })
 $("#user_password").keyup(function(){
 	$('#strength_result').html(passwordStrength($('#user_password').val(),$('#user_email').val()))
 })
})