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
}

function mobileHeaderLoginToggle(){
  $('#mobile_user_email_login').hide()
  $('#mobile_user_password').hide()
  $('#mobile-login-form-submit').hide()
  $('#mobile-login-toggle').click(function(e){
    e.preventDefault()
    $('#login-mobile').hide()
    $('#feedback-button').toggle()
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
  
homepageInit = function() {
  adventureHover();
  centerGuideImage();
  homepageTextScroll();
  overall_rating_show();
  request_form_validator();
  request_form_geocomplete();
  request_form_maxlength();
}