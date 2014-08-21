var prevScroll = $(window).scrollTop()

// re-render adventures based on filter
$("#adventure-partial").hide()
$("#adventure-partial").html("<%= escape_javascript(render(partial: 'adventure_index', locals:{adventures: @adventures})) %>")
$("#adventure-partial").fadeIn('slow')

$('#location_text').css('top', ($('#hero_image').height() / 2))

masonrySetup();
adventureIndex();

$(window).resize(function(){
  positionLocationText()
})

$(window).scrollTop(prevScroll);