function guideScroll(){
  $(document).ready(function(){
    $('html').css('overflow','scroll');
    $('.jumbotron').height('400px');

    var amount = $('.adventure_info_body').offset().top - 50

    if ($(window).width() < 765){
      amount = amount + 50
    } else {
      $('.navbar').fadeIn();
    }
    $('body').on("scroll mousedown DOMMouseScroll mousewheel keyup", function(){
       $('body').stop();
    });

    $('body').animate({
      scrollTop: amount
    }, 1000);
    
    return false;
  })
}

function toggleItin(){
  $('.itinerary-brick').click(function(){
    $(this).children().last().toggle();
    $(this).children().first().toggle();
    $(this).children().first().next().toggle();
  })
  
  $('.itinerary-brick').first().click()
  $('.itinerary-brick').last().css('border-bottom','none')

}

function infoSlider(type){
  $(document).ready(function() {
    var sliderName = type + 'Slider';
    var sliderName = new Swiper('.' + type + '-slider',{
      mode:'horizontal',
      autoplayDisableOnInteraction: true,
      autoplay: 6000, 
      onSlideChangeStart: function(swiper){
        $(".main").removeClass('active')
        $("." + type + '-' + parseInt(sliderName.activeLoopIndex + 1)).addClass('active')
      }
    });

    $('.main').click(function(e){
      $('.main').removeClass('active')
      $(this).addClass('active')
      sliderName.swipeTo($(this).attr('class').split(' ')[0].slice(-1) - 1)
      sliderName.stopAutoplay();
    })
  })
}



function mobileSlider(type){
  $(document).ready(function() {
    var sliderName = type + 'Slider';
    var sliderName = new Swiper('.' + type + '-swiper',{
      mode:'horizontal',
      autoplayDisableOnInteraction: true,
      autoplay: 5000, 
      onSlideChangeStart: function(swiper){
        $(".mobile-main").removeClass('active')
        $(".mobile-" + type + '-' + parseInt(sliderName.activeLoopIndex + 1)).addClass('active')
      }
    });

    $('.mobile-main').click(function(e){
      $('.mobile-main').removeClass('active')
      $(this).addClass('active')
      sliderName.swipeTo($(this).attr('class').split(' ')[0].slice(-1) - 1)
      sliderName.stopAutoplay();
    })
  })
}


