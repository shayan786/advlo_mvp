function positionLocationText(){
  $('#location_text').css('top', ($('#hero_image').height() / 2))
}

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
    },140)
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
  $('.adventure-show-infographic').width($('.navigation-brick').last().width() - 32)
}


function navBarCatch(){
  $('#main_image img').load(function(){
    $(window).scroll(function(){
      var s = $(window).scrollTop()
      if(s > widthOfBrowser()){
        fixSidebar()        
      }else{
        resetSideBar()        
      }
    })
  })
}

function widthOfBrowser(){
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

function navigationBreadcrumbs(){
  $(document).ready(function() {
    $('a[href*=#]:not([href=#])').click(function() {
      if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'') && location.hostname == this.hostname) {
        var target = $(this.hash);
        target = target.length ? target : $('[name=' + this.hash.slice(1) +']');
        if (target.length) {
          $('html,body').animate({
            scrollTop: target.offset().top-77
          }, 1000);
          return false;
        }
      }
    });
  });

  if($(window).height() < 705){
    $('.navigation-brick').last().hide()
  }
}

function AdvPhotoInput(){
  $("#adv_cover_img").filestyle({input: false, icon: false, buttonText: "SET COVER IMAGE"});
  $("#adv_gallery_img").filestyle({input: false, icon: false, buttonText: "SELECT GALLERY IMAGES"});
}

adventureShow = function() {
  sizeSidebar()
  navBarCatch(); 
  navigationBreadcrumbs();
};

adventureIndex = function() {
  positionLocationText();
  masonrySetup();
  filterCatch();
  heroScroll();
  adventureHover();
}

adventureCreate = function() {
  AdvPhotoInput();
  input_popover();
  input_datepicker();
  input_maxlength();
  create_tabs();
}
