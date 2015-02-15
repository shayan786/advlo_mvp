function guideScroll(){
  $(document).ready(function(){
    var amount = $('.guide-button').offset().top + 80
    $('body').animate({
      scrollTop: amount
    }, 1000);
  })
}

function infoSlider(type){

  $(document).ready(function() {
    var sliderName = type + 'Slider';
    var sliderName = new Swiper('.' + type  + '-slider',{
      mode:'horizontal',
      autoplay: 4000, 
      onSlideChangeStart: function(swiper){
        $(".main").removeClass('active')
        $("." + type + '-' + parseInt(sliderName.activeLoopIndex + 1)).addClass('active')
      }
    });

    $('.main').click(function(e){
      $('.main').removeClass('active')
      $(this).addClass('active')
      sliderName.swipeTo($(this).attr('class').split(' ')[0].slice(-1) - 1)
    })
  })
}

