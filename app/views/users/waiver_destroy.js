$('#upload_waiver').hide();
$('.waiver-btn-row').remove()
$('.waiver-on-file').remove()
$('#update_waiver').hide()
$('#waiver_new').append("<%= escape_javascript("#{render partial: '/adventure_steps/new_waiver'}").html_safe %>");
$('.waiver-alert').html('');
$('.waiver-alert').html('You have deleted the waiver');


$('#update_waiver_toggle').click(function(){
  $(this).hide()
  $('#update_waiver').show()

  $('.waiver-btn').css('margin-left','35%')
  $('#delete_wavier').css('text-align','center')
})

$('#upload-toggle').click(function(){
  $('#upload_waiver').show()
  $(this).hide()
})