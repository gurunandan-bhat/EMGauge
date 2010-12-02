$(document).ready(function() {
	
	$('form.pause').hide();
	$('form.restart').hide();
	
	$('a.pauselink').click(function() {
		$(this).parent('p').next('form.pause').toggle();
		return false;
	});
	
	$('a.restartlink').click(function() {
		$(this).parent('p').next('form.restart').toggle();
		return false;
	});

	$('form.pause input.button').live('click', function() {
		
		var button = $(this);
		var buttonname = button.attr('name');
		var schedule = button.attr('schedule');
		
		if (buttonname == 'cancel') {
			
			$(this).parents('form.pause').hide('slow');
			return false;
		}
		else if (buttonname == 'pause') {
			
			$.get('schedule.cgi', {
				rm: 'pause_schedule', 
				sid: schedule
			}, 
			function(data){
				button.parents('form.pause').html(data);
				return false;	
			});
		}
		else {
			alert('Failure');
		}
		return false;
	});

	$('form.restart input.button').live('click', function() {
		
		var button = $(this);
		var buttonname = button.attr('name');
		var schedule = button.attr('schedule');
		
		if (buttonname == 'cancel') {
			
			$(this).parents('form.restart').hide('slow');
			return false;
		}
		else if (buttonname == 'restart') {
			
			$.get('schedule.cgi', {
				rm: 'restart_schedule', 
				sid: schedule
			}, 
			function(data){
				button.parents('form.restart').html(data);
				return false;	
			});
		}
		else {
			alert('Failure');
		}
		return false;
	});
})
