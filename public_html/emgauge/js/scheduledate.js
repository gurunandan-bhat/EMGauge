$(document).ready(function() {

	$('#scheduledate').datepicker({
		inline: true,
		dateFormat: 'DD, d MM yy', minDate: +0
	});

	$('#send').click(function() {
		$('#scheduledate').rules('remove');
		$('#schedulehour').rules('remove');
		$('#schedulemin').rules('remove');
	});
	
	$('#save_step2').validate({
		rules: {
			assignlists: {
				required: true,
				minlength: 1
			},
			mailerid: 'required',
			schedulename: 'required',
			scheduledate: 'required',
			schedulehour: {
				required: true,
				number: true,
				min: 0,
				max: 23
			},
			schedulemin: {
				required: true,
				number: true,
				min: 0,
				max: 59
			}
		},
		messages: {
			scheduledate: 'Choose a date to start delivery',
			schedulehour: {
				required: 'Choose a Time when delivery must start',
				max: 'Hours must be less than 23'
			}
		},
		groups: {
			scheduletime: 'schedulehour schedulemin'
		},
		errorPlacement: function(error, element) {
			if (element.attr('name') == 'schedulehour' || element.attr('name') == 'schedulemin')
				error.insertAfter("#schedulemin");
			else
   				error.insertAfter(element);
		},
		errorClass: 'emgerr'
	});
});
