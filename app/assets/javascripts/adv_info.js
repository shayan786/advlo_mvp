function tabInit(){
  $('#individual-info').click(function () {
    $(this).tab('show');
  })

  $('#business-info').click(function(){
    $(this).tab('show');
  })
}

function infoSlider(type){

  $(document).ready(function() {
    var sliderName = type + 'Slider';
    console.log(sliderName)

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
      sliderName.stopAutoplay();

      console.log($(this).attr('class').split(' ')[0].slice(-1) - 1)
    })
  })
}

  


function advInfoInit(){
  tabInit();
}

