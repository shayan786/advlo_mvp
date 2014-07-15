$('#new_reservation').remove();
$('#stripe-error-message').remove();
$('.modal-backdrop').first().remove();
$('#event-modal').toggle();

$('#success').show();
$('#success-detail').show();

$('#success').text('You are going on an adventure!');
$('#success-detail').text("You will receive an email confirmation shortly with all the adventure details. You can now contact the guide to setup any specific details. Can't wait to hear about your experience");
$('#advlo-logo').append('<img id="advlo_thanks" src="/assets/logos/advlo_header_logo.png" />');