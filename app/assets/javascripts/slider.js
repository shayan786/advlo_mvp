function sliderInit(){
  var slideCount;
  if($(window).width() > 1200){
    slideCount = 3;
  }else if($(window).width() > 800){
    slideCount = 2;
  }else{
    slideCount = 1;
  }
  var mySwiper = $('.swiper-container').swiper({
    //Your options here:
    mode:'horizontal',
    slidesPerView: slideCount,
    keyboardControl: true,
    //etc..
  });
  $('#next-slide').click(function(){
    mySwiper.swipeNext()
  })
  $('#prev-slide').click(function(){
    mySwiper.swipePrev()
  })
}

