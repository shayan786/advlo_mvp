function homepageTextScroll(){
  if($(window).width() < 769) {
    $('.jumbotron').after($('#how_it_works_panels'));
    $('#how_it_works_panels .panel').css({
      marginBottom: '10px',
      border: '1px solid #FFF'
    })

  }

  $(window).resize(function() {
    if ($(this).width() < 769){
      $('.jumbotron').after($('#how_it_works_panels'));
    }
    else if ($(this).width() >= 769) {
      $('.jumbotron').append($('#how_it_works_panels'));
    }   
  })
}

function headerLoginToggle(){
  $('#user_email_login').hide()
  $('#user_password').hide()
  $('.login-form-submit').hide()
  $('#login-toggle').click(function(e){
    e.preventDefault()
    $('.fb_btn').css('margin-bottom','15px')
    $('#login-toggle').hide()
    $('#user_email_login').fadeIn()
    $('#user_password').fadeIn()
    $('.login-form-submit').fadeIn()
  })


  $('.host_img, .adv_copy').hover(function(){
    $(this).parent().css('opacity','1.0')
  },function(){
    $(this).parent().css('opacity','0.7')
  })

  $(document).ready(function(){
    $('.mobile_adventure_link').width($('.adv_copy').width() + 111)
  })
  
  $(window).resize(function(){
    $('.mobile_adventure_link').width($('.adv_copy').width() + 111)
  })
}

function mobileHeaderLoginToggle(){
  $('#mobile_user_email_login').hide()
  $('#mobile_user_password').hide()
  $('#mobile-login-form-submit').hide()
  $('#mobile-login-toggle').click(function(e){
    e.preventDefault()
    $('#login-mobile').hide()
    $('.fb_btn').css('margin-bottom','15px')
    $('#mobile-login-toggle').hide()
    $('#mobile_user_email_login').fadeIn()
    $('#mobile_user_password').fadeIn()
    $('#mobile-login-form-submit').fadeIn()
  })
}

function overall_rating_show() {
  var feat_adv_id;
  var rating;
  var num_of_adv = $('.adventure-container input').length / 2;

  var i = 0;

  for(; i < num_of_adv; i++) {
    adv_rating_show_id = ".adventure-container input#adv_rating_show_"+i;
    adv_rating_value_id = ".adventure-container input#adv_rating_value_"+i;

    //initialize
    $(adv_rating_show_id).rating({
      'min': 0,
      'max': 5,
      'step': 0.1,
      'size': 'xs',
      'readonly': true,
      'showCaption': false,
      'showClear': false
    });

    //update rating
    rating = $(adv_rating_value_id).data('rating');

    if(rating) {
      $('.copy#'+i+" .star-rating").removeClass('no_ratings');
      $(adv_rating_show_id).rating('update', rating);
    }
    else {
      //Make it opaque if there are no ratings
      $('.copy#'+i+" .star-rating").addClass('no_ratings');
      $('.no_ratings').css('opacity','0.35');
    }
  }
}

function aboutContactValidator(){
  $(document).ready(function(){

    $('#about_us_contact_form').bootstrapValidator({
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
              message: 'Password cannot be empty'
            }
          }
        }
      }
    })
  })
}

function contactToggle(){
  $('#contact-us p').click(function(){
    $('#contact-advlo').fadeIn();
    $('#leave-a-note').css('margin-bottom', '20px');
  })
}

function submitAboutUsContact(){
  $('#about-us-contact').click(function(){
    $('#about_us_contact_form').submit()
  })
}

function how_it_works_hovers(){
  $('#how_it_works a').mouseover(function(){
      $(this).find('.dot').css({
        backgroundColor: '#699967'
      });
      $(this).next().find('.dot_copy').css({
        color: '#699967'
      });
      $(this).find('.dot').find('.advlo_img').show();

      $(this).find('.dot_copy').css({
        color: '#699967'
      });
      $(this).prev().find('.dot').css({
        backgroundColor: '#699967'
      });
      $(this).prev().find('.dot').find('.advlo_img').show();
  })

  $('#how_it_works a').mouseout(function(){
      $(this).find('.dot').css({
        backgroundColor: '#E6E6E6'
      })
      $(this).next().find('.dot_copy').css({
        color: '#E6E6E6'
      });
      $(this).find('.dot').find('.advlo_img').hide();

      $(this).find('.dot_copy').css({
        color: '#E6E6E6'
      });
      $(this).prev().find('.dot').css({
        backgroundColor: '#E6E6E6'
      });

      $(this).prev().find('.dot').find('.advlo_img').hide();
  })

}
  
homepageInit = function() {
  adventureHover();
  centerGuideImage();
  homepageTextScroll();
  overall_rating_show();
  request_form_validator();
  request_form_geocomplete();
  request_form_maxlength();
  how_it_works_hovers();
}

aboutPageInit = function() {
  aboutContactValidator();
  contactToggle();
  submitAboutUsContact();
}