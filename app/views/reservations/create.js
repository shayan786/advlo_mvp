$('#new_reservation').remove();
$('#stripe-error-message').remove();

$('#success').show();
$('#success-detail').show();
$('#advlo-logo').show();

$('#success').text('You are going on an adventure!');
$('#success-detail').text("You will receive an email confirmation shortly with all the adventure details. You can now contact the guide to setup any specific details. Can't wait to hear about your experience");


// If user clicks out of the thankyou modal, refresh the page
$('#reservations-modal').on('hide.bs.modal', function(e){
	window.location.reload(true);
})