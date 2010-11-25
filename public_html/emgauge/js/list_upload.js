$(document).ready(function() {

	$('#metalist').validate({
		rules: {
			datafile: 'required',
			listsrc: 'required'
		},
		messages: {
			listid: 'Please select a List to add to',			
			listsrc: 'Source is required to identify a List',
			datafile: 'File to Upload is required',
			list: 'A New List requires a Name'
		},
		errorClass: 'emgerr'
	});

	$('#oldlist').hide();
	$('#list').rules('add', {required: true});
	
	$('#oldlist a').click(function() {
		
		$('#listid').val('0');

		$('#newlist').show();				
		
		$('#list').rules('add', {required: true});
		$('#listid').rules('remove');

		$('#oldlist').hide();
		
		return false;
	});

	$('#newlist a').click(function() {

		$('input#list').val('');
		
		$('#oldlist').show();		

		$('#listid').rules('add', {required: true, min: 1});		
		$('#list').rules('remove');		

		$('#newlist').hide();		

		return false;
	});
});
