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
  if(location.pathname == '/adventures'){
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
  }else{
    $(window).unbind('scroll')
  }
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


function navBarCatch(){
  $('#main_image img').load(function(){
    $(window).scroll(function(){
      var s = $(window).scrollTop()
      if(s > widthOfBrowserHeight()){
        fixSidebar()        
      }else{
        resetSideBar()        
      }
    })
  })
}

function widthOfBrowserHeight(){
  var windowWidth = $(window).width()
  if( windowWidth > 1090 ){
    return 290;
  }else if( windowWidth > 1060){
    return 280;
  }else if( windowWidth > 1040){
    return 270;
  }else if( windowWidth > 1020){
    return 263;
  }else if( windowWidth > 1000){
    return 240;
  }else if( windowWidth > 900){
    return 225;
  }
}

function fixSidebar(){
  $('#desktop-adventure-nav').css({
    position: 'fixed',
    right: '0px',
    top: '481px'
  })
}

function resetSideBar(){
  $('#desktop-adventure-nav').css({
    position: 'relative',
    top: '0px'
  })
}


  // .adventure-show-container .adventure-copy-wrapper .navigation-brick {
  // position: fixed;
  // float: left;
  // margin-top: 20px;
  // height: 100%;
  // height: 200px;
  // border: 1px solid #C35B26;
  // top: 480px;
  // right: 15px;
  // width: 23%;

adventureInit = function() {
  sizeSidebar()
  adventureHover();
  heroScroll();
  filterCatch();
  masonrySetup();
  navBarCatch(); 
};

$(window).resize(function(){
  sizeSidebar();
})

$(document).ready(adventureInit);
$(document).on('page:load', adventureInit);




