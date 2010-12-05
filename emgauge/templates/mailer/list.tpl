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
		<script type="text/javascript" src="js/index_test_mail.js"></script>    
		<script type="text/javascript" src="js/performance.js"></script>    
		<title>Create Mailer</title>
    </head>
	<body>
		<div class="container">
			<div class="span-24 last">
				<div class="banner"><!-- TMPL_INCLUDE NAME=default/bannermenu.tpl --></div>
			</div>
			<div class="span-18 append-1">
				<div class="prepend-8 span-10 last">
					<h1 class="sectionhead">Recently Created Mailers</h1>
				</div>
				<!-- TMPL_LOOP NAME=MAILERS -->
				<div class="span-18 last">
					<div class="span-8">
						<div class="rptholder" id="mailer<!-- TMPL_VAR NAME=MAILERID -->">
							&nbsp;
						</div>
					</div>
					<div class="span-10 last"> 
						<div class="listentry<!-- TMPL_IF NAME=__odd__ --> odd<!-- /TMPL_IF -->">
							<h1><!-- TMPL_VAR NAME=MAILERNAME --></h1>
							<h2>
								Subject: <!-- TMPL_VAR NAME=MAILERSUBJECT --><br />
								Campaign: <!-- TMPL_VAR NAME=MAILERCAMPAIGN -->; Created: <!-- TMPL_VAR NAME=MAILERCREATEDON --><br />
							</h2>
							<!-- TMPL_IF NAME=MAILERSCHEDULES -->
							<h3>Scheduled For</h3>
							<ol>
								<!-- TMPL_LOOP NAME=MAILERSCHEDULES -->
								<li><strong><!-- TMPL_VAR NAME=SCHEDULEDATE --></strong> To: <!-- TMPL_VAR NAME=SCHEDULELISTS --> (<a href="schedule.cgi?rm=save_step0&scheduleid=<!-- TMPL_VAR NAME=SCHEDULEID -->">Edit</a>)</li>
								<!-- /TMPL_LOOP -->
							</ol>
							<!-- TMPL_ELSE -->
							<h3>Not Scheduled Yet.</h3>
							<ul><li>Click on <strong>Add Schedule</strong> below to schedule this mailer.</li></ul>
							<!-- /TMPL_IF -->
							<p>
								<a href="<!-- TMPL_VAR NAME=MAILERLINK -->" target="_blank">View</a> |
								<a href="mailer.cgi?rm=edit_mailer&mailerid=<!-- TMPL_VAR NAME=MAILERID -->" target="_blank">Edit</a> |
								<a href="<!-- TMPL_VAR NAME=MAILERLANDINGPAGELINK -->">Landing Page</a> | 
								<a href="#" class="perflink" mailer="<!-- TMPL_VAR NAME=MAILERID -->">Performance</a> |
								<a href="mailer.cgi?rm=delete_mailer&selectedmailer=<!-- TMPL_VAR NAME=MAILERID -->">Delete</a> |
								<a href="schedule.cgi?rm=save_step0&mailerid=<!-- TMPL_VAR NAME=MAILERID -->">Add Schedule</a> | 
								<a href="#" class="testlink">Test</a> |
								<a href="#" class="editlink" mailer="<!-- TMPL_VAR NAME=MAILERID -->" state="0">Modify</a>
							</p>
							<p class="throbber"><img class="left" src="images/ajax-loader.gif" width="16" height="16" style="margin: 0; padding: 0;" />&nbsp;&nbsp;Working. Please wait...</p>
							<form class="sendform" id ="sendform<!-- TMPL_VAR NAME=MAILERID -->" action="#" method="post">
								<fieldset>
									<legend>Enter Recipients to send Test Mail</legend>
									<div class="teststatus"></div>
									<input type="text" name="rcpt" value="" style="width: 250px;" />
									<input type="hidden" name="mailer" value="<!-- TMPL_VAR NAME=MAILERID -->" />
									<input type="hidden" name="rm" value="test_db_mailer" />
									<input class="test" type="submit" name="sendto" value="Send" mailer="<!-- TMPL_VAR NAME=MAILERID -->" />
								</fieldset>
							</form>
							<div class="metaformholder"></div>
						</div>
					</div>
					<div class="prepend-8 span-10 last"><hr /></div>
				</div>
				<!-- /TMPL_LOOP -->
				<div class="span-18 last">
					<div class="prepend-8 span-10 last">
						<!-- TMPL_VAR NAME=PAGENAV -->
					</div>
				</div>
			</div>
			<div class="span-5 last">
				<!-- TMPL_INCLUDE NAME=default/task_list.tpl -->
			</div>
		</div>
	</body>
</html>
