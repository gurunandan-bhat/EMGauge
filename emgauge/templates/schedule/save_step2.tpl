<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
		<link rel="stylesheet" href="css/screen.css" type="text/css" media="screen, projection" />  
		<link rel="stylesheet" href="css/print.css" type="text/css" media="print" />  
		<!--[if lt IE 8]><link rel="stylesheet" href="css/ie.css" type="text/css" media="screen, projection" /><![endif]-->  
		<link rel="stylesheet" href="css/emgauge.css" type="text/css" media="screen, projection" />
		<link type="text/css" href="css/ui-lightness/jquery-ui-1.8rc3.custom.css" rel="stylesheet" />	
		<script src="http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"></script>
		<script type="text/javascript" src="js/jquery-ui-1.8rc3.custom.min.js"></script>
 		<script type="text/javascript" src="js/jquery.validate.pack.js"></script>
		<script type="text/javascript" src="js/scheduledate.js"></script>
		<title>Create Mailer</title>
    </head>
	<body>
		<div class="container">
			<div class="span-24 last">
				<div class="banner"><!-- TMPL_INCLUDE NAME=default/bannermenu.tpl --></div>
			</div>
			<div class="prepend-3 span-18 append-3 last">
				<div class="step_tabs">
					<ul>
						<li><span>1</span> <div class="step_desc">Select a Mailer</div></li>
						<li><span>2</span> <div class="step_desc">Assign Lists to Schedule</div></li>
						<li id="current"><span>3</span> <div class="step_desc">Set Date & Save</div></li>
					</ul>
				</div>
			</div>
			<div class="prepend-3 span-18 append-3 last formholder">
				<div class="innerholder">
					<div class="prepend-1 span-7 append-1">
						<form action="schedule.cgi" method="post" id="save_step2">
							<!-- TMPL_IF NAME=some_errors -->
							<p class="error">
								Some fields were either invalid or missing. 
								We have indicated the error next to each field
							</p>
							<!-- /TMPL_IF -->
							<p>Choose a Date and Time at which <strong><!-- TMPL_VAR NAME=MAILERNAME --></strong> should be delivered to selected lists</p>
							<p>
		                		<label for="scheduledate"><em>*</em>Schedule On:</label><br />
								<input class="textInput" type="text" id="scheduledate" name="scheduledate" value="<!-- TMPL_VAR NAME=SCHEDULEDATE -->" /><br />
								<!-- TMPL_VAR NAME=err_scheduledate -->
							</p>
							<p>
		                		<label for="schedulehour"><em>*</em>At Time (HH24:MM):</label><br />
								<input class="textInput smalltime" type="text" id="schedulehour" name="schedulehour" size="2" maxlength="2" value="<!-- TMPL_VAR NAME=SCHEDULEHOUR -->" /> 
								<input class="textInput smalltime" type="text" id="schedulemin" name="schedulemin"  size="2" maxlength="2" value="<!-- TMPL_VAR NAME=SCHEDULEMIN -->" /> <br />
								<!-- TMPL_IF NAME=err_schedulehour --><!-- TMPL_VAR NAME=err_schedulehour --> Hour<!-- /TMPL_IF --><br />
								<!-- TMPL_IF NAME=err_schedulemin --><!-- TMPL_VAR NAME=err_schedulemin --> Minutes<!-- /TMPL_IF -->
							</p>
							<p class="buttonContainer">
							</p>
							<p class="buttonContainer">
								<input type="reset" name="reset" value="Reset" />
								<input type="submit" id="send" name="send" value="Send Now" />
								<input type="submit" name="save" value="Schedule" />
								<input type="hidden" name="mailerid" value="<!-- TMPL_VAR NAME=MAILERID -->" />
								<input type="hidden" name="scheduleid" value="<!-- TMPL_VAR NAME=SCHEDULEID -->" />
								<input type="hidden" name="schedulename" value="<!-- TMPL_VAR NAME=SCHEDULENAME -->" />
								<!-- TMPL_LOOP NAME=LISTIDS --><input type="hidden" name="assignlists" value="<!-- TMPL_VAR NAME=LISTID -->" /><!-- /TMPL_LOOP -->
								<input type="hidden" name="rm" value="save_schedule" />
							</p>
						</form>
					</div>
					<div class="span-8 append-1 last">
						<h1>Schedule Details</h1>
						<table width="100%" cellspacing="0" cellpadding="2" border="0">
							<tr><th style="vertical-align: top;">Schedule: </th><td><!-- TMPL_VAR NAME=SCHEDULENAME --></td></tr>
							<tr><th style="vertical-align: top;">Mailer: </th><td><!-- TMPL_VAR NAME=MAILERNAME --></td></tr>
							<tr><th style="vertical-align: top;">Recipients: </th><td><!-- TMPL_VAR NAME=LISTNAMES --></td></tr>
						</table>
					</div>
				</div>
			</div>
		</div>
	</body>
</html>
