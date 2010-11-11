<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
		<link rel="stylesheet" href="css/screen.css" type="text/css" media="screen, projection" />  
		<link rel="stylesheet" href="css/print.css" type="text/css" media="print" />  
		<!--[if lt IE 8]><link rel="stylesheet" href="css/ie.css" type="text/css" media="screen, projection" /><![endif]-->  
		<link rel="stylesheet" href="css/emgauge.css" type="text/css" media="screen" />  
		<title>Login</title>
    </head>
	<body>
		<div class="container">
			<div class="span-24 last">
				<div class="banner"></div>
			</div>
			<div class="prepend-7 span-10 append-7 last">
				<form  name="loginform" method="post" action="<!-- TMPL_VAR NAME=DESTINATION -->">
					<fieldset>
						<legend>Sign In</legend>
						<!-- TMPL_IF NAME=ATTEMPTS -->
						<p class="error">
							Username or Password is Incorrect. Please enter the Username and Password assigned to you by the Administrator.
							(Attempt #: <!-- TMPL_VAR NAME=ATTEMPTS -->)
						</p>
						<!-- /TMPL_IF -->
						<p>
							<label for="authen_username"><em>*</em> User Name:</label><br />
							<input tabindex="1" type="text" name="authen_username" size="20" value="" />
						</p>
						<p>
							<label for="authen_password"><em>*</em> Password:</label><br />
							<input tabindex="2" type="password" name="authen_password" size="20" />
						</p>
						<p>
							<label for="authen_rememberuser"><input tabindex="3" type="checkbox" name="authen_rememberuser" value="1" /> Remember Me</label>
						</p>
						<p>
							<input tabindex="4" type="submit" name="authen_loginbutton" value="Sign In" class="button" />
						</p>
					</fieldset>
					<input type="hidden" name="destination" value="<!-- TMPL_VAR NAME=DESTINATION -->" />
					<input type="hidden" name="rm" value="login" />
					<p><a href="user.cgi?rm=forgotpassword">Forgot Password?</a> | <a href="user.cgi?rm=register">Register</a></p>
				</form>
			</div> 
		</div>
	</body>
</html>