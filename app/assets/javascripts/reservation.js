function getStripeToken(){

  $('.event').click(function(){
    $('.cap_selector').empty()
    $('#hidden_event_id').val( $(this).data('id') )
    $('#event_id').val( $(this).data('id') )
    $('#event-info').html( $(this).data('event-info') )
    $("#reservation_start_time").val( $(this).data('event-start-time') )

    var adv_cap_min = $(this).data('adv-cap-min');
    var adv_cap_max = $(this).data('adv-cap-max');
    var adv_reserved = $(this).data('adv-reserved');

    var adv_cap_remain = adv_cap_max - adv_reserved;

    if(adv_reserved >= adv_cap_min){
      adv_cap_min = 1;
    }else if(adv_reserved != 0) {
      adv_cap_min = (adv_cap_min - adv_reserved);
    }

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
    var cost = Math.round(count*price*100/100)
    var fees = Math.round(cost*0.04*100/100)
    var total_cost = cost+fees;

    $('.reservation_cost').empty();
    $('.reservation_cost').append("$ "+total_cost.toFixed(2));

    $('.reservation_breakdown').empty();
    $('.reservation_breakdown').append("($ "+cost.toFixed(2)+" + $ "+fees.toFixed(2)+" fees)");
  });

  $("#reservations-modal #reservation #book-button").click(function() {

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

function getStripeToken_request(){

  $("#request-book-button").click(function() {

    // $("#user_submit").attr("disabled", true);
    // $("#reservation input, #reservation select").attr("name", "");

    // if (!$("#reservation").is(":visible")) {
    //   $("#reservation input, #reservation select").attr("disabled", true);
    //   return true;
    // }
    
    var card = {
      number:   $("#request_reservation #credit_card_number").val(),
      expMonth: $("#request_reservation #exp_month").val(),
      expYear:  $("#request_reservation #exp_year").val(),
      cvc:      $("#request_reservation #cvv").val()
    };

    Stripe.setPublishableKey('pk_test_4KNIbgcUXuK1cAeGAoZgixpD');
    Stripe.card.createToken(card, function(status, response) {

      if (status === 200) {
        // $("#user_last_4_digits").val(response.card.last4);
        $("#request_reservation #stripe_token").val(response.id);

        $('#request_reservation form#request_reservation').submit();
      } else {
        $("#request_reservation #stripe-error-message").text(response.error.message);
        // $("#user_submit").attr("disabled", false);
      }
    });

    return false;
  });
};

function reservation_request_prefill() {

  $('#request_time_form .request_time_btn').click(function() {
    var request_date = $('#request_time_form #request_reservation_date').val();
    var request_time = $('#request_time_form #request_reservation_time').val();
    var request_head_count = $('#request_time_form #request_reservation_head_count').val();
    var adv_price = $('#request_reservation #adv_price').val();

    var cost = Math.round(request_head_count*adv_price*100/100)
    var fees = Math.round(cost*0.04*100/100)
    var total_cost = cost+fees;

    $('#request_reservation #hidden_request_reservation_date').val(request_date);
    $('#request_reservation #hidden_request_reservation_time').val(request_time);
    $('#request_reservation #reservation_head_count').val(request_head_count);
    $('#request_reservation #reservation_total_price').val(total_cost);

    //Modify display from user inputs
    var reservation_info = "REQUEST:  "+request_date + " - " + request_time;
    $('#request_reservation #event-info').empty();
    $('#request_reservation #event-info').append(reservation_info);

    $('#request_reservation .prefill_request_people').empty();
    $('#request_reservation .prefill_request_people').append(request_head_count);

    $('#request_reservation .prefill_request_cost').empty();
    $('#request_reservation .prefill_request_cost').append("$ "+total_cost.toFixed(2));

    $('#request_reservation .prefill_request_breakdown').empty();
    $('#request_reservation .prefill_request_breakdown').append("($ "+cost.toFixed(2)+" + $ "+fees.toFixed(2)+" fees)");
  });
}

function reservation_modals_show_hide() {
  // Hide the event modal when the reservation (payment) modal is shown
  $('#reservations-modal').on('shown.bs.modal', function(e){
    $('#event-modal').modal('hide');
  })

   $('#reservations-request-modal').on('shown.bs.modal', function(e){
    $('#event-modal').modal('hide');
  })

}

function paypal_forms_control() {
  $('#add-paypal').click(function(){
    $('#existing-paypal').fadeToggle();
    $('#add_paypal_form').fadeToggle();
  });

  $('#change_paypal_btn').click(function() {
    $('#update_paypal_form').fadeToggle();
  })

  $('#update_paypal_btn').click(function() {
    //Verify email field is not empty
    $('#update_paypal_form').submit();
  })

  $('#add_paypal_btn').click(function() {
    $('#add_paypal_form').submit();
  })
}
