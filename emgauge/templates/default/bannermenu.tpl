<div id="authen_info">
	<p>
	<!-- TMPL_IF NAME=USERNAME -->
		User: <strong><!-- TMPL_VAR NAME=USERNAME --></strong> | 
		Logged On: <strong><!-- TMPL_VAR NAME=LASTLOGIN --></strong> |
		<a href="user.cgi?rm=changepassword">Change Password</a> | 
		<a href="mailer.cgi?authen_logout=1">Logout</a>
	<!-- TMPL_ELSE -->
		<a href="index.cgi?rm=login">Login</a>.
	<!-- /TMPL_IF -->
	</p>
</div>
