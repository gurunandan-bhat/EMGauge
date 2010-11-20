$(document).ready(function() {
	
	$('p.throbber').hide();
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
	
	$('a.editlink').click(function() {
		
		var formholder = $(this).parent('p').siblings('div.metaformholder');
		formholder.siblings('p.throbber').show();

		if ($(this).attr('state') == 1) {
			formholder.html('');
			$(this).attr('state', 0);
			return false;
		}

		$(this).attr('state', 1);
		
		var mailer = $(this).attr('mailer');
		var formholder = $(this).parent('p').siblings('div.metaformholder');
		
		$.get('mailer.cgi', {
			rm: 'generate_edit_form',
			mailer: mailer
		}, function(data) {

			formholder.siblings('p.throbber').hide();
			formholder.html(data);
			$('div.thumbnail').hide();
		});
		
		return false;
	});
		
	$('table.images tr td a.openup').live('click', function() {
		$(this).next('div.thumbnail').toggle();
		return false;
	});
	
	$('.metaformholder form').live('submit', function() {
		
		var holder = $(this).parent('.metaformholder');
		holder.siblings('p.throbber').show();
		
		$.get('mailer.cgi', $(this).serialize(), function(data) {
			holder.siblings('p.throbber').hide();
			holder.html(data);
			$('div.thumbnail').hide();
		});
		
		return false;
	});
	
})

