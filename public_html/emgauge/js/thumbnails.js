$(document).ready(function() {
	
	$('div.thumbnail').hide();
	
	$('table.images tr td a.openup').click(function() {
		$(this).next('div.thumbnail').toggle();
		return false;
	});

})