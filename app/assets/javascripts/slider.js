$(function(){
  var mySwiper = $('.swiper-container').swiper({
    //Your options here:
    mode:'horizontal',
    loop: true,
    slidesPerView: 3,
    keyboardControl: true,
    //etc..
  });
  $('#next-slide').click(function(){
    mySwiper.swipeNext()
  })
  $('#prev-slide').click(function(){
    mySwiper.swipePrev()
  })
})
