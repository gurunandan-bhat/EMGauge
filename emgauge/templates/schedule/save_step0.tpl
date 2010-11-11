<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
		<link rel="stylesheet" href="css/screen.css" type="text/css" media="screen, projection" />  
		<link rel="stylesheet" href="css/print.css" type="text/css" media="print" />  
		<!--[if lt IE 8]><link rel="stylesheet" href="css/ie.css" type="text/css" media="screen, projection" /><![endif]-->  
		<link rel="stylesheet" href="css/emgauge.css" type="text/css" media="screen, projection" />
		<script src="http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"></script>
 		<script type="text/javascript" src="js/jquery.validate.pack.js"></script>
		<script type="text/javascript" src="js/schedule.js"></script>
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
						<li id="current"><span>1</span> <div class="step_desc">Select a Mailer</div></li>
						<li><span>2</span> <div class="step_desc">Assign Lists to Schedule</div></li>
						<li><span>3</span> <div class="step_desc">Set Date & Save</div></li>
					</ul>
				</div>
			</div>
			<div class="prepend-3 span-18 append-3 last formholder">
				<div class="innerholder">
					<div class="prepend-1 span-9 append-1">
						<form action="schedule.cgi" method="post" id="schedule_step0">
							<!-- TMPL_IF NAME=some_errors -->
							<p class="error">
								Some fields were either invalid or missing. 
								We have indicated the error next to each field
							</p>
							<!-- /TMPL_IF -->
							<p>Create a New Batch and Choose a Mailer</p>
							<div id="newschedule">			
								<p>
									<label for="schedulename"><em>*</em> New Batch Name:</label> <!-- TMPL_VAR NAME=err_schedulename --><br />
									<input class="textInput" type="text" id="schedulename" name="schedulename" value="<!-- TMPL_VAR NAME=schedulename -->" />
								</p>
								<p>
									<label for="mailerid"><em>*</em> Select a Mailer to Schedule:</label> <!-- TMPL_VAR NAME=err_mailerid --><br />
									<select id="mailerid" name="mailerid">
										<option value="0">Select Mailer...</option>
										<!-- TMPL_LOOP NAME=MAILERS -->
										<option value="<!-- TMPL_VAR NAME=MAILERID -->"<!-- TMPL_IF NAME=MAILERSELECTED --> selected="selected"<!-- /TMPL_IF -->><!-- TMPL_VAR NAME=MAILERNAME --></option>
										<!-- /TMPL_LOOP -->
									</select><br />
								</p>
								<p class="buttonContainer">
									<input type="reset" name="reset" value="Reset" />
									<input type="submit" name="next" value="Next" />
									<input type="hidden" name="rm" value="save_step1" />
									<input type="hidden" name="scheduleid" value="<!-- TMPL_VAR NAME=scheduleid -->" />
								</p>
							</div>					
						</form>
					</div>
					<div class="span-7 last">
						<h1>Recent Mailers</h1>
					</div>
				</div>
			</div>
		</div>
	</body>
</html>
