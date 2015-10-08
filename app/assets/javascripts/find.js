function find_input_geocomplete() {
  $('#find .search_options #location').geocomplete().bind("geocode:result", function(event, result){
  	$('#find .search_options #find_adventure_form').submit();
  })
}

function homepage_find_input_geocomplete(){
  //homepage search bar leading to locals search
  $('#find_adventure_form #location').geocomplete().bind("geocode:result", function(event,result){
    var loc = this.value;

    window.location = "/find?location="+loc+"&locals=true"
  })

  $('#find_adventure_form .input-group-addon').click(function(){
    var details = $.trim($('#find_adventure_form #location').val());

    if (details.length > 2) {
      var loc = $('#find_adventure_form #location').val();

      window.location = "/find?location="+loc+"&locals=true"
    }
    else {
      swal({
        title: "Please enter in a location!",
        imageUrl: "http://i.imgur.com/a6L0hYB.png"
      });
      $('#find_adventure_form #location').focus();
    }
  })
}

function checkbox_highlighting() {
  $('#find .search_options #find_adventure_activity_form .checkbox-inline').click(function(){
    if($(this).find('input').is(':checked')) {
      $(this).css({
        opacity: '1',
        border: '1px solid #FFF',
        borderRadius: '3px',
        padding: '5px 10px 3px 30px',
        backgroundColor: 'rgba(195,91,38,0.7)',
        borderColor: 'rgb(195,91,38)',
        marginTop: '10px'
      })
    }
    else {
      $(this).css({
        opacity: '0.7',
        border: 'none',
        borderRadius: '0px',
        padding: '0',
        paddingTop: '10px',
        paddingLeft: '15px',
        backgroundColor: 'transparent',
        border: 'none',
        marginTop: '0'
      })
    }
  })
}

function toggle_show_me_types() {
	$('#find .search_options .show_me_adventures').click(function(){
    $('#find .search_options .show_me_locals').removeClass('active')
    $('#find .search_options .show_me_activities').removeClass('active')
    $(this).addClass('active');

    $('#find .search_options #find_adventure_form #locals').val(false);
    $('#find .search_options #find_adventure_activity_form #locals').val(false);

    if ($('#find .search_options #find_adventure_form #location').val().length > 0) {
      $('#find .search_options #find_adventure_form').submit();
    }

    $('#find .search_options #find_adventure_activity_form').fadeOut();
    $('#find .search_options #find_adventure_form').delay(400).fadeIn();
  })

  $('#find .search_options .show_me_locals').click(function(){
    $('#find .search_options .show_me_adventures').removeClass('active')
    $('#find .search_options .show_me_activities').removeClass('active')
    $(this).addClass('active');

    $('#find .search_options #find_adventure_form #locals').val(true);
    $('#find .search_options #find_adventure_activity_form #locals').val(true);

    if ($('#find .search_options #find_adventure_form #location').val().length > 0) {
      $('#find .search_options #find_adventure_form').submit();
    }

    $('#find .search_options #find_adventure_activity_form').fadeOut();
    $('#find .search_options #find_adventure_form').delay(400).fadeIn();
  })

  $('#find .search_options .show_me_activities').click(function(){
    $('#find .search_options .show_me_adventures').removeClass('active')
    $('#find .search_options .show_me_locals').removeClass('active')
    
    $(this).addClass('active');

    $('#find .search_options #find_adventure_form #locals').val(false);
    $('#find .search_options #find_adventure_activity_form #locals').val(false);

    $('#find .search_options #find_adventure_form').fadeOut();
    $('#find .search_options #find_adventure_activity_form').delay(400).fadeIn();
  })

}

function search_form_submits() {
  $('#find .search_options #find_adventure_activity_form .search_btn').click(function(){
    $('#find .search_options #find_adventure_activity_form').submit();
  })

  $('#find .search_options #find_adventure_form .input-group-addon').click(function(){
    var details = $.trim($('#find .search_options #find_adventure_form #location').val());

    if (details.length > 2) {
      $('#find .search_options #find_adventure_form').submit();
    }
    else {
      swal({
        title: "Please enter in a location!",
        imageUrl: "http://i.imgur.com/a6L0hYB.png"
      });
      $('#find .search_options #find_adventure_form #location').focus();
    }
  })
}

