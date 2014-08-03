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

	$('.cancellation_btn').click(function() {
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


function bookings_init() {
	user_cancellation();
}

function reservations_init(){
	host_cancellation();
}

function payouts_init() {

}