function homepageGoogleTracking(){
  // signups

  $('#fb-top-signup').on('click', function() {
    ga('send', 'event', 'submit', 'click', 'top-facebook-signup');
  });

  $('#submit-email-login').on('click', function() {
    ga('send', 'event', 'submit', 'home-ageclick', 'top-email-signup');
  });


  $('#bottom_traveler_fb_signup').on('click', function() {
    ga('send', 'event', 'submit', 'click', 'bottom-traveler-facebook-signup');
  });
  $('#bottom_host_fb_signup').on('click', function() {
    ga('send', 'event', 'submit', 'click', 'bottom-host-facebook-signup');
  });


  $('#travel_email_signup').on('click', function() {
    ga('send', 'event', 'submit', 'click', 'bottom-traveler-email-submit');
  });
  $('#host_email_signup').on('click', function() {
    ga('send', 'event', 'submit', 'click', 'bottom-host-email-submit');
  });
  

  // toggles

  $('#email-login').on('click', function() {
    ga('send', 'event', 'toggle', 'click', 'top-email-toggle');
  });

  $('.travel-signup-toggle').on('click', function() {
    ga('send', 'event', 'button', 'click', 'bottom-travel-toggle');
  });

  $('.host-signup-toggle').on('click', function() {
    ga('send', 'event', 'button', 'click', 'bottom-host-toggle');
  });

  // exploring

  $('#homepage-explore').on('click', function() {
    ga('send', 'event', 'toggle', 'click', 'logged-user-homepage-explore');
  });

  $('#homepage-explore-mobile').on('click', function() {
    ga('send', 'event', 'toggle', 'click', 'logged-user-mobile-homepage-explore');
  });

  $('#featured-homepage-adventure').on('click', function() {
    ga('send', 'event', 'button', 'click', 'top-featured-adventure');
  });

  
  $('.region').on('click', function() {
    var location = 'top_location =>'+ $(this).find('.region-text').html();
    ga('send', 'event', 'adventure', 'click', location);
  });


  $('.adventure-brick').on('click', function(){
    var adventureName = $(this).find('.title').html()
    ga('send', 'event', 'adventure', 'click', adventureName);
  })
}


function footerGoogleTracking(){

  $('.footer-text a').on('click', function(){
    var link = $(this).attr('id')
    ga('send', 'event', 'footer', 'click', link);
  })

  $('.social-row a').on('click', function(){
    var link = $(this).attr('id')
    ga('send', 'event', 'footer', 'click', link);
  })
}
