function profileSlider() {
  var totalSlideCount = $('#user-adventure-slider .swiper-slide').length - 3;
  $(".prev").addClass('hide');

  if(totalSlideCount <= 0){
    $('.prev').hide()
    $('.next').hide()
  }

  var profileSlider = new Swiper('.swiper-container',{
    mode:'horizontal',
    slidesPerView: 3,
    onSlideChangeStart: function(){
      console.log(profileSlider.activeIndex)
      $(".prev, .next").removeClass('hide');
      if(profileSlider.activeIndex == 0) {
        $(".prev").addClass('hide');
      }
      if(profileSlider.activeIndex == totalSlideCount) {
        $(".next").addClass('hide');
      }
    }
  });  

  $('#profile-next').click(function(){
    profileSlider.swipeNext()
  })
  $('#profile-prev').click(function(){
    profileSlider.swipePrev()
  })
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