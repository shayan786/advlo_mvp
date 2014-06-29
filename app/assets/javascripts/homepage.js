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
  }else if($(window).width() > 1002){
    hostCount = 2;
  }else{
    hostCount = 1;
  }

  var totalSlideCount = $('#host-slider .swiper-slide').length - 3;
  $(".prev").addClass('hide');

  var hostSwiper = $('.host-slider').swiper({
    mode:'horizontal',
    slidesPerView: hostCount,
    onSlideChangeStart: function(){
      $(".prev, .next").removeClass('hide');
      if(hostSwiper.activeIndex == 0) {
        $(".prev").addClass('hide');
      }
      if(hostSwiper.activeIndex == totalSlideCount) {
        $(".next").addClass('hide');
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
}