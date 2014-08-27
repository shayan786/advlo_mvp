$('#waiver_new').empty()
$('#waiver_new').append("<%= escape_javascript("#{render partial: '/adventure_steps/new_waiver'}").html_safe %>");

$('#waiver_new .waiver-alert').show();
$('#waiver_new .waiver-alert').html('');
$('#waiver_new .waiver-alert').html('Succesfully deleted your waiver');

$('#upload-toggle').click(function(){
  $(this).hide();
  $('#upload_waiver').show();
})

$('#waiver_file').on('change', function(){
  if($('#waiver_file').get(0).files.length == 1){
    $('.upload-waiver-button').removeClass('disabled');
  }
})

$("#waiver_file").filestyle({input: true, icon: true, buttonText: "UPLOAD WAIVER"});
