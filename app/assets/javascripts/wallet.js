function host_cancellation() {
	$('.actions_btn').click(function() {
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

function host_request_actions() {

  $('.actions_btn').click(function() {
    var res_id = $(this).data('res-id');

    $('#request_approve_btn_'+res_id).click(function(e) {
      var response = confirm("Approve this adventure request? The traveler will be charged at this time.");

      if(response == true){
        $.ajax({
          url: "/reservations/" + res_id,
          dataType: "script",
          data: {approve: "true"},
          type: "POST",
          method: "PUT"
        });
      }
    });

    $('#request_reject_btn_'+res_id).click(function(e) {
      var response = confirm("Reject this adventure request?");

      if(response == true){
        $.ajax({
          url: "/reservations/" + res_id,
          dataType: "script",
          data: {approve: "false"},
          type: "POST",
          method: "PUT"
        });
      }
    });

  })
}

function user_cancellation() {
	$('.actions_btn').click(function() {
		var res_id = $(this).data('res-id');
		var adv_title = $(this).data('adventure-title');
		var res_time = $(this).data('event-time');
		var refund_amount = parseFloat(Math.round(($(this).data('refund-amount')*100)/100)).toFixed(2);

		$('#user_cancel_reservation_modal #user_cancel_form #reservation_id').val(res_id);
		$('#user_cancel_reservation_modal #cancel_user_submitted .adv_title').empty();
		$('#user_cancel_reservation_modal #cancel_user_submitted .adv_title').append(adv_title);
		$('#user_cancel_reservation_modal #cancel_user_submitted .adv_time').empty();
		$('#user_cancel_reservation_modal #cancel_user_submitted .adv_time').append(res_time);
		$('#user_cancel_reservation_modal #cancel_user_submitted .res_refund_amount').empty();
		$('#user_cancel_reservation_modal #cancel_user_submitted .res_refund_amount').append("Refund Amount: $ "+refund_amount);

    $('#user_cancel_reservation_modal .cancellation_note').html('');
    $("#user_cancel_details").val('')

    if (refund_amount == 0) {
      var cancel_note = "<strong> THIS EXCEEDS THE 48 HR CANCELLATION POLICY. <br> YOU WILL NOT RECEIVE A REFUND IF YOU CANCEL THIS RESERVATION </strong>"

      $('#user_cancel_reservation_modal .cancellation_note').html(cancel_note);
    }
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

function traveler_contact_validation() {
  $('#contact_traveler_modal .contact_traveler_form .contact_btn').addClass('disabled');

  $('#contact_traveler_modal .contact_traveler_form #contact_message').on('keyup', function() {
    var details = $.trim($(this).val());

      if (details.length > 5) {
          $('#contact_traveler_modal .contact_traveler_form .contact_btn').removeClass('disabled');
      }
      else if (details.length <= 5) {
        $('#contact_traveler_modal .contact_traveler_form .contact_btn').addClass('disabled');
      }
  })
}


function actions_button_popover() {
  $('.actions_btn').popover({
    html: true,
    trigger: 'focus'
  })
}

function adv_review_validation() {
  $('#adventure_review_modal').on('shown.bs.modal', function(e){
    $('#adventure_review_modal .adventure_review_form .review-button').addClass('disabled');

    if ($('#adventure_review_modal .adventure_review_form #adv_rating_input').val() && $('#adventure_review_modal .adventure_review_form #host_rating_input').val() && $('#adventure_review_modal .adventure_review_form #adv_review_comments').val()) {
      $('#adventure_review_modal .adventure_review_form .review-button').removeClass('disabled');    
    }

    $('#adventure_review_modal .adventure_review_form #adv_review_comments').on('keyup', function() {
      var details = $.trim($(this).val());

        if (details.length > 4) {
            $('#adventure_review_modal .adventure_review_form .review-button').removeClass('disabled');
        }
        else if (details.length <= 4) {
          $('#adventure_review_modal .adventure_review_form .review-button').addClass('disabled');
        }
    })
  });
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

function invite_social_init(){
  window.fbAsyncInit = function(){
    FB.init({
      appId: '210802829129036', status: true, cookie: true, xfbml: true }); 
  };
  
  (function(d, debug){var js, id = 'facebook-jssdk', ref = d.getElementsByTagName('script')[0];if   (d.getElementById(id)) {return;}js = d.createElement('script'); js.id = id; js.async = true;js.src = "//connect.facebook.net/en_US/all" + (debug ? "/debug" : "") + ".js";ref.parentNode.insertBefore(js, ref);}(document, /*debug*/ false));
  
  function postToFeed(title, desc, url, image){
  var obj = {method: 'feed',link: url, picture: image,name: title,description: desc};
  
  function callback(response){}
    FB.ui(obj, callback);
  }

  $('.fb').click(function(e) {
    e.preventDefault();

    elem = $(this);

    postToFeed(elem.data('title'), elem.data('desc'), elem.prop('href'), elem.data('image'))
  })

  $('.twitter').click(function(){
    var encodedUrl = encodeURIComponent(document.URL);
    var invite_url = $(this).data('invite-url');
    height = $(window).height();
    width = $(window).width();

    window.open("https://twitter.com/share?url=" + invite_url + "&text=Sign-up on @Advlo_ to help me receive $25 towards and amazing adventure. %23AdventureLocal", 'sharer', 'top=' + (height/3) + ',left=' + (width/3) + ',toolbar=0,status=0,width=' + 500 + ',height=' + 500);
  })
}

function wallet_invite_init() {

}

function standalone_invite_init() {
  invite_social_init();
}

function bookings_init() {
	user_cancellation();
	actions_button_popover();
	adv_review_ratings_init();
  host_contact_validation();
  adv_review_validation();
}

function reservations_init(){
	host_cancellation();
  host_request_actions();
  actions_button_popover();
  traveler_contact_validation();
}

function payouts_init() {

}