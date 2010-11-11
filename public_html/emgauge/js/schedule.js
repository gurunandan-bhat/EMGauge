$(document).ready(function() {

	$('#schedule_step0').validate({
		rules: {
			schedulename: 'required',			
			mailerid: {
				required: true,
				min: 1
			}
		},
		messages: {
			schedulename: 'Provide a Name for this Batch',			
			mailerid: 'Select a Mailer to Schedule'
		},
		errorClass: 'emgerr'
	});
})
