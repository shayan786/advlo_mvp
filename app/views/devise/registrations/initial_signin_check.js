$('#pre-check').remove()
$("#user-form-wrapper").html("<%= escape_javascript(render(partial: 'post_check.haml')) %>")
photoInput();

$('#host').click(function(){
  $('.traveler-only-form').hide()
  $('.host-only-form').show()
  $('.basic-form').show()
  $('.host-checklist').show()

})
$('#traveler').click(function(){
  $('.traveler-only-form').show()
  $('.host-only-form').hide()
  $('.basic-form').show()
  $('.host-checklist').hide()    
})

usersInit();