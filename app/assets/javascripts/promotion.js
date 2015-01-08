function sign_up_modal_toggle() {
	$('#promotion-wrapper .new-account').click(function(){
    $('#member-modal').modal('show');
  })
}

function initial_share_fb_init(current_user_id){
	window.fbAsyncInit = function(){
    FB.init({
      appId: '210802829129036', status: true, cookie: true, xfbml: true }); 
  };
  
  (function(d, debug){var js, id = 'facebook-jssdk', ref = d.getElementsByTagName('script')[0];if   (d.getElementById(id)) {return;}js = d.createElement('script'); js.id = id; js.async = true;js.src = "//connect.facebook.net/en_US/all" + (debug ? "/debug" : "") + ".js";ref.parentNode.insertBefore(js, ref);}(document, /*debug*/ false));


	$('#promotion-wrapper .giveaway-share').click(function(e) {
    e.preventDefault();
    elem = $(this);

    FB.ui(
      {
        method: 'feed',
        name: "Advlo $1000 Giveaway",
        link: "http://advlo.com/giveaway",
        caption: "I just entered to win $1000 on an epic adventure with a local",
        picture: "http://i.imgur.com/a6L0hYB.png"
      },
      function(response) {
        if (response && response.post_id) {
          $.ajax({
            method: 'POST',
            url: "giveaway/"+current_user_id
          })
        } else {
          swal({     
            title: "Share it later?",  
            imageUrl: "http://i.imgur.com/a6L0hYB.png"
          })
        }
      }
    );
  })
}

function masonry_init(){
  $('#promotion-wrapper .additional_entries .share_adventures').masonry({
    isFitWidth: true,
    itemSelector: '.social_share_box'
  })
}

function promotion_init() {
	sign_up_modal_toggle();
	masonry_init();
}