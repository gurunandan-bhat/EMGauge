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
	
	$('a.clicks').live('click', function() {

		var aelem = $(this);
		var highrow = aelem.parent('td').parent('tr').next('tr.highlight');
		
		if (highrow.length) {
			highrow.remove();
			return false;
		}
		
		var mlrid = aelem.attr('mlrid');
		var schid = aelem.attr('schid');
		var url = 'mailer.cgi?rm=getclicks&mlrid=' + mlrid + '&schid=' + schid;

		$.get(url, function(data) {
			
			aelem.parent('td').parent('tr').after(data);
		});

		return false;
	})
})
