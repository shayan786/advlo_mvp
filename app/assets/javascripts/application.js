// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
// require_tree .
//= require jquery
//= require jquery_ujs
//= require jquery.remotipart
// require jquery.ui.all
//= require jquery.timepicker.min
//= require jquery.rotate
//= require jquery.cookie
//= require jquery.blueimp-gallery.min
//= require bootstrap
//= require bootstrap-datepicker
//= require bootstrap-filestyle
//= require bootstrap-maxlength
//= require bootstrapValidator.min
//= require bootstrap-image-gallery.min
//= require idangerous.swiper.min
//= require masonry.pkgd.min.js
//= require imagesloaded.pkgd.min.js
//= require adventure.js
//= require homepage.js
//= require reservation.js
//= require user.js
//= require wallet.js
//= require affiliate.js
//= require promotion.js
//= require moment.min
//= require fullcalendar.min
//= require jquery.geocomplete.min
//= require star-rating.min
//= require readmore.min
//= require zeroclipboard
//= require event_tracking
//= require sweet-alert.min



$(document).ready(function(){
  footerInit();
  headerLoginToggle();
  mobileHeaderLoginToggle();
  // fixes the bug that you can click right below a modal to close it
  $('.modal-dialog').height($('.modal-body').last().css('height'))


  if( location.pathname.indexOf('giveaway') != 1 ){
    setTimeout(function(){
      $('#contest-link').slideToggle()
    }, 3500);
  }
})


$(document).ajaxStart(function(){
  if ($(window).width() <= 767) {
    $('#loader-spinner').css({
      top: $(window).height()/4,
      left: $(window).width()/4
    });
  }
  if ($(window).width() == 768) {
    $('#loader-spinner').css({
      top: $(window).height()/2.5,
      left: $(window).width()/2.5
    });
  }
  $('#loader-overlay').show();
});
$(document).ajaxStop(function(){
  $('#loader-overlay').fadeOut()
});


//Header resize on scroll
$(document).ready(function(){
	var flag = 0;

    if($(window).width() > 768){
    $(window).scroll(function () {
      if ($(this).scrollTop() > 50 && flag == 0) {

        // header items
        $('nav.navbar').animate({
        	padding: "0px 0px 0px 10px",
          height: "43px"
        });
        $('nav.navbar .navbar-brand').animate({
        	marginTop: "4px",
        	"background-size": "83%"
        });
        $('.logged_in_dropdown_box').animate({
          marginTop: "6px"
        });
        $('.logged_in_dropdown_box .user_name').animate({
          marginTop: "10px"
        });
        $('.logged_in_dropdown_box .profile_img').animate({
          width: "40px",
          height: "40px"
        });

        // menus
        $('#locations-menu').animate({
          top: '-4px'
        }, 200)

        $('.logged_in_dropdown_menu, .logged_out_dropdown_menu').animate({
          top: '50px'
        }, 200)

        flag = 1;
      }
      if ($(this).scrollTop() < 50 && flag == 1) {

        // header items
      	$('nav.navbar').animate({
        	padding: "4px 0px 4px 10px",
          height: "58px"
        });
        $('nav.navbar .navbar-brand').animate({
        	marginTop: "0px",
        	"background-size": "99%"
        });
        $('.logged_in_dropdown_box').animate({
          marginTop: "0px"
        });
        $('.logged_in_dropdown_box .user_name').animate({
          marginTop: "15px"
        });
        $('.logged_in_dropdown_box .profile_img').animate({
          width: "50px",
          height: "50px"
        });


        //menus
        $('#locations-menu').animate({
          top: '4px'
        }, 200)
        $('.logged_in_dropdown_menu, .logged_out_dropdown_menu').animate({
          top: '58px'
        }, 200)

        flag = 0;
      } 
    });
  }

  $('#wrapper').css({
    minHeight: $(window).height()
  })

  //Login form validation
  $('#sign_in_form').bootstrapValidator({
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
      }
    }
  });


  //Contact form validation
  $('#contact_form').bootstrapValidator({
    fields: {
      'contact[email]': {
        validators: {
          notEmpty: {
            message: 'Email is required and cannot be empty'
          },
          emailAddress: {
            message: 'Not a valid email address'
          }
        }
      },
      'contact[comments]': {
        validators: {
          notEmpty: {
            message: 'Comments/question is required and cannot be empty'
          }
        }
      }
    }
  });

  //request adventure form validation on button
  $('#request_form_modal .modal-dialog #request_location').on('keyup', function() {
  
    if ( $('#request_email').css('display') == undefined ) {
      $('#request_budget').keyup(function(){
        if($(this).val() != '' ){
          $('.request_btn').removeClass('disabled') 
        }
      })
    } 

    if ( $('#request_email').css('display') == 'block' ) {
      $('#request_email').keyup(function(){
        if($(this).val() != '' ){
          $('.request_btn').removeClass('disabled') 
        }
      })
    } 
  })


  //contact form submit button
  $('#contact_form_modal .modal-dialog .contact_btn').addClass('disabled');

  //request adventure form validation on button
  $('#contact_form_modal .modal-dialog #contact_comments').on('keyup', function() {
    var details = $.trim($(this).val());

      if (details.length > 6) {
        $('#contact_form_modal .modal-dialog .contact_btn').removeClass('disabled');
      }
      else if (details.length <= 6) {
        $('#contact_form_modal .modal-dialog .contact_btn').addClass('disabled');
      }
  })
});



