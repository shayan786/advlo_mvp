function input_popover() {
	$('[data-toggle="popover"]').popover({
      trigger: 'focus'
    });
}

function input_datepicker() {
    $('#user_dob').datepicker({
      format: "mm/dd/yyyy",
      startDate: "01/01/1940",
      startView: 2,
      orientation: "auto right",
      autoclose: true
    });
}