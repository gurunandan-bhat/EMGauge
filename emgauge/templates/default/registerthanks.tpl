<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
		<link rel="stylesheet" href="css/screen.css" type="text/css" media="screen, projection" />  
		<link rel="stylesheet" href="css/print.css" type="text/css" media="print" />  
		<!--[if lt IE 8]><link rel="stylesheet" href="css/ie.css" type="text/css" media="screen, projection" /><![endif]-->  
		<link rel="stylesheet" href="css/app.css" type="text/css" media="screen" />  
		<title>Register</title>
    </head>
	<body>
		<div class="container">
			<div class="span-24 last">
				<div class="banner"></div>
			</div>
			<div class="prepend-8 span-8 append-8 last">
				<h3>Welcome <!-- TMPL_VAR NAME=fullname --></h3>
				<p>Thank you for registering with us.</p>
				<p>
					You will receive any notifications about our service at your email address that you have provided during registration.
					We will also use that address to send you new passwords if you happen to forget them. Do make sure that 
					<!-- TMPL_VAR NAME=email --> can receive email from our Service Department.<br />
					You can <a href="index.cgi">click here</a> to Login and begin using the system.
				</p>
				<p>Thank you.</p>
			</div>
		</div>
	</body>
</html>