$('form#request_reservation').remove();
$('#request_reservation #stripe-error-message').remove();
// $('.modal-backdrop').first().remove();
// $('#event-modal').toggle();

$('#request_reservation #success').show();
$('#request_reservation #success-detail').show();
$('#request_reservation #advlo-logo').show()

$('#request_reservation #success').text('Your reservation request has been received!');
$('#request_reservation #success-detail').text("You will be notified via email when the host accepts or rejects your reservation request");