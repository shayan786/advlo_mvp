var prevScroll = $(window).scrollTop()

// re-render adventures based on filter
$("#adventure-partial").hide()
$("#adventure-partial").html("<%= escape_javascript(render(partial: 'adventure_index', locals:{adventures: @adventures})) %>")
$("#adventure-partial").fadeIn('slow')

$('#location_text').css('top', ($('#hero_image').height() / 2))

// re-render cateogry based on filter
// var all_cat_li = $('#filter_nav #cat_body .cat_ul').find("li").first();
// $('#filter_nav #cat_body .cat_ul').empty();

// $('#filter_nav #cat_body .cat_ul').append(all_cat_li);
// $('#filter_nav #cat_body .cat_ul').append("<%= escape_javascript(render(partial: 'uniq_available_categories')) %>");


masonrySetup();
adventureIndex();

$(window).resize(function(){
  positionLocationText()
})

$(window).scrollTop(prevScroll);