function activity_search_checkbox_validation() {
  $('#find .search_options #find_adventure_activity_form .search_btn').addClass('disabled');

  $('#find .search_options #find_adventure_activity_form .checkbox-inline input').change(function(){
    var checked = false;
    $('#find .search_options #find_adventure_activity_form .checkbox-inline input').each(function(index,value){
      if ($(this).is(':checked')){
        checked = true;
      }
    })

    if (checked) {
      $('#find .search_options #find_adventure_activity_form .search_btn').removeClass('disabled');
    }
    else {
     $('#find .search_options #find_adventure_activity_form .search_btn').addClass('disabled'); 
    }
  })
}

function get_selected_price_sort_by() {
	if ($('#find .search_results .location_filter .price_desc').hasClass('active')){
		return "DESC"
	}
	else if ($('#find .search_results .location_filter .price_asc').hasClass('active')) {
		return "ASC"
	}
	else {
		return "NONE"
	}
}

function get_selected_price_type() {
	if ($('#find .search_results .location_filter .price_type_ind').hasClass('active')){
		return "per_person"
	}
	else if ($('#find .search_results .location_filter .price_type_group').hasClass('active')) {
		return "per_adventure"
	}
	else {
		return "NONE"
	}
}

function get_selected_categories(local) {
	if (local) {
		// special case for all
		if ($('#find .search_results .local_filter .cat_call').hasClass('active')){
			return "ALL"
		}
		else {
			var categories = [];
			var i = 0;
			$('#find .search_results .local_filter .cat_btn').each(function(index,value){
				if ($(this).hasClass('active')) {
					categories[i] = $(this).data('category');
					i++;
				}
			})

			return categories;
		}
	}
	else {
		// special case for all
		if ($('#find .search_results .location_filter .cat_call').hasClass('active')){
			return "ALL"
		}
		else {
			var categories = [];
			var i = 0;
			$('#find .search_results .location_filter .cat_btn').each(function(index,value){
				if ($(this).hasClass('active')) {
					categories[i] = $(this).data('category');
					i++;
				}
			})

			return categories;
		}
	}
}

function find_location_filter_actions(adventure_ids){

	// PRICE SORTING
  $('#find .search_results .location_filter .price_asc').click(function(){
  	var categories = get_selected_categories(false);
  	var price_type = get_selected_price_type();

    $('#find .search_results .location_filter .price_desc').removeClass('active');
    $(this).addClass('active');

    $.ajax({
      url: "/find/filter_adventure",
      dataType: "script",
      data: {adventure_ids: adventure_ids, price_sort_by: "ASC", categories: categories, price_type: price_type, flag: false},
      type: "POST"
    })
  })

  $('#find .search_results .location_filter .price_desc').click(function(){
  	var categories = get_selected_categories(false);
  	var price_type = get_selected_price_type();

    $('#find .search_results .location_filter .price_asc').removeClass('active');
    $(this).addClass('active');

    $.ajax({
      url: "/find/filter_adventure",
      dataType: "script",
      data: {adventure_ids: adventure_ids, price_sort_by: "DESC", categories: categories, price_type: price_type, flag: false},
      type: "POST"
    })
  })

  // PRICE TYPE
  $('#find .search_results .location_filter .price_type_ind').click(function(){
  	var categories = get_selected_price_type();
  	var price_sort_by = get_selected_price_sort_by();

    $('#find .search_results .location_filter .price_type_group').removeClass('active');
    $(this).addClass('active');

    $.ajax({
      url: "/find/filter_adventure",
      dataType: "script",
      data: {adventure_ids: adventure_ids, price_sort_by: price_sort_by, categories: categories, price_type: "per_person", flag: false},
      type: "POST"
    })
  })

  $('#find .search_results .location_filter .price_type_group').click(function(){
  	var categories = get_selected_price_type();
  	var price_sort_by = get_selected_price_sort_by();

    $('#find .search_results .location_filter .price_type_ind').removeClass('active');
    $(this).addClass('active');

    $.ajax({
      url: "/find/filter_adventure",
      dataType: "script",
      data: {adventure_ids: adventure_ids, price_sort_by: price_sort_by, categories: categories, price_type: "per_adventure", flag: false},
      type: "POST"
    })
  })

  // CATEGORIES
  $('#find .search_results .location_filter .cat_btn').click(function(){
  	var price_sort_by = get_selected_price_sort_by();
  	var price_type = get_selected_price_type();

  	if ($(this).hasClass('cat_all')) {
  		$('#find .search_results .location_filter .cat_btn').each(function(index,value){
  			$(this).removeClass('active')
  		})

  		$(this).addClass('active');
  		var categories = "ALL";

  		$.ajax({
	      url: "/find/filter_adventure",
	      dataType: "script",
	      data: {adventure_ids: adventure_ids, price_sort_by: price_sort_by, categories: categories, price_type: price_type, flag: false},
	      type: "POST"
	    })
  	}

  	else {
  		// other categories
			var categories = [];
			$('#find .search_results .location_filter .cat_all').removeClass('active')
			$(this).addClass('active')

			// get selected categories
			categories = get_selected_categories(false);

			$.ajax({
	      url: "/find/filter_adventure",
	      dataType: "script",
	      data: {adventure_ids: adventure_ids, price_sort_by: price_sort_by, categories: categories, price_type: price_type, flag: false},
	      type: "POST"
	    })
  	}

  })
}

