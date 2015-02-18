function guideScroll(){
  $(document).ready(function(){
    $('html').css('overflow','scroll');
    $('.jumbotron').height('400px');
    $('.navbar').fadeIn()

    var amount = $('.adventure_info_body').offset().top - 50

    if ($(window).width() < 765){
      amount = amount - 5
      $(".why_host").css('visibility','hidden');
    }
    $('body').animate({
      scrollTop: amount
    }, 1000);
  })
}

function infoSlider(type){
  $(document).ready(function() {
    var sliderName = type + 'Slider';
    var sliderName = new Swiper('.' + type + '-slider',{
      mode:'horizontal',
      autoplay: 4200, 
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



function mobileSlider(type){
  $(document).ready(function() {
    var sliderName = type + 'Slider';
    var sliderName = new Swiper('.' + type + '-swiper',{
      mode:'horizontal',
      autoplay: 4200, 
      onSlideChangeStart: function(swiper){
        $(".mobile-main").removeClass('active')
        $(".mobile" + type + '-' + parseInt(sliderName.activeLoopIndex + 1)).addClass('active')
      }
    });

    $('.mobile-main').click(function(e){
      $('.mobile-main').removeClass('active')
      $(this).addClass('active')
      sliderName.swipeTo($(this).attr('class').split(' ')[0].slice(-1) - 1)
    })

  })
}


