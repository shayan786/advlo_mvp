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

function filterCatch(){
  $(window).scroll(function(){
    var s = ($(window).scrollTop() + parseInt($('.filter-container').css('height')))
    var fixedHeight = $('.filter-container').position().top
    if(s > fixedHeight ){
      $('.filter-static').fadeIn();
      $('.filter-container').css('opacity',0)
    }else if( s < fixedHeight ){
      $('.filter-static').fadeOut('fast')
      $('.filter-container').css('opacity',1)
    }
  })
}

function masonrySetup(){
  $('.js-masonry').masonry({
    isFitWidth: true,
    itemSelector: '.adventure-brick'
  });
}


function sizeSidebar(){
  $('.adventure-show-infographic').width($('.navigation-brick').last().width() - 28)
}

adventureInit = function() {
  sizeSidebar()
  adventureHover();
  heroScroll();
  filterCatch();
  masonrySetup();
};

$(window).resize(function(){
  sizeSidebar();
})

$(document).ready(adventureInit);
$(document).on('page:load', adventureInit);
