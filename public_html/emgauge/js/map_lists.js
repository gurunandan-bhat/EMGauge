$(document).ready(function() {
	
	$('#list_submit').click(function() {
		
		var jsonvar = $('#metamailer').serializeArray();
		var count = 0;
		$.each(jsonvar, function(k, v) {
			if (v.value == 'email') {
				++count;
			}			
		});
		var listsheets = $('#listsheets').attr('value');
		if (count < listsheets) {
			alert('Every sheet must have at least one imported column mapped to Email. Please check your mappings. You have uploaded ' + listsheets + ' sheets. But only imported an email column from ' + count + ' sheets');
			return false;
		}
		else
			return true;
	});
})
