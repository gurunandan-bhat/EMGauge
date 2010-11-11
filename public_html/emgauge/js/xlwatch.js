$(document).ready(function() {
	var pqid = $('table').attr('listid');
	if (pqid) {

		$('#goodbar').progressbar({value: $('#donepercent').text()});

		var stoptimer = 0;
		var d = new Date();
		var timerid = setInterval(function() {
			$.getJSON('data.cgi', {rm: 'updatewatch', pqid: pqid, dummy: d.getTime()}, function(data){

				stoptimer = data.donestatus;

				if (data.donestatus) {
					$('#goodbar').progressbar({value: 100});
					$('#watchdetail').html('<p class="success">Upload Complete: ' + data.donestatus + ' Records Imported');
				}
				else {
					$('#donerows').html(data.donerows);
					$('#donepercent').html(data.donepercent);
					$('#goodbar').progressbar({value: Math.floor(data.donepercent)});
				}
			});

			if (stoptimer) {
				clearInterval(timerid);
			}
		}, 10000);
		
		
	}
})
