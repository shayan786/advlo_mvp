$(document).ready(function(){
  var hero = $('#hero_image img');

  $(window).scroll(function(){
    var s = $(window).scrollTop()
    console.log(s)
    hero.css('-webkit-transform','translateY(' + (s/1.5) + 'px')
  })


})