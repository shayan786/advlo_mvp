$('#adv_payment .update_notice').fadeIn();
$('#change_bank_form').fadeOut();
$("#updated-bank-form").html("<%= escape_javascript(render(partial: 'updated_bank_form', locals: {recipient_info: @updated_recipient})) %>")
$(".add-bank").hide()
$('.bank_change_btn').fadeOut()