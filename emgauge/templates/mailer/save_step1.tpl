<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
		<link rel="stylesheet" href="css/screen.css" type="text/css" media="screen, projection" />  
		<link rel="stylesheet" href="css/print.css" type="text/css" media="print" />  
		<!--[if lt IE 8]><link rel="stylesheet" href="css/ie.css" type="text/css" media="screen, projection" /><![endif]-->  
		<link rel="stylesheet" href="css/emgauge.css" type="text/css" media="screen" />
		<title>Save Your Mailer - Step 1</title>
    </head>
	<body>
		<div class="container">
			<div class="span-24 last">
				<div class="banner"><!-- TMPL_INCLUDE NAME=default/bannermenu.tpl --></div>
			</div>
			<div class="prepend-3 span-18 append-3 last">
				<div class="step_tabs">
					<ul>
						<li><span>1</span> <div class="step_desc">Upload Zip or RAR File</div></li>
						<li id="current"><span>2</span> <div class="step_desc">Add Subject and Sender</div></li>
						<li><span>3</span> <div class="step_desc">Manage and Track Images</div></li>
						<li><span>4</span> <div class="step_desc">Manage and Track Links</div></li>
						<li><span>5</span> <div class="step_desc">Add File Attachment</div></li>
						<li><span>6</span> <div class="step_desc">Test, Save, Done!</div></li>
					</ul>
				</div>
			</div>
			<div class="prepend-3 span-18 append-3 last formholder">
				<div class="innerholder">
					<div class="prepend-1 span-9 append-1">
						<form  name="savestep1" method="post" action="mailer.cgi">
							<!-- TMPL_IF NAME=some_errors --><p class="error">Some fields were either invalid or missing. We have indicated the error next to each field</p><!-- /TMPL_IF -->
							<p>Fields marked with an asterisk (*) are required</p>
							<p>
								<label for="subject"><em>*</em> Subject Line: <!-- TMPL_VAR NAME=err_subject --></label><br />
								<input tabindex="1" id="subject" type="text" name="subject" length="40" value="<!-- TMPL_VAR NAME=subject -->" />
							</p>
							<p>
								<label for="sendername"><em>*</em> Sender's Name: <!-- TMPL_VAR NAME=err_sendername --></label><br />
								<input tabindex="2" id="sendername" type="text" name="sendername" length="40" value="<!-- TMPL_VAR NAME=sendername -->" />
							</p>
							<p>
								<label for="senderemail"><em>*</em> Sender's Email Address: <!-- TMPL_VAR NAME=err_senderemail --></label><br />
								<input tabindex="3" id="senderemail" type="text" name="senderemail" length="40" value="<!-- TMPL_VAR NAME=senderemail -->" />
							</p>
							<p>
								<label for="replyemail"> Reply-To Email:  <!-- TMPL_VAR NAME=err_replyemail --></label><br />
								<input tabindex="4" id="replyemail" type="text" name="replyemail" length="40" value="<!-- TMPL_VAR NAME=replyemail -->" />
							</p>
							<p>
								<input tabindex="5" type="submit" name="next" value="Next" />
							</p>
							<input type="hidden" name="rm" value="save_step2" />
							<input type="hidden" name="dfile" value="<!-- TMPL_VAR NAME=TMPDATAFILE -->" />
						</form>
					</div>
					<div class="span-6 append-1 last listentry">
						<h1><!-- TMPL_VAR NAME=MAILER --></h1>
						<h2>(For <!-- TMPL_VAR NAME=CAMPAIGN -->)</h2>
						<p><a href="<!-- TMPL_VAR NAME=MAILERLINK -->" target="_blank">Preview</a></p>
						<pre><!-- TMPL_VAR NAME=DUMPER --></pre>
						<p>Changed your mind? Want to Start Over from the beginning? <a href="mailer.cgi?rm=save_step0">Click here</a> </p>
					</div>
				</div>
			</div>
		</div>
	</body>
</html>