<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
		<link rel="stylesheet" href="css/screen.css" type="text/css" media="screen, projection" />  
		<link rel="stylesheet" href="css/print.css" type="text/css" media="print" />  
		<!--[if lt IE 8]><link rel="stylesheet" href="css/ie.css" type="text/css" media="screen, projection" /><![endif]-->  
		<link rel="stylesheet" href="css/app.css" type="text/css" media="screen" />  
		<script src="http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"></script>
		<script src="js/checkavailability.js"></script>
		<title>Register</title>
    </head>
	<body>
		<div class="container">
			<div class="span-24 last">
				<div class="banner"></div>
			</div>
			<div class="prepend-6 span-12 append-6 last">
				<form  name="registerform" method="post" action="user.cgi">
					<fieldset>
						<legend>Regsiter with My Application</legend>
						<!-- TMPL_IF NAME=some_errors --><p class="error">Some fields were either invalid or missing. We have indicated the error next to each field</p><!-- /TMPL_IF -->
						<p>
							<label for="fullname"><em>*</em> Your Full Name: <!-- TMPL_VAR NAME=err_fullname --></label><br />
							<input tabindex="1" id="fullname" type="text" name="fullname" size="40" value="<!-- TMPL_VAR NAME=FULLNAME -->" />
						</p>
						<p>
							<label for="username"><em>*</em> Choose a Username: (bet. 6 &amp; 18 chars) <!-- TMPL_VAR NAME=err_username --></label><br />
							<input tabindex="2" id="username" type="text" name="username" size="18" value="<!-- TMPL_VAR NAME=USERNAME -->" />
							<a id="chkavail" href="#">Check Availability</a><br />
							<span id="availstatus"></span>
						</p>
						<!-- TMPL_IF NAME=DUPERROR -->
						<p class="notice">
							The Username <strong><!-- TMPL_VAR NAME=username --></strong> has already been registered with us. Please choose a different 
							username and click on <strong>Check Availability</strong> to check whether that username is already taken.
						</p>
						<!-- /TMPL_IF -->
						<p>
							<label for="email"><em>*</em> Your Email Address: <!-- TMPL_VAR NAME=err_email --></label><br />
							<input tabindex="3" id="email" type="text" name="email" size="64" value="<!-- TMPL_VAR NAME=EMAIL -->" />
						</p>
						<p>
							<label for="password"><em>*</em> Choose a Password: (bet. 6 &amp; 18 chars)  <!-- TMPL_VAR NAME=err_password --></label><br />
							<input tabindex="4" id="password" type="password" name="password" size="18" value='' />
						</p>
						<p>
							<label for="rptpassword"><em>*</em> Re-type your Password (Just to be Sure!)  <!-- TMPL_VAR NAME=err_rptpassword --></label><br />
							<input tabindex="5" id="rptpassword" type="password" name="rptpassword" size="18" value='' />
						</p>
						<p>
							<input tabindex="6" type="submit" name="register" value="Register" />
						</p>
					</fieldset>
					<input type="hidden" name="rm" value="register" />
				</form>
			</div>
		</div>
	</body>
</html>