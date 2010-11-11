<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
		<link rel="stylesheet" href="css/screen.css" type="text/css" media="screen, projection" />  
		<link rel="stylesheet" href="css/print.css" type="text/css" media="print" />  
		<!--[if lt IE 8]><link rel="stylesheet" href="css/ie.css" type="text/css" media="screen, projection" /><![endif]-->  
		<link rel="stylesheet" href="css/app.css" type="text/css" media="screen" />  
		<title>Reset Password</title>
    </head>
	<body>
		<div class="container">
			<div class="span-24 last">
				<div class="banner"></div>
			</div>
			<div class="prepend-7 span-10 append-7 last">
				<form  name="registerform" method="post" action="user.cgi">
					<fieldset>
						<legend>Password Reset Request</legend>
						<p>
							Please enter the email address provided by you during registration and we will mail you a link at that address.
						</p>
						<p>
							When you receive the email from us, open it and click on the link. This will take you to a page where you can reset 
							your password and begin using our services again.
						</p> 
						<!-- TMPL_IF NAME=some_errors --><p class="error">Some fields were either invalid or missing. We have indicated the error next to each field</p><!-- /TMPL_IF -->
						<p>
							<label for="email"><em>*</em> Your Email Address: <!-- TMPL_VAR NAME=err_email --></label><br />
							<input tabindex="1" id="email" type="text" name="email" size="64" value="<!-- TMPL_VAR NAME=EMAIL -->" />
						</p>
						<!-- TMPL_IF NAME=NONEERROR -->
						<p class="notice">
							We have no registered user whose email matches <strong><!-- TMPL_VAR NAME=email --></strong>.<br />
							If you wish to register, you can do so <a href="user.cgi?rm=register">here</a>. 
						</p>
						<!-- /TMPL_IF -->
						<p>
							<input tabindex="2" type="submit" name="forgotpassword" value="Submit" />
						</p>
					</fieldset>
					<input type="hidden" name="rm" value="forgotpassword" />
				</form>
			</div>
		</div>
	</body>
</html>