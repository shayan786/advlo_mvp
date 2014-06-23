homepageInit = function() {
  sliderInit();
};

$(document).on('page:load', function(){
  homepageInit();
});
$(document).on('page:change', function(){
  homepageInit();
});

