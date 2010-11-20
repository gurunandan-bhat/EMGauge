$(document).ready(function() {
	
	$('form.sendform').hide();
	
	$('a.testlink').click(function() {
		
		$(this).parent('p').next('form.sendform').toggle();
		return false;
	});
	
	$('form.sendform').submit(function() {
		
		var lgnd = $(this).find('legend');
		lgnd.addClass('waiting');
		lgnd.next('div.teststatus').html('');	
		
		var qrystr = $(this).serialize();
		$.get('mailer.cgi?' + qrystr, function(data) {
			lgnd.next('div.teststatus').html(data);	
			lgnd.removeClass('waiting');
		});
		return false;
	});
	
})
