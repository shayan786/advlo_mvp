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

function adventureSliderInit(){
  var slideCount;
  if($(window).width() > 1224){
    slideCount = 3;
  }else if($(window).width() > 800){
    slideCount = 2;
  }else{
    slideCount = 1;
  }
  
  var totalSlideCount = $('.adventure-slider-wrapper .swiper-slide').length - 3;
  $(".prev").addClass('hide');

  var adventureSlider = $('.swiper-container').swiper({
    mode:'horizontal',
    slidesPerView: slideCount,
    keyboardControl: true,
    onSlideChangeStart: function(){
      $(".prev, .next").removeClass('hide');
      if(adventureSlider.activeIndex == 0) {
        $(".prev").addClass('hide');
      }
      if(adventureSlider.activeIndex == totalSlideCount) {
        $(".next").addClass('hide');
      }
    }
  });
  $('#adv-next').click(function(){
    adventureSlider.swipeNext()
  })
  $('#adv-prev').click(function(){
    adventureSlider.swipePrev()
  })
}


function hostSliderInit(){
  var hostCount;
  if($(window).width() > 1386){
    hostCount = 3;
  }else if($(window).width() > 920){
    hostCount = 2;
  }else{
    hostCount = 1;
  }

  var totalSlideCount = $('#host-slider .swiper-slide').length - 3;
  $("#host-prev").addClass('hide');

  var hostSwiper = $('.host-slider').swiper({
    mode:'horizontal',
    slidesPerView: hostCount,
    onSlideChangeStart: function(){
      $("#host-prev, #host-next").removeClass('hide');
      if(hostSwiper.activeIndex == 0) {
        $("#host-prev").addClass('hide');
      }
      if(hostSwiper.activeIndex == totalSlideCount) {
        $("#host-next").addClass('hide');
      }
    }
  });
  $('#host-next').click(function(){
    hostSwiper.swipeNext()
  })
  $('#host-prev').click(function(){
    hostSwiper.swipePrev()
  })
}

function hostSliderImageCenter(){
  $(window).load(function(){
    $('.image-wrapper').each(function(){
      var imageWidth = $(this).find('img').width()
      if( imageWidth > 700){
        $(this).find('img').css('margin-left','-40%')
      }else if(imageWidth > 600){
        $(this).find('img').css('margin-left','-20%')
      }else if(imageWidth > 500){
        $(this).find('img').css('margin-left','-10%')
      }
    })
  })
}
  
homepageInit = function() {
  adventureSliderInit();
  hostSliderInit()
  adventureHover();
  centerGuideImage();
  hostSliderImageCenter();
  exploreDropdownToggle();
  homepageTextScroll();
}