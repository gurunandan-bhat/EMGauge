$(document).ready(function() {
	$('input#username').focus(function() {
		$('#availstatus').html('');
	});
	$('a#chkavail').click(function() {
		var uname = $('#username').val();
		if (uname) {
			$.get('user.cgi', {'rm': 'chkuname', 'uname': uname}, function(data) {
				$('#availstatus').html(data);
			});
		}
		return false;
	});
});
