function getStripeToken(){

  $('.event').click(function(){
    $('#hidden_event_id').val( $(this).data('id') )
    $('#event-info').html( $(this).data('event-info') )
  })

  $("#book-button").click(function() {

    // $("#user_submit").attr("disabled", true);
    // $("#reservation input, #reservation select").attr("name", "");
    // $("#credit-card-errors").hide();

    // if (!$("#reservation").is(":visible")) {
    //   $("#reservation input, #reservation select").attr("disabled", true);
    //   return true;
    // }
    
    var card = {
      number:   $("#credit_card_number").val(),
      expMonth: $("#exp_month").val(),
      expYear:  $("#exp_year").val(),
      cvc:      $("#cvv").val()
    };

    Stripe.setPublishableKey('pk_test_4KNIbgcUXuK1cAeGAoZgixpD');
    Stripe.card.createToken(card, function(status, response) {

      if (status === 200) {
        // $("#user_last_4_digits").val(response.card.last4);
        $("#stripe_token").val(response.id);
        $('#new_reservation').submit();
      } else {
        $("#stripe-error-message").text(response.error.message);
        $("#credit-card-errors").show();
        // $("#user_submit").attr("disabled", false);
      }
    });

    return false;
  });

  // $("#change-card a").click(function() {
  //   $("#change-card").hide();
  //   $("#reservation").show();
  //   $("#credit_card_number").focus();
  //   return false;
  // });
};

function getStripeToken_bank() {
  // FIRST NEW BANK ACCOUNT
  $('#add_bank_form_btn').click(function() {

    var bank = {
      country: 'US',
      routingNumber: $('#bank_routing_number').val(),
      accountNumber:  $('#bank_account_number').val()
    };

    $('#bank_routing_number').val('');
    $('#bank_account_number').val('');

    Stripe.setPublishableKey('pk_test_4KNIbgcUXuK1cAeGAoZgixpD');

    Stripe.bankAccount.createToken(bank, function(status, response) {

      if (status === 200) {
        $('#stripe_token').val(response.id);
        $('#add_bank_form').submit();
      } 
      else {
        console.log('error=> '+response.error.message);
        $("#stripe-error-message").text(response.error.message);
        // $("#stripe-error-message").text(response.error.message);
        // $("#credit-card-errors").show();
      }
    });
  });

  // UPDATE / CHANGE BANK ACCOUNT
  $('#update_bank_form_btn').click(function() {

    var bank = {
      country: 'US',
      routingNumber: $('#change_bank_form #bank_routing_number').val(),
      accountNumber:  $('#change_bank_form #bank_account_number').val()
    };

    $('#change_bank_form #bank_routing_number').val('');
    $('#change_bank_form #bank_account_number').val('');

    Stripe.setPublishableKey('pk_test_4KNIbgcUXuK1cAeGAoZgixpD');

    Stripe.bankAccount.createToken(bank, function(status, response) {

      if (status === 200) {
        $('#change_bank_form #update_stripe_token').val(response.id);
        $('#change_bank_form').submit();
      } 
      else {
        console.log('error=> '+response.error.message);
        $("#stripe-error-message").text(response.error.message);
        // $("#credit-card-errors").show();
      }
    });
  });
}
