$(document).ready(function() {
	
	$('#schedule_step1').validate({
		rules: {
			assignlists: {
				required: true,
				minlength: 1
			},
			schedulename: 'required',			
			mailerid: 'required'
		},
		errorClass: 'emgerr',
		messages: {
			assignlists: 'Select at least 1 list'
		},
		errorPlacement: function(error, element) {
			if (element.attr('name') == 'assignlists')  
				error.insertAfter('h5#checklist');
			else
				error.insertAfter(element);
		}
	});
	
	$('input:checkbox').click(function() {
		var listname = $(this).attr('listname');
		var listid = $(this).attr('value');
		var state = $(this).attr('checked');
		if (state) {
			var str = '<tr listid="' + listid + '" listname="' + listname + '"><td>' + listname + '</td></tr>';
			$('#assignedtable').append(str);
		}
		else {
			$('#assignedtable tr[listid=' + listid + ']').remove();
		}
	});
});
