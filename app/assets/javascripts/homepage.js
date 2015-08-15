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

    $('#invest #about_us_contact_form #about-us-contact').addClass('disabled');

    $('#invest #about_us_contact_form #contact_comments').on('keyup', function() {
      var details = $.trim($(this).val());

        if (details.length > 5) {
          $('#invest #about_us_contact_form #about-us-contact').removeClass('disabled');
        }
        else if (details.length <= 4) {
          $('#invest #about_us_contact_form #about-us-contact').addClass('disabled');
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
  $('#how_it_works .hiw_img').hover(
    function(){
      $('#how_it_works .hiw_img').stop().animate({
        "opacity":"0.6"
      })
      $(this).stop().animate({
        "opacity":"1"
      })
    },
    function(){
      $('#how_it_works .hiw_img').stop().animate({
        "opacity":"1"
      })
    }
  )
}

function video_modal_play_stop() {
  var start_src = "https://player.vimeo.com/video/103610627?title=0&portrait=0&byline=0&badge=0&autoplay=1";
  var stop_src = ""

  // On show play video
  $('#video-modal').on('show.bs.modal', function(e) {
    $(this).find('iframe').attr('src',start_src);
  })

  // On hide stop video
  $('#video-modal').on('hide.bs.modal', function(e) {
    $(this).find('iframe').attr('src',stop_src);
  })
}

function banner_image_rotate(rot_advs){
  var timer = 12000; //seconds
  var i = 0;

  setInterval(function(){
    //effects of the img etc.
    $('.homepage-photo, .adventure-link-wrapper').animate({
      "opacity": 0.1
    }, 1000)
    
    setTimeout(function(){
      $('.homepage-photo').css({
        "background-image": "url('"+rot_advs[i].bg_img_url+"')"
      })

      $('.adventure-link-wrapper').attr("href",rot_advs[i].url)
      $('.adventure-link-wrapper .host_img').css({
        "background-image": "url('"+rot_advs[i].host_img_url+"')"
      })
      $('.adventure-link-wrapper .adv_copy').html(rot_advs[i].title+"<br/>with "+rot_advs[i].host_name)
      
      $('.homepage-photo, .adventure-link-wrapper').animate({
        "opacity": 0.8
      }, 1000)
    },1000)

    if (i == rot_advs.length - 1) {
      i = 0;
    }
    else {
      i++;
    }
  }, timer)
}

  
homepageInit = function() {
  adventureHover();
  centerGuideImage();
  overall_rating_show();
  request_form_validator();
  request_form_geocomplete();
  request_form_maxlength();
  how_it_works_hovers();
  video_modal_play_stop();
}

aboutPageInit = function() {
  aboutContactValidator();
  contactToggle();
  submitAboutUsContact();
}

investPageInit = function() {
  aboutContactValidator();
  contactToggle();
  submitAboutUsContact()
}