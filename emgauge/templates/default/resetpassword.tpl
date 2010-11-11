<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
		<link rel="stylesheet" href="css/screen.css" type="text/css" media="screen, projection" />  
		<link rel="stylesheet" href="css/print.css" type="text/css" media="print" />  
		<!--[if lt IE 8]><link rel="stylesheet" href="css/ie.css" type="text/css" media="screen, projection" /><![endif]-->  
		<link rel="stylesheet" href="css/app.css" type="text/css" media="screen" />  
		<title>Reset your Password</title>
    </head>
	<body>
		<div class="container">
			<div class="span-24 last">
				<div class="banner"></div>
			</div>
			<div class="prepend-6 span-12 append-6 last">
				<form  name="registerform" method="post" action="user.cgi">
					<fieldset>
						<legend>Reset Password for <!-- TMPL_VAR NAME=USERNAME --></legend>
						<!-- TMPL_IF NAME=some_errors --><p class="error">Some fields were either invalid or missing. We have indicated the error next to each field</p><!-- /TMPL_IF -->
						<p>
							You are here because <!-- TMPL_VAR NAME=FULLNAME --> made a request to choose a new password. Please enter your
							new password (twice for confirmation) and click Submit. 
						</p>
						<p>
							<label for="password"><em>*</em> Choose a New Password for User <!-- TMPL_VAR NAME=USERNAME -->: (bet. 6 &amp; 18 chars)  <!-- TMPL_VAR NAME=err_password --></label><br />
							<input tabindex="1" id="password" type="password" name="password" size="18" value='' />
						</p>
						<p>
							<label for="rptpassword"><em>*</em> Re-type your Password (Just to be Sure!)  <!-- TMPL_VAR NAME=err_rptpassword --></label><br />
							<input tabindex="2" id="rptpassword" type="password" name="rptpassword" size="18" value='' />
						</p>
						<p>
							<input tabindex="3" type="submit" name="reset" value="Reset" />
						</p>
					</fieldset>
					<input type="hidden" name="rm" value="resetpassword" />
					<input type="hidden" name="id" value="<!-- TMPL_VAR NAME=ID -->" />
					<input type="hidden" name="digest" value="<!-- TMPL_VAR NAME=DIGEST -->" />
				</form>
			</div>
		</div>
	</body>
</html>