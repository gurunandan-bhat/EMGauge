<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
		<link rel="stylesheet" href="css/screen.css" type="text/css" media="screen, projection" />  
		<link rel="stylesheet" href="css/print.css" type="text/css" media="print" />  
		<!--[if lt IE 8]><link rel="stylesheet" href="css/ie.css" type="text/css" media="screen, projection" /><![endif]-->  
		<link rel="stylesheet" href="css/emgauge.css" type="text/css" media="screen" />
		<title>Save Your Mailer - Step 4</title>
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
						<li><span>2</span> <div class="step_desc">Add Subject and Sender</div></li>
						<li><span>3</span> <div class="step_desc">Manage and Track Images</div></li>
						<li><span>4</span> <div class="step_desc">Manage and Track Links</div></li>
						<li id="current"><span>5</span> <div class="step_desc">Add File Attachment</div></li>
						<li><span>6</span> <div class="step_desc">Test, Save, Done!</div></li>
					</ul>
				</div>
			</div>
			<div class="prepend-3 span-18 append-3 last formholder">
				<div class="innerholder">
					<div class="prepend-1 span-9 append-1 last">
						<form  name="savestep4" enctype="multipart/form-data" method="post" action="mailer.cgi">
							<p>
								Add Files that you would like sent along with your Mailer.<br />
								Remember that each attachment increases the size of your mailer 
								significantly and increases the chances of your mailer being 
								marked as "Junk" by recipients.
							</p>
							<p>
								<label for="attachment">Add An Attachment:</label><br />
								<input type="file" name="attachment" id="attachment" />
							</p>
							<p><input type="submit" name="next" value="Next" />
							</p>
							<input type="hidden" name="rm" value="save_step5" />
							<input id="dfile" type="hidden" name="dfile" value="<!-- TMPL_VAR NAME=TMPDATAFILE -->" />
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