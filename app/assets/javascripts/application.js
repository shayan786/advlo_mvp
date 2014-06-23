// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
// require_tree .
//= require jquery
//= require jquery_ujs
// require jquery.ui.all
//= require turbolinks
//= require bootstrap
//= require bootstrap-datepicker
//= require bootstrap-filestyle
//= require bootstrap-maxlength
//= require idangerous.swiper.min
//= require masonry.pkgd.min.js
//= require adventure.js
//= require homepage.js
//= require slider.js
//= require user.js

var init;

init = function() {
  adventureInit();
  usersInit();
  resizeFunctions();
};


$(document).ready(function(){
 init();
 console.log('doc ready')
});

$(window).load(function(){
 init();
 console.log('window load')
});

$(document).on('page:load', function(){
 init();
 console.log('doc load')
});

$(document).on('page:change', function(){
  init();
  console.log('page change')
});

function resizeFunctions(){
  $(window).resize(function(){
    sizeSidebar();
    homepageInit();
  })
}
