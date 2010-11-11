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
		<script type="text/javascript" src="js/assignlists.js"></script>
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
						<li id="current"><span>2</span> <div class="step_desc">Assign Lists to Schedule</div></li>
						<li><span>3</span> <div class="step_desc">Set Date & Save</div></li>
					</ul>
				</div>
			</div> 
			<div class="prepend-3 span-18 append-3 last formholder">
				<div class="innerholder">
					<div class="prepend-2 span-14 append-2 last">
						<!-- TMPL_IF NAME=some_errors -->
						<p class="error">
							Some fields were either invalid or missing. 
							We have indicated the error next to each field
						</p>
						<!-- /TMPL_IF -->
						<p>
							You are creating a new Schedule: <strong><!-- TMPL_VAR NAME=SCHEDULENAME --></strong> to mail <strong><!-- TMPL_VAR NAME=MAILERNAME --></strong><br />
						 	To Add a Recipient List for this Mailer check the box next to a List.<br />
							To remove a recipient list, just uncheck the checked box.
						</p>
					</div>
					<form action="schedule.cgi" method="post" id="schedule_step1">
						<div class="prepend-2 span-7">
							<h5 id="checklist">(Un-)Check to (Un-)Assign <!-- TMPL_VAR NAME=err_assignlists --></h5>
							<div style="height: 240px; overflow-y: auto; overflow-x: hidden; margin-bottom: 25px;">
							<table>
								<!-- TMPL_LOOP NAME=ASSIGNEDLISTS -->
								<tr<!-- TMPL_IF NAME=__odd__ --> class="odd"<!-- /TMPL_IF>>
									<td><label for="available_<!-- TMPL_VAR NAME=LISTID -->"><input type="checkbox" id="available_<!-- TMPL_VAR NAME=LISTID -->" name="assignlists" value="<!-- TMPL_VAR NAME=LISTID -->" listname="<!-- TMPL_VAR NAME=LISTNAME -->" checked="checked" /> <!-- TMPL_VAR NAME=LISTNAME --></label></td>
								</tr>
								<!-- /TMPL_LOOP -->
								<!-- TMPL_LOOP NAME=UNASSIGNEDLISTS -->
								<tr<!-- TMPL_IF NAME=__odd__ --> class="odd"<!-- /TMPL_IF>>
									<td><label for="available_<!-- TMPL_VAR NAME=LISTID -->"><input type="checkbox" id="available_<!-- TMPL_VAR NAME=LISTID -->" name="assignlists" value="<!-- TMPL_VAR NAME=LISTID -->" listname="<!-- TMPL_VAR NAME=LISTNAME -->" /> <!-- TMPL_VAR NAME=LISTNAME --></label></td>
								</tr>
								<!-- /TMPL_LOOP -->
							</table>
							</div>
						</div>
						<div class="span-7 append-2 last">
							<h5>Assigned Lists</h5>
							<table id="assignedtable">
								<!-- TMPL_LOOP NAME=ASSIGNEDLISTS -->
								<tr listid="<!-- TMPL_VAR NAME=LISTID -->" listname="<!-- TMPL_VAR NAME=LISTNAME -->"<!-- TMPL_UNLESS NAME=__odd__ --> class="odd"<!-- /TMPL_UNLESS>>
									<td><!-- TMPL_VAR NAME=LISTNAME --></td>
								</tr>
								<!-- /TMPL_LOOP -->
							</table>
						</div>
						<hr />
						<div style="margin: 5px auto; width: 200px;">
							<input type="reset" name="reset" value="Reset" />
							<input type="submit" name="next" value="Next" />
							<input type="hidden" name="mailerid" value="<!-- TMPL_VAR NAME=MAILERID -->" />
							<input type="hidden" name="scheduleid" value="<!-- TMPL_VAR NAME=SCHEDULEID -->" />
							<input type="hidden" name="schedulename" value="<!-- TMPL_VAR NAME=SCHEDULENAME -->" />
							<input type="hidden" name="rm" value="save_step2" />
						</div>
					</form>
				</div>
			</div>
		</div>
	</body>
</html>
