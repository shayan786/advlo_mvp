$(document).ready(function(){
  $('.swiper-slide').hover(function(){
    $(this).find('.image-hover').animate({
      opacity: 1
    })
  },function(){
    $(this).find('.image-hover').animate({
      opacity: 0
    })
  })
})