function find_local_filter_actions(user_ids){
	$('#find .search_results .local_filter .cat_btn').click(function(){

  	if ($(this).hasClass('cat_all')) {
  		$('#find .search_results .local_filter .cat_btn').each(function(index,value){
  			$(this).removeClass('active')
  		})

  		$(this).addClass('active');
  		var categories = "ALL";

  		$.ajax({
	      url: "/find/filter_local",
	      dataType: "script",
	      data: {user_ids: user_ids, categories: categories, flag: false},
	      type: "POST"
	    })
  	}

  	else {
  		// other categories
			var categories = [];
			$('#find .search_results .local_filter .cat_all').removeClass('active')
			$(this).addClass('active')

			// get selected categories
			categories = get_selected_categories(true);

			$.ajax({
	      url: "/find/filter_local",
	      dataType: "script",
	      data: {user_ids: user_ids, categories: categories, flag: false},
	      type: "POST"
	    })
  	}
  })
}

function scroll_to_results() {
	$('html,body').animate({
	    scrollTop: $('#find .search_results').offset().top-50
	  }, 800);
}

function load_adv_by_location(location,locals) {
  $.ajax({
    url: '/find/location',
    dataType: "script",
    data: {location: location, locals: locals},
    type: "POST"
  })
}

function load_adv_by_categories(categories,locals) {
  //convert string to array
  var cat_array = categories.split(",");

  $.ajax({
    url: '/find/category',
    dataType: "script",
    data: {category: cat_array, locals: locals},
    type: "POST"
  })
}

function host_index_effects() {
  $('.adv_box_small[data-toggle="tooltip"], .adv_box_large[data-toggle="tooltip"], .host_category_circle[data-toggle="tooltip"]').tooltip();

  $('.host_box').hover(
    function(){
      $('.host_box').stop().animate({
        "opacity":"0.6"
      })
      $(this).stop().animate({
        "opacity":"1"
      })
    },
    function(){
      $('.host_box').stop().animate({
        "opacity":"1"
      })
    }
  )
}

function contact_host_set_values() {
  $('.host_contact_btn, .msg_btn').click(function(){
    var host_name = $(this).data('host-name');
    var host_id = $(this).data('host-id');

    $('#contact_host_modal .contact_host_form input[name="conversation[host_id]"]').val(host_id);
    $('#contact_host_modal .modal-header').text('Message - '+host_name);
  })
}

function contact_host_validation(){
  $('#contact_host_modal #contact_host_form').bootstrapValidator({
    fields: {
      'email': {
        validators: {
          notEmpty: {
            message: 'Email is required and cannot be empty'
          },
          emailAddress: {
            message: 'Not a valid email address'
          }
        }
      },
      'message[body]': {
        validators: {
          notEmpty: {
            message: 'Body is required and cannot be empty'
          }
        }
      },
      'conversation[subject]': {
        validators: {
          notEmpty: {
            message: 'Subject is required and cannot be empty'
          }
        }
      }
    }
  });
}

function host_masonry_init() {
  $('.host_container').masonry({
    isFitWidth: true,
    itemSelector: '.host_box'
  }) 
}


adventureFind = function () {
  find_input_geocomplete();
  checkbox_highlighting();
  toggle_show_me_types();
  search_form_submits();
  activity_search_checkbox_validation();
}