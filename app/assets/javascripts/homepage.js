$(document).ready(function(){
  $('.image-wrapper').hover(function(){

    var id = $(this).attr('id').toString()
    $('#hover-'+id).fadeIn()

  },function(){

    var id = $(this).attr('id')
    $('#hover-'+id).fadeOut()
    

  })
})