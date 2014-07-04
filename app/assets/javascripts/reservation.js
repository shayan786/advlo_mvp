function getStripeToken(){
  // $("#reservation input, #reservation select").attr("disabled", false);

  $('.event').click(function(){
    $('#hidden_event_id').val( $(this).data('id') )
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
      expMonth: $("#expiry_month").val(),
      expYear:  $("#expiry_year").val(),
      cvc:      $("#cvv").val()
    };

    Stripe.setPublishableKey('pk_test_4KNIbgcUXuK1cAeGAoZgixpD');
    Stripe.createToken(card, function(status, response) {

      if (status === 200) {
        // $("#user_last_4_digits").val(response.card.last4);
        $("#stripe_token").val(response.id);
        $('#new_reservation').submit();
      } else {

        console.log('error=> '+response.error.message)
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