function footerInit(){

  $('#contact_form .contact_btn').click(function() {
    if($('#honeypot input').val() == ''){
      $('#contact_form').submit();
    } else {
      location.reload();
    }
  })

  $('.sign_up_toggle_btn').click(function(){
    $('#signup_modal').fadeIn();
    $(this).hide();
  })

  $('.popup_login').click(function(){
    $('.popup_login_form').fadeIn();
    $(this).hide();
  })

  $('.homepage_login').click(function(){
    $('.homepage_login_form').fadeIn();
    $(this).hide();
    $('#arrow-wrapper').hide()
  })

  $('.homepage_login_bottom').click(function(){
    $('.homepage_login_form_bottom').fadeIn();
    $(this).hide();
    $('#arrow-wrapper').hide()
  })


  
  $('.homepage_email_btn').hover(function(){
    $(this).css('background','rgba(195, 91, 38, 1)')
  },function(){
    $(this).css('background','rgba(195, 91, 38, 0.8)')
  })

  $('.sign_up_btn').hover(function(){
    $(this).css('background','rgba(195, 91, 38, 1)')
  },function(){
    $(this).css('background','rgba(195, 91, 38, 0.8)')
  })


  $('.question').click(function(){
    $('.question-wrapper').hide()
    $('.form-wrapper').fadeIn(2000)
    $('#network h4').text($(this).data('text'))

    console.log("$(this).data('link')=> " +$(this).data('link'))

    $('.poll-link').attr('href', $(this).data('link'))

    $('.'+$(this).data('answer')).css('border','3px solid #fff')

    $('#newsletter_category').val($(this).data('poll'))



    console.log(  parseInt($('.'+$(this).data('answer')).last().children().html()) + 1  )
    var totalPolls = parseInt($('.poll-answers').data('total'))
    console.log(parseInt($('.poll-answers').data('total')))

    $('.answer-1').last().children().html( ((parseInt($('.answer-1').last().children().html() ) / totalPolls) * 100).toString().substring(0,4) + '%' )
    $('.answer-1').last().prepend($('.answer-1').first().data('poll'))
    
    $('.answer-2').last().children().html( ((parseInt($('.answer-2').last().children().html() ) / totalPolls) * 100).toString().substring(0,4) + '%' )
    $('.answer-2').last().prepend($('.answer-2').first().data('poll'))

    $('.answer-3').last().children().html( ((parseInt($('.answer-3').last().children().html() ) / totalPolls) * 100).toString().substring(0,4) + '%' )
    $('.answer-3').last().prepend($('.answer-3').first().data('poll'))


    var btnColor = $('.'+$(this).data('answer')).css('background-color')

    $('#email_list_toggle').css('background-color', btnColor)
    $('#email_list_button').css('background-color', btnColor)
  }) 
}

function remove_notice(seconds) {
  var time = seconds*1000;

  setTimeout(function() {
    $('.alert').fadeOut('slow');
  }, time);
}