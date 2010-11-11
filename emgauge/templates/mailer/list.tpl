<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
		<link rel="stylesheet" href="css/screen.css" type="text/css" media="screen, projection" />  
		<link rel="stylesheet" href="css/print.css" type="text/css" media="print" />  
		<!--[if lt IE 8]><link rel="stylesheet" href="css/ie.css" type="text/css" media="screen, projection" /><![endif]-->  
		<link rel="stylesheet" href="css/emgauge.css" type="text/css" media="screen, projection" />
		<title>Create Mailer</title>
    </head>
	<body>
		<div class="container">
			<div class="span-24 last">
				<div class="banner"><!-- TMPL_INCLUDE NAME=default/bannermenu.tpl --></div>
			</div>
			<div class="prepend-7 span-10 append-1">
				<h1 class="sectionhead">Recently Created Mailers</h1>
				<!-- TMPL_LOOP NAME=MAILERS -->
				<div class="listentry<!-- TMPL_IF NAME=__odd__ --> odd<!-- /TMPL_IF -->">
					<h1><!-- TMPL_VAR NAME=MAILERNAME --></h1>
					<h2>Campaign: <!-- TMPL_VAR NAME=MAILERCAMPAIGN -->; Created: <!-- TMPL_VAR NAME=MAILERCREATEDON --></h2>
					<!-- TMPL_IF NAME=MAILERSCHEDULES -->
					<h3>Scheduled For</h3>
					<ol>
						<!-- TMPL_LOOP NAME=MAILERSCHEDULES -->
						<li><strong><!-- TMPL_VAR NAME=SCHEDULEDATE --></strong> To: <!-- TMPL_VAR NAME=SCHEDULELISTS --> (<a href="schedule.cgi?rm=save_step0&scheduleid=<!-- TMPL_VAR NAME=SCHEDULEID -->">Edit</a>)</li>
						<!-- /TMPL_LOOP -->
					</ol>
					<!-- /TMPL_IF -->
					<p>
						<a href="<!-- TMPL_VAR NAME=MAILERLINK -->" target="_blank">View</a> |
						<a href="mailer.cgi?rm=edit_mailer&mailerid=<!-- TMPL_VAR NAME=MAILERID -->" target="_blank">Edit</a> |
						<a href="<!-- TMPL_VAR NAME=MAILERLANDINGPAGELINK -->">Landing Page</a> | 
						<a href="#">Performance</a> |
						<a href="mailer.cgi?rm=delete_mailer&selectedmailer=<!-- TMPL_VAR NAME=MAILERID -->">Delete</a> |
						<a href="schedule.cgi?rm=save_step0&mailerid=<!-- TMPL_VAR NAME=MAILERID -->">Add a Schedule</a>
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
