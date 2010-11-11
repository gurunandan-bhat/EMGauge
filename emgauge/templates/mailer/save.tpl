<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
		<link rel="stylesheet" href="css/screen.css" type="text/css" media="screen, projection" />  
		<link rel="stylesheet" href="css/print.css" type="text/css" media="print" />  
		<!--[if lt IE 8]><link rel="stylesheet" href="css/ie.css" type="text/css" media="screen, projection" /><![endif]-->  
		<link rel="stylesheet" href="css/emgauge.css" type="text/css" media="screen, projection" />
		<script type="text/javascript" src="js/jquery-1.3.2.min.js"></script>		 		
		<script type="text/javascript" src="js/jquery.validate.pack.js"></script>
		<script type="text/javascript" src="js/test_mail.js"></script>
		<title>View Mailer Details</title>
    </head>
	<body>
		<div class="container">
			<div class="span-24 last">
				<div class="banner"><!-- TMPL_INCLUDE NAME=default/mailer_header.tpl --></div>
			</div>
			<div class="span-24 heading">
				<h1>Add a New Mailer to <!-- TMPL_VAR NAME=CAMPAIGN --></h1>
			</div>
			<form enctype="multipart/form-data" id="metamailer" action="index.cgi" method="post">
				<div class="span-24 gradient">
				<div class="span-8 border">
					<fieldset class="blank">
						<legend>1. Describe your Mailer</legend>
						<p>
							<label for="mailer"><em>*</em> Mailer Name:</label><br />
							<input type="text" id="mailer" name="mailer" value="<!-- TMPL_VAR NAME=MAILER -->" />
						</p>
						<div id="oldcpgn">
							<p>
								<label for="campaignid"><em>*</em> Campaign</label> <br />
								<!-- TMPL_IF NAME=CAMPAIGNID -->
								<select id="campaignid" name="campaignid">
									<option value="">Select Campaign...</option>
									<!-- TMPL_LOOP NAME=CAMPAIGNS -->
									<option value="<!-- TMPL_VAR NAME=CAMPAIGNID -->" <!-- TMPL_IF NAME=CAMPAIGNSELECTED -->selected="selected"<!-- /TMPL_IF -->><!-- TMPL_VAR NAME=CAMPAIGN --></option>
									<!-- /TMPL_LOOP -->
								</select>
								<!-- TMPL_ELSE -->
								<label for="campaign"><em>*</em>New Campaign</label> <br />
								<input type="text" name="campaign" id="campaign" value="<!-- TMPL_VAR NAME=CAMPAIGN -->" />
								<!-- /TMPL_IF -->
							</p>
						</div>
						<p>
							<label for="subject"><em>*</em> Subject:</label><br />
							<input class="textInput" type="text" name="subject" id="subject" value="<!-- TMPL_VAR NAME=SUBJECT -->" />
						</p>
					</fieldset>
				</div>
				<div class="span-8 border">
					<fieldset class="blank">
						<legend>2. Sender Details</legend>
						<p>
							<label for="sendername"><em>*</em> Sender's Name:</label><br />
							<input type="text" name="sendername" id="sendername" value="<!-- TMPL_VAR NAME=SENDERNAME -->" />
						</p>
						<p>
							<label for="senderemail"><em>*</em> Sender's E-mail:</label><br />
							<input type="text" name="senderemail" id="senderemail" value="<!-- TMPL_VAR NAME=SENDEREMAIL -->" />
						</p>
						<p>
							<label for="replyto">Reply-to E-mail:</label><br />
							<input type="text" name="replyto" id="replyto" value="<!-- TMPL_VAR NAME=REPLYTOEMAIL -->" />
						</p>
					</fieldset>
				</div>
				<div class="span-8 last">
					<fieldset class="blank">
						<legend>3. Do You Want to Test Your Mailer?</legend>
						<p>To test, add an email address and click on "Test it". This Test is provided to check Mailer rendering in different clients. 
						No files (if any specified) will be attached to the test mail.</p> 
						<p id="mailthrobber">Your mail is being delivered. Please wait...</p>
						<p class="success" id="mailstatus"></p>
						<p>
							<label for="testrecipient">Send a Test Mail to:</label><br />
							<input type=text name="testrecipient" id="testrecipient" />
						</p>
						<p class="buttonContainer">
							<input id="testit" class="primaryAction" type="submit" name="testit" value="Test It!" />
						</p>
						<input id="dfile" type="hidden" name="dfile" value="<!-- TMPL_VAR NAME=TMPDATAFILE -->" />
					</fieldset>
				</div>
				</div>
				<hr />
				<div class="prepend-8 span-8">
					<p class="buttonContainer">
						<input type="reset" value="Reset" />
						<input type="submit" value="<!-- TMPL_VAR NAME=BUTTON -->" /><!-- src="images/save_changes.gif" -->
					</p>
				</div>
				<div class="span-8 last">
					<p class="collapsed-state"><a href="#" id="linkContainer">Advanced Settings</a></p>
				</div>
				<!-- TMPL_LOOP NAME=HTMLFILES -->
				<div id="advSetContainer">
					<div class="grid_bg">
						<div class="span-8 heading">
							<h1>Customizations</h1>
							<fieldset>
								<legend>Attachments:</legend>
								<p>You can upload a File that will be delivered as an Attachment. Please note that the attachment increases the size of the
								email substantially. This may result in an extremely long delivery schedule. Use with discretion</p>
								<p>
									<label for="attachment">Add An Attachment:</label><br />
									<input type="file" name="attachment" id="attachment" />
								</p>
							</fieldset>
							<hr />
							<p><strong>Mail-Merge Variables:</strong></p>
							<!-- TMPL_IF NAME=tplvars -->
							<p>Your Mailer contains the following Parameters that will be substituted from the Database:</p>
							<ul>
								<!-- TMPL_LOOP NAME=tplvars -->
								<li><!-- TMPL_VAR NAME=tplvar --></li>
								<!-- /TMPL_LOOP -->
							</ul>
							<!-- TMPL_ELSE -->
							<p>Your Mailer does not contain any Mail Merge Parameters. No Customization will be carried out. If you want to add customized 
							parameters like "Full Name", "Company Name" etc. please save this mailer and re-edit it to add Custom variables</p>
							<!-- /TMPL_IF -->
							<hr />
							<p class="label"><strong>Auto-add Standard Links:</strong></p>
							<label for="forward"><input type="checkbox" name="forward" id="forward" checked="checked" />Forward to a friend</label><br />
							<label for="unsubscribe"><input type="checkbox" name="unsubscribe" id="unsubscribe" checked="checked" />Unsubscribe</label><br />
							<label for="subscribe"><input type="checkbox" name="subscribe" id="subscribe" checked="checked" />Subscribe</label><br />
							<label for="readlive"><input type="checkbox" name="readlive" id="readlive" checked="checked" />Read Online Version</label><br />
						</div>
						<div class="span-8 heading">
							<h1>Images</h1>
							<table width="98%" border="0" cellspacing="0" cellpadding="0" class="images">
								<tr>
									<td colspan="4">
										<p><strong>Mailer File: </strong><a href="<!-- TMPL_VAR NAME=relpath -->" target="_blank"><!-- TMPL_VAR NAME=name --></a></p>
										<p>Select images that you would like to include with the mail.
										Images not included will be served from the server. Click on 
										Image links below to <strong>toggle</strong> a thumbnail of your Image.<br />
										<a href="<!-- TMPL_VAR NAME=relpath -->" target="_blank">Preview</a></p>
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
						</div>
						<div class="span-8 heading last">
							<h1>Links</h1>
							<table width="98%" border="0" cellspacing="0" cellpadding="0">
							<!-- TMPL_IF NAME=lnks -->
								<tr>
									<td colspan="2">
										<p>Select links that you would like to track in your analytics 
										dashboard. Click on any link to preview (opens in a separate window)</p>
									</td>
								</tr>
								<tr>
									<th scope="col" width="6%">Track?</th><th scope="col">URL</th>
								</tr>
								<!-- TMPL_LOOP NAME=lnks -->
								<tr<!-- TMPL_IF NAME=__odd__ --> class="even"<!-- /TMPL_IF -->>
									<td>
										<!-- TMPL_IF NAME=show --><input type="checkbox" name="filelnk" value="<!-- TMPL_VAR NAME=__counter__ -->" <!-- TMPL_IF NAME=track -->checked="checked"<!-- /TMPL_IF --> /><!-- /TMPL_IF -->
									</td>
									<td>
										<a href="<!-- TMPL_VAR NAME=myhref -->" target="_blank"><!-- TMPL_VAR NAME=href --></a>
									</td>
								</tr>
								<!-- /TMPL_LOOP -->
								<!-- TMPL_ELSE -->
								<tr>
									<td colspan="2">
										<p>There are no outbound links in your Mailer.</p><p class="notice">Please note that if you have 
										selected to add a link to an online version of this mailer (Auto-add Links in the first panel), they 
										will be tracked separately.<br /><br />If you have not checked it, please consider adding a link 
										to track clickthroughs.</p>
									</td>
								</tr>
							<!-- /TMPL_IF -->
							</table>
						</div>
					</div>
				<!-- /TMPL_LOOP -->
					<div class="span-24 last">
						<p class="buttonContainer">
							<input class="resetButton" type="reset" value="Reset" />
							<input class="primaryAction" type="submit" value="<!-- TMPL_VAR NAME=BUTTON -->" /><!-- src="images/save_changes.gif" -->
							
						</p>
					</div>
				</div>
				<input type="hidden" name="rm" value="<!-- TMPL_VAR NAME=MODE -->" />
				<!-- TMPL_IF NAME=MAILERID --><input type="hidden" name="mailerid" value="<!-- TMPL_VAR NAME=MAILERID -->" /><!-- /TMPL_IF -->
			</form>
		</div>
	</body>
</html>
