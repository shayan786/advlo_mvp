$("#adventure-partial").hide()
$("#adventure-partial").html("<%= escape_javascript(render(partial: 'adventure_index', locals:{adventures: @adventures})) %>")
$("#adventure-partial").fadeIn('slow')

adventureIndex();
$('#location_text').css('top', ($('#hero_image').height() / 2))

$(window).resize(function(){
  positionLocationText()
})