$(document).ready(function() {

	$('#metamailer').validate({
		rules: {
			zipfile: 	'required',
		},
		messages: {
			zipfile: 	'Zip/Rar File Missing',
		},
		errorClass: 'emgerr'
	});
});
