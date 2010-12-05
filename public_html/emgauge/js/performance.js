$(document).ready(function() {
	
	$('a.perflink').click(function() {

		var mlrid = $(this).attr('mailer');

		$.get('mailer.cgi', {
			rm: 'performance',
			mlrid: mlrid
		},
		function(data) {
			$('#mailer' + mlrid).html(data);
		});
		return false;
	});
})
