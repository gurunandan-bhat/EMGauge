$(document).ready(function() {
	
/*	$('p#mailthrobber').hide(); */
	$('p#mailstatus').hide();
	
	$('#testit').click(function() {

		$('p#mailthrobber').show();

		$.get('mailer.cgi', {rm: 'test_mailer', rcpt: $('input#testrecipient').val(), dfile: $(this).attr('dfile')}, function(data){
			$('p#mailthrobber').hide();
			$('p#mailstatus').html(data).show();	
		});

		return false;
	});
	
})
