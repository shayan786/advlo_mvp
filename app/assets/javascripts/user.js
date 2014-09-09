function profileSlider(){
  var slideCount;
  
  $('#mobile-user-adventures').hide()
  $('#user-adventure-slider').show()

  if($(window).width() > 1000){
    slideCount = 3;
  }else if($(window).width() > 800){
    slideCount = 2;
  }else{
    $('#user-adventure-slider').hide()
    $('#mobile-user-adventures').show()
  }
  
  var totalSlideCount = $('.swiper-slide').length - 3;
  $(".prev").addClass('hide');

  if($('.swiper-slide').length <= 3){
    $(".prev, .next").hide();
  }

  var adventureSlider = $('.swiper-container').swiper({
    mode:'horizontal',
    slidesPerView: slideCount,
    keyboardControl: true,
    onSlideChangeStart: function(){
      $(".prev, .next").removeClass('hide');

      if(adventureSlider.activeIndex == 0) {
        $(".prev").addClass('hide');
      }

      if(slideCount == 3){
        newCount = totalSlideCount
      }else if(slideCount == 2){
        newCount = (totalSlideCount + 1)
      }

      if(adventureSlider.activeIndex == newCount ) {
        $(".next").addClass('hide');
      }
    }
  });

  $('#profile-next').click(function(){
    adventureSlider.swipeNext()
  })
  $('#profile-prev').click(function(){
    adventureSlider.swipePrev()
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

  $('textarea.show_ml').maxlength({
    alwaysShow: true,
    warningClass: "label label-success",
    limitReachedClass: "label label-danger",
    validate: true,
    placement: 'bottom'
  });
}

function photoInput(){
  $("#user_avatar").filestyle({input: false, icon: false, buttonText: "SET PROFILE IMAGE"});
  $("#banner_image").filestyle({input: false, icon: false, buttonText: "SET BANNER IMAGE"});
}

function create_tabs() {
  $('#adv_pills a').click(function (e) {
    e.preventDefault();
    $(this).tab('show');
  });
}

function adventureShowHover(){
  $('.adventure-brick').hover(function(){
    $(this).find($('.hover-block')).fadeIn()
  }, function(){
    $(this).find($('.hover-block')).fadeOut()
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

function upload_profile_photo() {
  $('#user_img_edit_form #user_avatar').change(function(){
    $('#user_img_edit_form').submit();
  })

  $('#user_profile_edit_form #banner_image').change(function(){
    $('#user_profile_edit_form').submit();
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
      },
      'user[fb_url]': {
        validators: {
          regexp: {
            regexp: /^(http|https):\/\/?(?:www.)?facebook.com\/(?:(?:\w)*#!\/)?(?:pages\/)?(?:[?\w\-]*\/)?(?:profile.php\?id=(?=\d.*))?([\w\-]*)?/i,
            message: "Must be a valid facebook profile"
          }
        }
      },
      'user[tw_url]': {
        validators: {
          regexp: {
            regexp: /^(http|https):\/\/?(?:www.)?twitter\.com\/(#!\/)?([^\/ ].)+/,
            message: "Must be a Valid Twitter profile"
          }
        }
      },
      'user[ta_url]': {
        validators: {
          regexp: {
            regexp: /^(http|https):\/\/?(?:www.)?tripadvisor./,
            message: "Must be a Valid TripAdvisor page"
          }
        }
      },
      'user[video_url]': {
        validators: {
          regexp: {
            regexp: /(\/\/(?:www\.)?youtu(?:\.be|be\.com)\/(?:watch\?v=|embed\/)?([a-z0-9_\-]+))|(\/\/(?:www\.)?vimeo.com\/([0-9a-z\-_]+))/,
            message: "Must be a Valid youtube or vimeo video url"
          }
        }
      }
    }
  });
}

function host_contact_validator() {
  $('#contact_host_form').bootstrapValidator({
    fields: {
      'contact_host[email]': {
        validators: {
          notEmpty: {
            message: "Email cannot be empty"
          },
          emailAddress: {
            message: "Not a valid email address"
          }
        }
      },
      'contact_host[message]': {
        validators: {
          notEmpty: {
            message: "Message cannot be empty"
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

function user_rating_show() {
  var user_rating_value_id = "#p_banner input#user_rating_value";
  var user_rating_show_id = "#p_banner input#user_rating_show";

  //initialize
  $(user_rating_show_id).rating({
    'min': 0,
    'max': 5,
    'step': 0.1,
    'size': 'xs',
    'readonly': true,
    'showCaption': true,
    'showClear': false,
    'starCaptions': {
      0.0: '0.0',
      0.1: '0.1',
      0.2: '0.2',
      0.3: '0.3',
      0.4: '0.4',
      0.5: '0.5',
      0.6: '0.6',
      0.7: '0.7',
      0.8: '0.8',
      0.9: '0.9',
      1: '1.0',
      1.1: '1.1',
      1.2: '1.2',
      1.3: '1.3',
      1.4: '1.4',
      1.5: '1.5',
      1.6: '1.6',
      1.7: '1.7',
      1.8: '1.8',
      1.9: '1.9',
      2: '2.0',
      2.1: '2.1',
      2.2: '2.2',
      2.3: '2.3',
      2.4: '2.4',
      2.5: '2.5',
      2.6: '2.6',
      2.7: '2.7',
      2.8: '2.8',
      2.9: '2.9',
      3: '3.0',
      3.1: '3.1',
      3.2: '3.2',
      3.3: '3.3',
      3.4: '3.4',
      3.5: '3.5',
      3.6: '3.6',
      3.7: '3.7',
      3.8: '3.8',
      3.9: '3.9',      
      4: '4.0',
      4.1: '4.1',
      4.2: '4.2',
      4.3: '4.3',
      4.4: '4.4',
      4.5: '4.5',
      4.6: '4.6',
      4.7: '4.7',
      4.8: '4.8',
      4.9: '4.9',
      5: '5.0'
    }
  });

  //update rating
  rating = $(user_rating_value_id).data('host-rating');
  $(user_rating_show_id).rating('update', rating);
}

function user_adv_rating_show() {
  var adv_id;
  var rating;
  var adv_rating_show_id;
  var adv_rating_value_id;
  var num_of_adv = $('#p_my_adventures input').length / 2;

  var i = 0;

  for(; i < num_of_adv; i++) {
    adv_rating_show_id = "#p_my_adventures input#adv_rating_show_"+i;
    adv_rating_value_id = "#p_my_adventures input#adv_rating_value_"+i;

    //initialize
    $(adv_rating_show_id).rating({
      'min': 0,
      'max': 5,
      'step': 0.1,
      'size': 'xs',
      'readonly': true,
      'showCaption': false,
      'showClear': false
    });

    //update rating
    rating = $(adv_rating_value_id).data('rating');
    $(adv_rating_show_id).rating('update', rating);
  }
}

function contact_form_validator() {
  $('#contact_host_modal .modal-dialog .contact_btn').addClass('disabled');

  //request adventure form validation on button
  $('#contact_host_modal .modal-dialog #contact_message').on('keyup', function() {
    var details = $.trim($(this).val());

      if (details.length > 6) {
        $('#contact_host_modal .modal-dialog .contact_btn').removeClass('disabled');
      }
      else if (details.length <= 6) {
        $('#contact_host_modal .modal-dialog .contact_btn').addClass('disabled');
      }
  })
}

/*
function profile_img_area_edit() {

  function preview(img, selection) {
    if (!selection.width || !selection.height)
        return;
    
    var scaleX = 150 / selection.width;
    var scaleY = 150 / selection.height;

    $('#d_user_edit .profile_avatar_crop_update_btn').fadeIn();

    $('#d_user_edit .profile_avatar_img_preview img').css({
        width: Math.round(scaleX * 265),
        height: Math.round(scaleY * 200),
        marginLeft: -Math.round(scaleX * selection.x1),
        marginTop: -Math.round(scaleY * selection.y1)
    });

    // $('#x1').val(selection.x1);
    // $('#y1').val(selection.y1);
    // $('#x2').val(selection.x2);
    // $('#y2').val(selection.y2);
    // $('#w').val(selection.width);
    // $('#h').val(selection.height);  
  }

  var ias = $('#d_user_edit .profile_avatar_img img').imgAreaSelect({
    aspectRatio: '1:1',
    handles: true,
    fadeSpeed: 200,
    onSelectChange: preview,
    instance: true
  })

  $('#d_user_edit .profile_avatar_crop_update_btn .btn').click(function(){
    var selection = ias.getSelection();

    var user_id = $('#user_img_edit_form #user_id').val();
    
    //MAKE AJAX CALL TO CONTROLLER TO UPDATE CROP IMAGE
    $.ajax({
      url: "/users/crop_profile_img",
      data: {
        user_id: user_id, 
        crop_x: selection.
      },
      type: "POST"
    });
  })

}
*/


function usersInit(){
  input_popover();
  input_datepicker();
  input_maxlength();
  photoInput();
  edit_user_form_validator();
  edit_user_input_geocomplete();
  upload_profile_photo();
}

function usersShowInit(){
  adventureShowHover();
  profileSlider();
  centerGuideImage();
  profileCenterImage();
  user_rating_show();
  user_adv_rating_show();
  host_contact_validator();
  contact_form_validator();
}
