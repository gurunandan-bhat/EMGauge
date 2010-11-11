$(document).ready(function() {

	$('#metamailer').validate({
		rules: {
			mailer: 	'required',			
			zipfile: 	'required',
			campaignid: 'required'
		},
		messages: {
			mailer: 	'Mailer Name Missing',			
			zipfile: 	'Zip/Rar File Missing',
			campaignid: 'Campaign Missing',
			campaign: 	'Campaign Name Missing'
		},
		errorClass: 'emgerr'
	});

	$('#altermailer').validate({
		rules: {
			selectedmailer: {
				required: true,
				minlength: 1
			}
		},
		errorClass: 'emgerr'
	});

	$('#newcpgn').hide();
	
	$('#oldcpgn a').click(function() {
		$('#newcpgn').show();				
		$('#campaign').rules('add', {required: true});
		$('#campaignid').rules('remove');
		$('#oldcpgn').hide();		
		return false;
	});

	$('#newcpgn a').click(function() {
		$('#oldcpgn').show();		
		$('#campaignid').rules('add', {required: true});		
		$('#campaign').rules('remove');		
		$('#newcpgn').hide();		
		return false;
	});
});
