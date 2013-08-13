$(document).ready(function(){
	$("form.edit_user").validate({
		onfocusout:false,
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
				minlength: 6,
				required: true
			},
			"user[password_confirmation]": {
				equalTo: "#user_password",
				required: true
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
			"user[password_confirmation]":{
				equalTo: "Password confirmation does not match",
				required: "Please enter Confirmation password"
			},
			"user[current_password]":{
				required: "Please enter Current password"
			},
			"user[password]": {
				minlength: "Please enter at least 6 characters",
				required: "Please enter New password"
			}
		},
		errorPlacement: function(error, element){
			error.appendTo(element.parent());
		}
	})
	$("#user_password").val("");
	$("#user_password").keyup(function(){
 		$('#strength_result').html(passwordStrength($('#user_password').val(),"123456"))
 })

})