function heroScroll(){
  var hero = $('#hero_image img');
  var heroFont = $('#location_text');
  $(window).scroll(function(){
    var s = $(window).scrollTop()
    hero.css('-webkit-transform','translateY(' + (s/1.5) + 'px')
    heroFont.css('-webkit-transform','translateY(' + (s/2) + 'px')
  })
}

function adventureHover(){
  $('.hover-block').hover(function(){
    $('.copy-'+$(this).attr('id')).stop().animate({
      opacity: 0
    },500)

    $(this).stop().animate({
      opacity: 1
    })

  },function(){
    $('.copy-'+$(this).attr('id')).stop().animate({
      opacity: 1
    },300)
    $(this).stop().animate({
      opacity: 0
    })
  })
}


