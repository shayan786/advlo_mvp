$('#pre-check').remove()
$("#user-form-wrapper").html("<%= escape_javascript(render(partial: 'post_check.haml')) %>")
photoInput();
usersInit();