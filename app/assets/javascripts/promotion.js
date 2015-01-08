function sign_up_modal_toggle() {
	$('#promotion-wrapper .new-account').click(function(){
    $('#member-modal').modal('show');
  })
}

function initial_share_fb_init(){
	$('.giveaway-share').click(function(e) {
    e.preventDefault();
    elem = $(this);

    FB.ui(
      {
        method: 'feed',
        name: "Advlo $1000 Giveaway",
        link: "http://advlo.com/giveaway",
        caption: "I just entered to win $1000 on an epic adventure with a local",
      },
      function(response) {
        if (response && response.post_id) {
          $.ajax({
            method: 'POST',
            url: "giveaway/#{current_user.id}"
          })
        } else {
          swal({     
            title: "Sorry Did Not Publish",  
            imageUrl: "http://i.imgur.com/a6L0hYB.png"
          })
        }
      }
    );
  })
}

function temp() {
	invite_social_init()

	function postToFeed(title, desc, url, image){
	  var obj = {method: 'feed',link: url, picture: image,name: title,description: desc};

	  function callback(response){}
	    FB.ui(obj, callback);
	}
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