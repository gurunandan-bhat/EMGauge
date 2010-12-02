$(document).ready(function() {
	
	$('form.pause').hide();
	
	$('a.pauselink').click(function() {
		$(this).parent('p').next('form.pause').toggle();
		return false;
	});
	
	$('input.button').live('click', function() {
		
		var button = $(this);
		var buttonname = button.attr('name');
		var schedule = button.attr('schedule');
		
		if (buttonname == 'cancel') {
			
			$(this).parents('form.pause').hide('slow');
		}
		else if (buttonname == 'pause') {
			
			$.get('schedule.cgi', {
				rm: 'pause_schedule', 
				sid: schedule
			}, 
			function(data){
				button.parents('form.pause').html(data);
				return;	
			});
		}
		else {
			alert('Failure');
		}
		return false;
	});
})
