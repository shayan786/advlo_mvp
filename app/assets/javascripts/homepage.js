function adventureSliderInit(){
  var slideCount;
  if($(window).width() > 1224){
    slideCount = 3;
  }else if($(window).width() > 800){
    slideCount = 2;
  }else{
    slideCount = 1;
  }
  
var adventureSlider = $('.swiper-container').swiper({
    mode:'horizontal',
    slidesPerView: slideCount,
    keyboardControl: true,
  });
  $('#adv-next').click(function(){
    adventureSlider.swipeNext()
    console.log(adventureSlider.activeSlide())
  })
  $('#adv-prev').click(function(){
    adventureSlider.swipePrev()
    console.log(adventureSlider.activeSlide())
  })
}

function hostSliderInit(){
  var hostCount;
  if($(window).width() > 1500){
    hostCount = 3;
  }else if($(window).width() > 1002){
    hostCount = 2;
  }else{
    hostCount = 1;
  }
  var hostSwiper = $('.host-slider').swiper({
    mode:'horizontal',
    slidesPerView: hostCount,
  });
  $('#host-next').click(function(){
    hostSwiper.swipeNext()
    console.log(hostSwiper.activeSlide())
  })
  $('#host-prev').click(function(){
    hostSwiper.swipePrev()
    console.log(hostSwiper.activeSlide())
  })
}

function hideArrows(){
  var totalSlideCount = $('.swiper-slide').length()

}

  
homepageInit = function() {
  adventureSliderInit();
  hostSliderInit()
  adventureHover();
}