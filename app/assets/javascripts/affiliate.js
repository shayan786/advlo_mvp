function create_account_btn_toggles() {
	$('#affiliate .affiliate_info .create_account_btn').click(function(){
		$('#affiliate .affiliate_info .create_account_box').fadeToggle();
	})
}

function add_paypal_btn_toggles() {
	$('#affiliate .affiliate_info .add_paypal_btn').click(function(){
		$('#affiliate .affiliate_info .add_paypal_box').fadeToggle();
	})

	$('#affiliate .affiliate_info .add_paypal_box #add_paypal_btn').click(function(){
		$('#affiliate .affiliate_info .add_paypal_box #add_paypal_form').submit();
	})

	$('#affiliate .affiliate_info .add_paypal_box #update_paypal_form #update_paypal_btn').click(function(){
		$('#affiliate .affiliate_info .add_paypal_box #update_paypal_form').submit();
	})

	$('#affiliate .affiliate_info .add_paypal_box #existing-paypal #change_paypal_btn').click(function(){
		$('#affiliate .affiliate_info .add_paypal_box #update_paypal_form').fadeIn();
	})
}

function code_plugin_btn_toggles() {
	$('#affiliate .affiliate_info .code_plugin_btn').click(function(){
		$('#affiliate .affiliate_info .code_plugin_box').fadeToggle();
	})

	$('#affiliate .affiliate_info .code_plugin_box .logo_option_btn').click(function(){
		$('#affiliate .affiliate_info .code_plugin_box .logo_option_btn').addClass('active');
		$('#affiliate .affiliate_info .code_plugin_box .link_option_btn').removeClass('active');

		$('#affiliate .affiliate_info .code_plugin_box .link_option_code').fadeOut();
		$('#affiliate .affiliate_info .code_plugin_box .logo_option_code').delay(400).fadeIn();
	})

	$('#affiliate .affiliate_info .code_plugin_box .link_option_btn').click(function(){
		$('#affiliate .affiliate_info .code_plugin_box .link_option_btn').addClass('active');
		$('#affiliate .affiliate_info .code_plugin_box .logo_option_btn').removeClass('active');

		$('#affiliate .affiliate_info .code_plugin_box .logo_option_code').fadeOut();
		$('#affiliate .affiliate_info .code_plugin_box .link_option_code').delay(400).fadeIn();
	})


	$('#affiliate .affiliate_info .code_plugin_box .logo_option_code .transparent_bg_btn').click(function(){
		$(this).addClass('active');
		$('#affiliate .affiliate_info .code_plugin_box .logo_option_code .white_bg_btn').removeClass('active');
		$('#affiliate .affiliate_info .code_plugin_box .logo_option_code .black_bg_btn').removeClass('active');

		$('#affiliate .affiliate_info .code_plugin_box .logo_option_code .logo_with_link').css({
			backgroundColor: 'transparent'
		})

		$('#affiliate .affiliate_info .code_plugin_box .logo_option_code .logo_with_link_code_to_copy').html(function(i,t){
		    return t.replace('#FFF','transparent')
		});

		//update the data value for the copy btn
		$('#affiliate .affiliate_info .code_plugin_box .logo_option_code .copy_code_btn').data('clipboard-text',$('#affiliate .affiliate_info .code_plugin_box .logo_option_code .logo_with_link_code_to_copy').text());

	})

	$('#affiliate .affiliate_info .code_plugin_box .logo_option_code .white_bg_btn').click(function(){
		$(this).addClass('active');
		$('#affiliate .affiliate_info .code_plugin_box .logo_option_code .transparent_bg_btn').removeClass('active');
		$('#affiliate .affiliate_info .code_plugin_box .logo_option_code .black_bg_btn').removeClass('active');

		$('#affiliate .affiliate_info .code_plugin_box .logo_option_code .logo_with_link').css({
			backgroundColor: '#FFF'
		})

		$('#affiliate .affiliate_info .code_plugin_box .logo_option_code .logo_with_link_code_to_copy').html(function(i,t){
		    return t.replace('#000','#FFF')
		});

		$('#affiliate .affiliate_info .code_plugin_box .logo_option_code .logo_with_link_code_to_copy').html(function(i,t){
		    return t.replace('transparent','#FFF')
		});

		//update the data value for the copy btn
		$('#affiliate .affiliate_info .code_plugin_box .logo_option_code .copy_code_btn').data('clipboard-text',$('#affiliate .affiliate_info .code_plugin_box .logo_option_code .logo_with_link_code_to_copy').text());
	})

	$('#affiliate .affiliate_info .code_plugin_box .logo_option_code .black_bg_btn').click(function(){
		$(this).addClass('active');
		$('#affiliate .affiliate_info .code_plugin_box .logo_option_code .transparent_bg_btn').removeClass('active');
		$('#affiliate .affiliate_info .code_plugin_box .logo_option_code .white_bg_btn').removeClass('active');

		$('#affiliate .affiliate_info .code_plugin_box .logo_option_code .logo_with_link').css({
			backgroundColor: '#000'
		})

		$('#affiliate .affiliate_info .code_plugin_box .logo_option_code .logo_with_link_code_to_copy').html(function(i,t){
		    return t.replace('#FFF','#000')
		});

		$('#affiliate .affiliate_info .code_plugin_box .logo_option_code .logo_with_link_code_to_copy').html(function(i,t){
		    return t.replace('transparent','#000')
		});

		//update the data value for the copy btn
		$('#affiliate .affiliate_info .code_plugin_box .logo_option_code .copy_code_btn').data('clipboard-text',$('#affiliate .affiliate_info .code_plugin_box .logo_option_code .logo_with_link_code_to_copy').text());
	})


	$(document).ready(function() {
	    var clip1 = new ZeroClipboard($("#affiliate .affiliate_info .code_plugin_box .logo_option_code .copy_code_btn"));
	    var clip2 = new ZeroClipboard($("#affiliate .affiliate_info .code_plugin_box .link_option_code .copy_code_btn"));
	});

	$("#affiliate .affiliate_info .code_plugin_box .logo_option_code .copy_code_btn").click(function(){
	    swal({
	        title: "Copied!",
	        imageUrl: "http://i.imgur.com/a6L0hYB.png"
	    });

	    $('#affiliate .affiliate_info .copy_code_checkbox').find('.fa-square-o').fadeOut();
		$('#affiliate .affiliate_info .copy_code_checkbox').find('.fa-check-square-o').delay(500).fadeIn();
	})

	$("#affiliate .affiliate_info .code_plugin_box .link_option_code .copy_code_btn").click(function(){
	    swal({
	        title: "Copied!",
	        imageUrl: "http://i.imgur.com/a6L0hYB.png"
	    });

	    $('#affiliate .affiliate_info .copy_code_checkbox').find('.fa-square-o').fadeOut();
		$('#affiliate .affiliate_info .copy_code_checkbox').find('.fa-check-square-o').delay(500).fadeIn();
	})
}

