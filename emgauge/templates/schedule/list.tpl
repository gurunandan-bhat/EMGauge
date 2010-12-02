<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
		<link rel="stylesheet" href="css/screen.css" type="text/css" media="screen, projection" />  
		<link rel="stylesheet" href="css/print.css" type="text/css" media="print" />  
		<!--[if lt IE 8]><link rel="stylesheet" href="css/ie.css" type="text/css" media="screen, projection" /><![endif]-->  
		<link rel="stylesheet" href="css/emgauge.css" type="text/css" media="screen, projection" />
		<script type="text/javascript" src="js/jquery.min.js"></script>
		<script type="text/javascript" src="js/pause.js"></script>
		<title>Schedules: Undelivered Batches</title>
    </head>
	<body>
		<div class="container">
			<div class="span-24 last">
				<div class="banner"><!-- TMPL_INCLUDE NAME=default/bannermenu.tpl --></div>
			</div>
			<div class="prepend-7 span-10 append-1">
				<h1 class="sectionhead">Recently Scheduled Delivery Batches</h1>
				<!-- TMPL_LOOP NAME=SCHEDULE -->
				<div class="listentry<!-- TMPL_IF NAME=__odd__ --> odd<!-- /TMPL_IF -->">
					<h1><!-- TMPL_VAR NAME=SCHEDULENAME --></h1>
					<h2>
						Mailer: <strong><!-- TMPL_VAR NAME=SCHEDULEMAILERNAME --></strong><br />
						Subject: <strong><!-- TMPL_VAR NAME=SCHEDULEMAILERSUBJECT --></strong><br /> 
						Last Scheduled For: <strong><!-- TMPL_VAR NAME=SCHEDULEON --> (Repeated: <!-- TMPL_VAR NAME=SCHEDULEREPEATED -->)</strong><br />
					</h2>
					<p>
						Deliver To: <strong><!-- TMPL_VAR NAME=SCHEDULELISTS --></strong><br />
						Delivered: <strong><!-- TMPL_VAR NAME=SCHEDULEDELIVERED --> of <!-- TMPL_VAR NAME=SCHEDULECOUNT --></strong><br />
						Status: <strong><!-- TMPL_VAR NAME=SCHEDULESTATUS --></strong><br /> 
						<a href="schedule.cgi?rm=save_step0&scheduleid=<!-- TMPL_VAR NAME=SCHEDULEID -->">Edit</a> |
						<a href="schedule.cgi?rm=delete_schedule&scheduleid=<!-- TMPL_VAR NAME=SCHEDULEID -->">Delete</a>
						<!-- TMPL_IF NAME=SCHEDULEPAUSABLE -->| <a class="pauselink" schedule="<!-- TMPL_VAR NAME=SCHEDULEID -->" href="#">Pause</a><!-- /TMPL_IF -->
						<!-- TMPL_IF NAME=SCHEDULEPAUSED -->| <a class="restartlink" schedule="<!-- TMPL_VAR NAME=SCHEDULEID -->" href="#">Restart</a><!-- /TMPL_IF -->
					</p>
					<!-- TMPL_IF NAME=SCHEDULEPAUSABLE -->
					<form name="pause<!-- TMPL_VAR NAME=SCHEDULEID -->" class="pause" method="post" action="#">
						<fieldset>
							<legend>Do you really want to stop?</legend>
							<p>
								You can pause delivery, fix errors and restart delivery when done. 
								Restarting will only mail the balance recipients and no recipient will 
								be mailed twice <strong style="color: red;">if the recipient lists are
								not changed</strong>. If you want to deliver this mailer to a different 
								or modified list, <strong style="color: red;">make a new schedule</strong>.
							</p>
							<p>
								What do you want to do?
								<div style="text-align: center">
									<span style="display: none;"><br /></span>
									<input type="submit" schedule="<!-- TMPL_VAR NAME=SCHEDULEID -->" name="pause" class="button" value="Pause Delivery" /> 
									<input type="submit" schedule="<!-- TMPL_VAR NAME=SCHEDULEID -->" name="cancel" class="button" value="Continue Delivery" />  
								</div>
							</p>
						</fieldset>
					</form>
					<!-- /TMPL_IF -->
					<!-- TMPL_IF NAME=SCHEDULEPAUSED -->
					<form name="restart<!-- TMPL_VAR NAME=SCHEDULEID -->" class="restart" method="post" action="#">
						<fieldset>
							<legend>Do you really want to restart?</legend>
							<p>
								Restarting this batch will work cleanly only without duplicates only if 
								the lists have not changed since delivery was paused. If you want to deliver 
								this mailer to a different or modified list, 
								<strong style="color: red;">make a new schedule</strong>.
							</p>
							<p>
								What do you want to do?<br />
								<div style="text-align: center">
									<input type="submit" schedule="<!-- TMPL_VAR NAME=SCHEDULEID -->" name="restart" class="button" value="Restart Delivery" /> 
									<input type="submit" schedule="<!-- TMPL_VAR NAME=SCHEDULEID -->" name="cancel" class="button" value="Continue Pausing" />  
								</div>
							</p>
						</fieldset>
					</form>
					<!-- /TMPL_IF -->
				</div>
				<hr />
				<!-- /TMPL_LOOP -->
				<!-- TMPL_VAR NAME=PAGENAV -->
			</div>
			<div class="span-6 last">
				<!-- TMPL_INCLUDE NAME=default/task_list.tpl -->
			</div>
		</div>
	</body>
</html>
