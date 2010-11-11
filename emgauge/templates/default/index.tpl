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
			<div class="span-6 menucol border">
				<h1>Mailers</h1>
				<p>
					<img class="left" src="images/mailer.png" width="110" height="110" />
					<a href="mailer.cgi">View Mailers</a><br />
					<a href="mailer.cgi?rm=save_step0">Create a Mailer</a><br />
				</p>
			</div>
			<div class="span-6 menucol border">
				<h1>Recipients</h1>
				
				<p>
					<img class="left" src="images/recipient.jpg" width="110" height="110" />
					<a href="data.cgi">View Recipients</a><br />
					<a href="data.cgi?rm=save_step0">Upload an Excel List</a>
				</p>
			</div>
			<div class="span-6 menucol border">
				<h1>Delivery Schedules</h1>
				<p>
					<img class="left" src="images/schedule.png" width="110" height="110" />
					<a href="schedule.cgi">View Schedules</a><br />
					<a href="schedule.cgi?rm=save_step0">Schedule a Delivery</a>
				</p>
			</div>
			<div class="spn-6 menucol last">
				<h1>Analytics</h1>
				<img class="left" src="images/analytics.png" width="110" height="110" />
				<a href="analytics.cgi">View Reports</a><br />
			</div>
		</div>
	</body>
</html>