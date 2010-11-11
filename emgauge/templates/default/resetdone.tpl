<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
		<link rel="stylesheet" href="css/screen.css" type="text/css" media="screen, projection" />  
		<link rel="stylesheet" href="css/print.css" type="text/css" media="print" />  
		<!--[if lt IE 8]><link rel="stylesheet" href="css/ie.css" type="text/css" media="screen, projection" /><![endif]-->  
		<link rel="stylesheet" href="css/app.css" type="text/css" media="screen" />  
		<title>Hello</title>
    </head>
	<body>
		<div class="container">
			<div class="span-24 last">
				<div class="banner"></div>
			</div>
			<div class="prepend-7 span-10 append-7 last">
				<p class="success">
					Hi <strong><!-- TMPL_VAR NAME=FULLNAME --></strong>, <br /><br />
					Your password has been successfully changed. Click <a href="index.cgi?rm=hellop">here</a>
					to log in as <strong><!-- TMPL_VAR NAME=USERNAME --></strong> with your new password.<br />
					Thank you.
				</p>
			</div> 
		</div>
	</body>
</html>
