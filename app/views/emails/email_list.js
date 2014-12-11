$('#signup-please-modal .thanks-div').css('color','#fff')
$('#signup-please-modal .question-wrapper').hide()
$('#signup-please-modal .form-wrapper').hide()
$('#signup-please-modal .thanks-div').html("You will hear from us shortly")
$('.thanks-div').css({
  marginTop: '30px',
  marginBottom: '30px'
})
setTimeout(function(){
  $('#close-signup-modal').click()
}, 3200);


