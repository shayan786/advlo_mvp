function heroScroll(){
  var hero = $('#hero_image img');
  $(window).scroll(function(){
    var s = $(window).scrollTop()
    console.log(s)
    hero.css('-webkit-transform','translateY(' + (s/1.5) + 'px')
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


