$(document).ready(function(){
  var hero = $('#hero_image img');


  function heroScroll(){
    $(window).scroll(function(){
      var s = $(window).scrollTop()
      console.log(s)
      hero.css('-webkit-transform','translateY(' + (s/1.5) + 'px')
    })
  }


  // $('.title').each(function(){
  //   if($(this).height() > 28){
  //     $(this).css('font-size', '15px')
  //   }
  // })
  // $('.location').each(function(){
  //   if($(this).height() > 28){
  //     $(this).css('font-size', '10px')
  //   }
  // })

  heroScroll();
})