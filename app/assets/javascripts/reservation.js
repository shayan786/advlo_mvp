function getStripeToken(){

  $('.event').click(function(){
    $('#hidden_event_id').val( $(this).data('id') )
    $('#event-info').html( $(this).data('event-info') )

    var adv_cap_min = $(this).data('adv-cap-min');
    var adv_cap_max = $(this).data('adv-cap-max');
    var adv_reserved = $(this).data('adv-reserved');

    var adv_cap_remain = adv_cap_max - adv_reserved;

    var i = adv_cap_min;

    for (; i <= adv_cap_remain; i++) {
      if (adv_cap_remain < adv_cap_min){
        break;
      }

      var option_string = "<option name='reservation_count' value='"+i+"'>"+i+"</option>";
      $('.cap_selector').append(option_string);
    }
  })

  $('.cap_selector').change(function() {
    var count = $(this).val();
    var price = $('#adv_price').val();
    var cost = count*price;

    $('.reservation_cost').empty();
    $('.reservation_cost').append("$ "+cost);
  });

  $("#book-button").click(function() {

    // $("#user_submit").attr("disabled", true);
    // $("#reservation input, #reservation select").attr("name", "");

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
        $("#reservation_head_count").val($('.cap_selector').val());

        var total_price = $('.cap_selector').val()*$('#adv_price').val()
        $('#reservation_total_price').val(total_price)
        
        $('#new_reservation').submit();
      } else {
        $("#stripe-error-message").text(response.error.message);
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
      }
    });
  });
}
