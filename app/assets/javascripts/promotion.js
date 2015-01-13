function sign_up_modal_toggle() {
	$('#promotion-wrapper .new-account').click(function(){
    $('#member-modal').modal('show');
  })

}

function terms_init() {
  $('.terms-toggle').click(function(){
    $('.terms_text').slideToggle();
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
        name: "$1000 Adventure Trip Giveaway",
        link: "http://advlo.com/giveaway",
        description: "I just entered to win $1000 on an epic adventure with a local",
        caption: "Adventure Local - www.advlo.com",
        picture: "http://s3-us-west-2.amazonaws.com/advlo/hero_images/attachments/000/000/461/hero/advlo_giveaway_surf.jpg?1420861194"
      },
      function(response) {
        if (response && response.post_id) {
          $.ajax({
            method: 'POST',
            url: "giveaway/"+current_user_id
          })
        } else {
          swal({     
            title: "Enter giveaway later?",
            imageUrl: "http://i.imgur.com/a6L0hYB.png"
          })
        }
      }
    );
  })
}

function adv_share_social() {
	//FB
	window.fbAsyncInit = function(){
    FB.init({
      appId: '210802829129036', status: true, cookie: true, xfbml: true }); 
  };
  
  (function(d, debug){var js, id = 'facebook-jssdk', ref = d.getElementsByTagName('script')[0];if   (d.getElementById(id)) {return;}js = d.createElement('script'); js.id = id; js.async = true;js.src = "//connect.facebook.net/en_US/all" + (debug ? "/debug" : "") + ".js";ref.parentNode.insertBefore(js, ref);}(document, /*debug*/ false));

	$('#promotion-wrapper .share_adventures .social_share_box .social_share_btns .fb').click(function(e) {
    e.preventDefault();
    elem = $(this);

    FB.ui(
      {
        method: 'feed',
        name: $(this).data('title'),
        link: $(this).attr('href'),
        description: $(this).data('desc'),
        caption: "Adventure Local - www.advlo.com",
        picture: $(this).data('image')
      }
    );
  })

  //TWITTER
  $('#promotion-wrapper .share_adventures .social_share_box .social_share_btns .twitter_promo').click(function(){
    var url = $(this).data('url');
    height = $(window).height();
    width = $(window).width();

    window.open("https://twitter.com/share?url=" + url + "&text= Adventure local is giving away $1000 towards any trip. " + url, 'sharer', 'top=' + (height/3) + ',left=' + (width/3) + ',toolbar=0,status=0,width=' + 500 + ',height=' + 500);
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
  terms_init();
}