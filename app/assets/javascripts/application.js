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
//= require jquery.ui.draggable
//= require jquery.ui.resizable
//= require bootstrap
//= require bootstrap-datepicker
//= require bootstrap-filestyle
//= require bootstrap-maxlength
//= require bootstrapValidator.min
//= require idangerous.swiper.min
//= require masonry.pkgd.min.js
//= require imagesloaded.pkgd.min.js
//= require adventure.js
//= require homepage.js
//= require reservation.js
//= require user.js
//= require fullcalendar
//= require jquery.geocomplete.min



$(document).ajaxStart(function(){
  $('#loader-overlay').show()
});
$(document).ajaxStop(function(){
  $('#loader-overlay').fadeOut()
});

//Header resize on scroll
$(document).ready(function(){
	var flag = 0;
    $(window).scroll(function () {
      if ($(this).scrollTop() > 50 && flag == 0) {
        $('nav.navbar').animate({
        	padding: "0px 0px 0px 10px",
          height: "43px"
        });
        $('nav.navbar .navbar-brand').animate({
        	marginTop: "4px",
        	"background-size": "78%"
        });
        $('.logged_in_dropdown_box img').animate({
          width: "40px",
          height: "40px",
          marginTop: "2px"
        });

        flag = 1;
      }
      if ($(this).scrollTop() < 50 && flag == 1) {
      	$('nav.navbar').animate({
        	padding: "4px 0px 4px 10px",
          height: "58px"
        });
        $('nav.navbar .navbar-brand').animate({
        	marginTop: "0px",
        	"background-size": "99%"
        });
        $('.logged_in_dropdown_box img').animate({
          width: "50px",
          height: "50px",
          marginTop: "0px"
        });

        flag = 0;
      } 
    });
});
