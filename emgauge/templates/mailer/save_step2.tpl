<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
		<link rel="stylesheet" href="css/screen.css" type="text/css" media="screen, projection" />  
		<link rel="stylesheet" href="css/print.css" type="text/css" media="print" />  
		<!--[if lt IE 8]><link rel="stylesheet" href="css/ie.css" type="text/css" media="screen, projection" /><![endif]-->  
		<link rel="stylesheet" href="css/emgauge.css" type="text/css" media="screen" />
		<script src="http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"></script>
		<script src="js/thumbnails.js"></script>
		<title>Save Your Mailer - Step 2</title>
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
						<li id="current"><span>3</span> <div class="step_desc">Manage and Track Images</div></li>
						<li><span>4</span> <div class="step_desc">Manage and Track Links</div></li>
						<li><span>5</span> <div class="step_desc">Add File Attachment</div></li>
						<li><span>6</span> <div class="step_desc">Test, Save, Done!</div></li>
					</ul>
				</div>
			</div>
			<div class="prepend-3 span-18 append-3 last formholder">
				<div class="innerholder">
					<div class="prepend-1 span-9 append-1 last">
						<form  name="savestep2" method="post" action="mailer.cgi">
							<table width="100%" border="0" cellspacing="0" cellpadding="0" class="images">
								<tr>
									<td colspan="4">
										<p>Select images that you would like to include with the mail.
										Images not included will be served from the server. Click on 
										Image links below to <strong>toggle</strong> a thumbnail of your Image.</p>
									</td>
								</tr>
								<tr>
									<th scope="col" width="6%">Inc?</th>
									<th scope="col">Image Path</th>
									<th scope="col">Size (B)</th>
									<th scope="col" width="10%">WxH</th>
								</tr>
								<!-- TMPL_LOOP NAME=imgs -->
								<!-- TMPL_IF NAME=found -->	
								<tr<!-- TMPL_IF NAME=__odd__ --> class="even"<!-- /TMPL_IF -->>
									<td><input type="checkbox" name="fileimg" value="<!-- TMPL_VAR NAME=__counter__ -->" <!-- TMPL_IF NAME=include -->checked="checked"<!-- /TMPL_IF --> /></td>
									<td>
										<a href="#" class="openup"><!-- TMPL_VAR NAME=src --></a> (<!-- TMPL_VAR NAME=count -->)
										<div class="thumbnail"><img src="<!-- TMPL_VAR NAME=thmburl -->" width="<!-- TMPL_VAR NAME=thmbw -->" height="<!-- TMPL_VAR NAME=thmbh -->" /></div>
									</td>
									<td><!-- TMPL_VAR NAME=size --></td>
									<td> <!-- TMPL_VAR NAME=width -->x<!-- TMPL_VAR NAME=height --></td>
								</tr>
								<!-- TMPL_ELSE -->
								<tr class="error">
									<td></td><td><!-- TMPL_VAR NAME=src --></td><td colspan="2">Missing. Add &amp; Re-upload</td>
								</tr>
								<!-- /TMPL_IF -->
								<!-- /TMPL_LOOP -->															
							</table>
							<p><input type="submit" name="next" value="Next" />
							</p>
							<input type="hidden" name="rm" value="save_step3" />
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