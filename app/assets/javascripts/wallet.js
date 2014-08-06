function host_cancellation() {
	$('#host_cancel_reservation_modal #host_cancel_form #host_cancel_details').on('keyup', function() {
		var details = $.trim($(this).val());

	    if (details.length > 8) {
	      	$('#host_cancel_reservation_modal #host_cancel_form .cancel_btn').removeClass('disabled');
	    }
	    else if (details.length <= 8) {
	    	$('#host_cancel_reservation_modal #host_cancel_form .cancel_btn').addClass('disabled');
	    }
	})

	$('.cancellation_btn').click(function() {
		var res_id = $(this).data('res-id');
		var adv_title = $(this).data('adventure-title');
		var res_time = $(this).data('event-time');

		$('#host_cancel_reservation_modal #host_cancel_form #reservation_id').val(res_id);
		$('#host_cancel_reservation_modal #cancel_host_submitted .adv_title').empty();
		$('#host_cancel_reservation_modal #cancel_host_submitted .adv_title').append(adv_title);
		$('#host_cancel_reservation_modal #cancel_host_submitted .adv_time').empty();
		$('#host_cancel_reservation_modal #cancel_host_submitted .adv_time').append(res_time);
	})
}

function user_cancellation() {
	$('#user_cancel_reservation_modal #user_cancel_form #user_cancel_details').on('keyup', function() {
		var details = $.trim($(this).val());

	    if (details.length > 8) {
	      	$('#user_cancel_reservation_modal #user_cancel_form .cancel_btn').removeClass('disabled');
	    }
	    else if (details.length <= 8) {
	    	$('#user_cancel_reservation_modal #user_cancel_form .cancel_btn').addClass('disabled');
	    }
	})

	$('.actions_btn').click(function() {
		var res_id = $(this).data('res-id');
		var adv_title = $(this).data('adventure-title');
		var res_time = $(this).data('event-time');
		var refund_amount = $(this).data('refund-amount').toFixed(2);

		$('#user_cancel_reservation_modal #user_cancel_form #reservation_id').val(res_id);
		$('#user_cancel_reservation_modal #cancel_user_submitted .adv_title').empty();
		$('#user_cancel_reservation_modal #cancel_user_submitted .adv_title').append(adv_title);
		$('#user_cancel_reservation_modal #cancel_user_submitted .adv_time').empty();
		$('#user_cancel_reservation_modal #cancel_user_submitted .adv_time').append(res_time);
		$('#user_cancel_reservation_modal #cancel_user_submitted .res_refund_amount').empty();
		$('#user_cancel_reservation_modal #cancel_user_submitted .res_refund_amount').append("Refund Amount: $ "+refund_amount);
	})
}

function host_contact_validation() {
  $('#contact_host_modal .contact_host_form .contact_btn').addClass('disabled');

  $('#contact_host_modal .contact_host_form #contact_message').on('keyup', function() {
    var details = $.trim($(this).val());

      if (details.length > 8) {
          $('#contact_host_modal .contact_host_form .contact_btn').removeClass('disabled');
      }
      else if (details.length <= 8) {
        $('#contact_host_modal .contact_host_form .contact_btn').addClass('disabled');
      }
  })
}

function actions_button_popover() {
  $('.actions_btn').popover({
    html: true,
    trigger: 'focus'
  })
}

function adv_review_ratings_init() {
  $(".adventure_review_form #adv_rating_input").rating({
    'min': 0,
    'max': 5,
    'step': 0.5,
    'size': 'xs',
    'showCaption': true,
    'showClear': false,
    'starCaptions': {
      0.5: '0.5',
      1: '1.0',
      1.5: '1.5',
      2: '2.0',
      2.5: '2.5',
      3: '3.0',
      3.5: '3.5',
      4: '4.0',
      4.5: '4.5',
      5: '5.0'
    }
  });

  $(".adventure_review_form #host_rating_input").rating({
    'min': 0,
    'max': 5,
    'step': 0.5,
    'size': 'xs',
    'showCaption': true,
    'showClear': false,
    'starCaptions': {
      0.5: '0.5',
      1: '1.0',
      1.5: '1.5',
      2: '2.0',
      2.5: '2.5',
      3: '3.0',
      3.5: '3.5',
      4: '4.0',
      4.5: '4.5',
      5: '5.0'
    }
  });

  $('.adventure_review_form #adv_rating_input').on('rating.change', function(event, value, caption) {
    $('.adventure_review_form #adv_rating').val(value);
  });

  $('.adventure_review_form #host_rating_input').on('rating.change', function(event, value, caption) {
    $('.adventure_review_form #host_rating').val(value);
  });  

  $('.adventure_review_form #adv_rating').val($('.adventure_review_form #adv_rating_input').val());
  $('.adventure_review_form #host_rating').val($('.adventure_review_form #host_rating_input').val());

}

function bookings_init() {
	user_cancellation();
	actions_button_popover();
	adv_review_ratings_init();
  host_contact_validation();
}

function reservations_init(){
	host_cancellation();
}

function payouts_init() {

}