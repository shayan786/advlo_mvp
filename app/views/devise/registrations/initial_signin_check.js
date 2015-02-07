$('#pre-check').remove()
$("#user-form-wrapper").html("<%= escape_javascript(render(partial: 'post_check.haml')) %>")
photoInput();
usersInit();


var type = '<%= @user.guide_type %>'
$('.account-alert').show()

if( type == 'company') {
  $('.account-alert').html("Complete your Company profile to upload an adventure.")  
} else if ( type == 'local' ) {
  $('.account-alert').html("Complete your personal profile to upload an adventure.")
} else {
  $('.account-alert').html("Complete your profile so guides know who they will be hosting.")
}
