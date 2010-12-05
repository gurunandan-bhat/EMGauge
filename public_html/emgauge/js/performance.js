$(document).ready(function() {
	
	$('a.perflink').click(function() {

		var mlrid = $(this).attr('mailer');
		$('#mailer' + mlrid).html('<p><img src="images/ajax-loader.gif" /> Fetching Data</p>');
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
