function homepageGoogleTracking(){
  $('#fb-top-signup').on('click', function() {
    ga('send', 'event', 'button', 'click', 'homepage-facebook-signup');
    console.log("ga('send', 'event', 'button', 'click', 'homepage-facebook-signup');")
  });

  $('#email-login').on('click', function() {
    ga('send', 'event', 'button', 'click', 'homepage-email-form-toggle');
    console.log("ga('send', 'event', 'button', 'click', 'homepage-email-form-toggle');")
  });

  $('#submit-email-login').on('click', function() {
    ga('send', 'event', 'submission', 'click', 'homepage-email-submit');
    console.log("ga('send', 'event', 'submission', 'click', 'homepage-email-submit');")
  });

  $('#homepage-explore').on('click', function() {
    ga('send', 'event', 'button', 'click', 'homepage-explore');
    console.log("ga('send', 'event', 'button', 'click', 'homepage-explore');")
  });

  $('#featured-homepage-adventure').on('click', function() {
    ga('send', 'event', 'button', 'click', 'featured-homepage-adventure');
    console.log("ga('send', 'event', 'button', 'click', 'featured-homepage-adventure');")
  });

  $('.region').on('click', function() {
    var location = 'top_location_'+ $(this).find('.region-text').html().trim().toLowerCase().replace(/\s+/g, '');
    ga('send', 'event', 'button', 'click', location);
    console.log('region tracked => '+location)
  });


  $('.travel-signup-toggle').on('click', function() {
    ga('send', 'event', 'button', 'click', 'travel-signup');
    console.log("ga('send', 'event', 'button', 'click', 'travel-signup');")
  });

  $('.host-signup-toggle').on('click', function() {
    ga('send', 'event', 'button', 'click', 'host-signup');
    console.log("ga('send', 'event', 'button', 'click', 'host-signup');")
  });
}