function toggle_code_plugin_box_on_load() {
	$('#affiliate .affiliate_info .code_plugin_box').show();
	$('#affiliate .affiliate_info .copy_code_checkbox .fa-square-o').hide();
	$('#affiliate .affiliate_info .copy_code_checkbox .fa-check-square-o').show();

	$(document).ready(function(){
		$('#affiliate .affiliate_info .code_plugin_box .logo_option_btn').click();
	})
}

function affliate_cookie_setup(referrer_id) {
    $.cookie('referrer_id', referrer_id, { expires: 1, path: '/' });

    $('#d_sign_up a.fb_btn').attr('href', "/users/auth/facebook?referrer_id="+referrer_id+"&affiliate_referral=true");
}

function new_user_set_referrer_id(referrer_id) {
	$('#d_sign_up #referrer_id').val(referrer_id);
	$('#d_sign_up a.fb_btn').attr('href', "/users/auth/facebook?referrer_id="+referrer_id+"&affiliate_referral=true");
}

function homepage_new_user_set_referrer_id(referrer_id) {
	$('#.scroll-slow .advlo-signup #signup_modal #referrer_id').val(referrer_id);
	$('.scroll-slow .advlo-signup a.homepage_fb_btn').attr('href', "/users/auth/facebook?referrer_id="+referrer_id+"&affiliate_referral=true");
}

function modal_new_user_set_referrer_id(referrer_id) {
  $('#member-modal #signup_modal #referrer_id').val(referrer_id);
  $('#member-modal .fb_btn').attr('href', "/users/auth/facebook?referrer_id="+referrer_id+"&affiliate_referral=true");
}

function update_affiliate_click_count(referrer_id) {
	$.ajax({
	    url: "/users/update_affiliate_referral_click_count",
	    dataType: "script",
	    data: {referrer_id: referrer_id},
	    type: "POST"
	});
}

function create_account_validation() {
	$('#affiliate .affiliate_info .create_account_box .login_form').bootstrapValidator({
      fields: {
      'user[email]': {
        validators: {
          notEmpty: {
            message: 'Email is required and cannot be empty'
          },
          emailAddress: {
            message: 'Not a valid email address'
          }
        }
      },
      'user[password]': {
        validators: {
          notEmpty: {
            message: 'Password cannot be empty'
          }
        }
      },
      'user[password_confirmation]': {
        validators: {
          notEmpty: {
            message: 'Password cannot be empty'
          }
        }
      }
    }
   })
}

function paypal_email_validation() {
  $('#affiliate .affiliate_info .add_paypal_box #update_paypal_btn').addClass('disabled');
  $('#affiliate .affiliate_info .add_paypal_box #add_paypal_btn').addClass('disabled');



  $('#affiliate .affiliate_info .add_paypal_box #update_paypal_form #paypal_email').on('keyup', function() {
    var details = $.trim($(this).val());

      if (details.length > 5) {
        $('#affiliate .affiliate_info .add_paypal_box #update_paypal_btn').removeClass('disabled');
      }
      else if (details.length <= 4) {
        $('#affiliate .affiliate_info .add_paypal_box #update_paypal_btn').addClass('disabled');
      }
  })

  $('#affiliate .affiliate_info .add_paypal_box #add_paypal_form #paypal_email').on('keyup', function() {
    var details = $.trim($(this).val());

      if (details.length > 5) {
        $('#affiliate .affiliate_info .add_paypal_box #add_paypal_btn').removeClass('disabled');
      }
      else if (details.length <= 4) {
        $('#affiliate .affiliate_info .add_paypal_box #add_paypal_btn').addClass('disabled');
      }
  })
}

function become_an_affiliate_form_submit() {
	$('#affiliate .affiliate_info .become_affiliate_btn').click(function(){
		$('#affiliate .affiliate_info .become_an_affiliate_form').submit();
	})
}

function affiliate_init() {
	create_account_validation();
	create_account_btn_toggles();
	paypal_email_validation();
	add_paypal_btn_toggles();
	code_plugin_btn_toggles();
	become_an_affiliate_form_submit();
}