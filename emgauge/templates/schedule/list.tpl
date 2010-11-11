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
		<script type="text/javascript" src="js/deliversignal.js"></script>
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
						Mailer: <strong><!-- TMPL_VAR NAME=SCHEDULEMAILERNAME --></strong>; 
						Scheduled For: <strong><!-- TMPL_VAR NAME=SCHEDULEON --></strong>
						(<a href="schedule.cgi?rm=save_step0&scheduleid=<!-- TMPL_VAR NAME=SCHEDULEID -->">Edit</a> | <a href="schedule.cgi?rm=delete_schedule&scheduleid=<!-- TMPL_VAR NAME=SCHEDULEID -->">Delete</a>)
					</h2>
					<p>
						Deliver To: <strong><!-- TMPL_VAR NAME=SCHEDULELISTS --></strong><br />
						Delivered: <strong><!-- TMPL_VAR NAME=SCHEDULEDELIVERED --> of <!-- TMPL_VAR NAME=SCHEDULECOUNT --></strong><br />
						Status: <strong><!-- TMPL_VAR NAME=SCHEDULESTATUS --></strong> 
						<!-- TMPL_IF NAME=SCHEDULEPAUSABLE -->| <a id="<!-- TMPL_VAR NAME=SCHEDULEID -->" href="#">Pause Delivery</a><!-- /TMPL_IF -->
					</p>
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
