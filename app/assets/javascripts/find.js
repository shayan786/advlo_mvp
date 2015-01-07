function find_input_geocomplete() {
  $('#find .search_options #location').geocomplete()
  .bind("geocode:result", function(event, result){
  	if($('#find .search_options .show_me_locals').hasClass('active')) {
  		$('#find .search_options #find_adventure_form #locals').val(true);
  	}
  	else {
  		$('#find .search_options #find_adventure_form #locals').val(false);
  	}

  	$('#find .search_options #find_adventure_form').submit();
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

function toggle_search_types() {
  $('#find .search_options .where_to_btn').click(function(){
    $('#find .search_options .which_adventure_btn').removeClass('active')
    $(this).addClass('active');

    $('#find .search_options #find_adventure_activity_form').fadeOut();
  })

  $('#find .search_options .which_adventure_btn').click(function(){
    $('#find .search_options .where_to_btn').removeClass('active')
    $(this).addClass('active');

    $('#find .search_options #find_adventure_form').fadeOut();
    $('#find .search_options #find_adventure_activity_form').delay(400).fadeIn();
  })
}

function toggle_show_me_types() {
	$('#find .search_options .show_me_adventures').click(function(){
    $('#find .search_options .show_me_locals').removeClass('active')
    $(this).addClass('active');
  })

  $('#find .search_options .show_me_locals').click(function(){
    $('#find .search_options .show_me_adventures').removeClass('active')
    $(this).addClass('active');
  })
}

function search_form_submits() {
  $('#find .search_options #find_adventure_activity_form .search_btn').click(function(){
    $('#find .search_options #find_adventure_activity_form').submit();
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


adventureFind = function () {
  find_input_geocomplete();
  checkbox_highlighting();
  toggle_search_types();
  toggle_show_me_types();
  search_form_submits();
  activity_search_checkbox_validation();
}