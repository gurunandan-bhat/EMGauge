$(document).ready(function() {

	$('#metalist').validate({
		rules: {
			listid: 'required',			
			datafile: 'required'
		},
		messages: {
			listid: 'Please select a List to add to',			
			listsrc: 'Source is required to identify a List',
			datafile: 'File to Upload is required',
			list: 'A New List requires a Name'
		},
		errorClass: 'emgerr'
	});

	$('#alterlist').validate({
		rules: {
			selectedlist: {
				required: true,
				minlength: 1
			}
		},
		errorClass: 'emgerr'
	});

	$('#oldlist').hide();
	
	$('#oldlist a').click(function() {
		
		$('#listid').val('0');

		$('#newlist').show();				
		
		$('#list').rules('add', {required: true});
		$('#listsrc').rules('add', {required: true});
		$('#listid').rules('remove');

		$('#oldlist').hide();
		
		return false;
	});

	$('#newlist a').click(function() {

		$('input#list').val('');
		$('textarea#listsrc').val('');
		
		$('#oldlist').show();		

		$('#listid').rules('add', {required: true});		
		$('#list').rules('remove');		
		$('#listsrc').rules('remove');

		$('#newlist').hide();		

		return false;
	});
});
