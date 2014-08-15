$('#stripe-error-message').empty();

$("#card-decline-error").html('')
$("#card-decline-error").html('<%= @card_error %>')