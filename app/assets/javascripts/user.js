function profileSlider() {
  var totalSlideCount = $('#user-adventure-slider .swiper-slide').length - 3;
  $(".prev").addClass('hide');

  if(totalSlideCount <= 0){
    $('.prev').hide()
    $('.next').hide()
  }

  var slideCount;
  if($(window).width() > 1220){
    slideCount = 3;
  }else if($(window).width() > 800){
    slideCount = 2;
  } else {
    slideCount = 1;
  }

  var profileSlider = new Swiper('.swiper-container',{
    mode:'horizontal',
    slidesPerView: slideCount,
    onSlideChangeStart: function(){
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
  var today = new Date();
  var cur_day = today.getDate();
  var cur_mon = today.getMonth()+1;
  var cur_yr = today.getFullYear();

  var yr_m_18 = cur_yr - 18;

  $('#user_dob').datepicker({
    format: "yyyy/mm/dd",
    startDate: "1940/01/01",
    endDate: yr_m_18+"/01/01",
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
  $(":file").filestyle({input: false, icon: false, buttonText: "SET PROFILE IMAGE"});
}

function create_tabs() {
  $('#adv_pills a').click(function (e) {
    e.preventDefault();
    $(this).tab('show');
  });
}

function adventureShowHover(){
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

function profileCenterImage(){
  $(window).load(function(){
    $('.profile-image').each(function(){
      var imageWidth = $(this).find('img').width()
      if( imageWidth > 300){
        $(this).find('img').css('margin-left','-40%')
      }else if(imageWidth > 250){
        $(this).find('img').css('margin-left','-20%')
      }else if(imageWidth > 200){
        $(this).find('img').css('margin-left','-10%')
      }
    })
  })
}

function edit_user_form_validator(){
  $('#user_edit_form').bootstrapValidator({
    fields: {
      'user[name]': {
        validators: {
          regexp: {
            regexp: /^[a-z ,.'-]+$/i,
            message: "Cannot include special characters, e.g. (! ~ @)",
          },
          notEmpty: {
            message: "Name cannot be empty"
          }
        }
      },
      'user[email]': {
        validators: {
          notEmpty: {
            mesage: "Email cannot be empty"
          },
          stringLength: {
            message: "Name must include atleast 3 characters",
            min: 3,
            max: 40
          }
        }
      }
    }
  });
}

function edit_user_input_geocomplete() {
  $('#user_edit_form .location_map').hide();
  var user_location = $('#user_edit_form #user_location').val();

  if (user_location) {
    $('#user_edit_form #user_location').geocomplete({
      map: "#user_edit_form .location_map",
      location: user_location
    });
    $('#user_edit_form .location_map').show();
  }
  else {
    $('#user_edit_form #user_location').geocomplete({
      map: "#user_edit_form .location_map"
    });
  }
}


function usersInit(){
  input_popover();
  input_datepicker();
  input_maxlength();
  photoInput();
  edit_user_form_validator();
  edit_user_input_geocomplete();
}

function usersShowInit(){
  adventureShowHover();
  profileSlider();
  centerGuideImage();
  profileCenterImage();
}
