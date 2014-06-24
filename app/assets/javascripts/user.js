function userWallpaperScroll(){
  //setup a users picked background image
      
  //   var hero = $('#hero_image img');
  //   $(window).scroll(function(){
  //     var s = $(window).scrollTop()
  //     hero.css('-webkit-transform','translateY(' + (s/1.5) + 'px')
  //   })
}

function input_popover() {
	$('[data-toggle="popover"]').popover({
    trigger: 'focus'
  });
}

function input_datepicker() {
  $('#user_dob').datepicker({
    format: "mm/dd/yyyy",
    startDate: "01/01/1940",
    startView: 2,
    orientation: "auto right",
    autoclose: true
  });
}

function input_maxlength() {
  $('input.show_ml').maxlength({
    alwaysShow: true,
    warningClass: "label label-success",
    limitReachedClass: "label label-danger",
    validate: true,
    placement: 'bottom'
  });

  $('textarea').maxlength({
    alwaysShow: true,
    warningClass: "label label-success",
    limitReachedClass: "label label-danger",
    validate: true,
    placement: 'bottom'
  });
}

function photoInput(){
  $(":file").filestyle({input: false, icon: false, buttonText: "SET PHOTO"});
}

function create_tabs() {
  $('#adv_pills a').click(function (e) {
    e.preventDefault();
    $(this).tab('show');
  });

}

function usersInit(){
  input_popover();
  input_datepicker();
  input_maxlength();
  photoInput();
}

function usersShowInit(){
  // userWallpaperScroll();
}