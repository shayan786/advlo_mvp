function exploreDropdownToggle(){
  $('.dropdown-toggle').hover(function(){
    $('.dropdown-box').dequeue().stop().slideDown()
    $('.header_btn_fix').dequeue().stop().animate({
      borderBottomLeftRadius: 0, 
      borderBottomRightRadius: 0
    }, 400);
  },function(){
    $('.dropdown-box').dequeue().stop().slideUp()
    $('.header_btn_fix').dequeue().stop().animate({
      borderTopLeftRadius: 10, 
      borderTopRightRadius: 10, 
      borderBottomLeftRadius: 10, 
      borderBottomRightRadius: 10
    }, 400);
  })
}

function homepageTextScroll(){
  $('#homepage-text').hide()

  $(window).load(function(){
    $('#homepage-text').fadeIn(1500)
  })
  $(window).scroll(function(){
    var s = $(window).scrollTop();

    if($(window).width() > 800){
      $('#homepage-text').css('-webkit-transform','translateY(' + (s/5) + 'px');
    }

    // if(s > 200 && !$('#homepage-text').hasClass('passed')){
    //   $('#homepage-text').animate({
    //     opacity: 0
    //   },300)

    //   $('#homepage-text').addClass('passed')
    // }
    // if(s < 200 && $('#homepage-text').hasClass('passed')){
    //   $('#homepage-text').animate({
    //     opacity: 1
    //   },1000)

    //   $('#homepage-text').removeClass('passed')
    // }  
  })
}

function headerLoginToggle(){
  $('#user_email_login').hide()
  $('#user_password').hide()
  $('#login-form-submit').hide()


  $('#login-toggle').click(function(e){
    e.preventDefault()
    $('.fb_btn').css('margin-bottom','15px')
    $('#login-toggle').hide()
    $('#user_email_login').fadeIn()
    $('#user_password').fadeIn()
    $('#login-form-submit').fadeIn()
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
  exploreDropdownToggle();
  homepageTextScroll();
  overall_rating_show();
  request_form_validator();
  request_form_geocomplete();
  request_form_maxlength();
}