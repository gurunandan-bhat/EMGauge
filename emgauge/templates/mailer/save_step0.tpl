<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
		<link rel="stylesheet" href="css/screen.css" type="text/css" media="screen, projection" />  
		<link rel="stylesheet" href="css/print.css" type="text/css" media="print" />  
		<!--[if lt IE 8]><link rel="stylesheet" href="css/ie.css" type="text/css" media="screen, projection" /><![endif]-->  
		<link rel="stylesheet" href="css/emgauge.css" type="text/css" media="screen, projection" />
		<script src="http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"></script>
		<script type="text/javascript" src="js/jquery.validate.pack.js"></script>
		<script type="text/javascript" src="js/mailer_upload.js"></script>    
		<title>Create Mailer</title>
    </head>
	<body>
		<div class="container">
			<div class="span-24 last">
				<div class="banner"><!-- TMPL_INCLUDE NAME=default/bannermenu.tpl --></div>
			</div>
			<div class="prepend-3 span-18 append-3 last">
				<div class="step_tabs">
					<ul>
						<li id="current"><span>1</span> <div class="step_desc">Upload Zip or RAR File</div></li>
						<li><span>2</span> <div class="step_desc">Add Subject and Sender</div></li>
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
						<form enctype="multipart/form-data" id="metamailer" action="mailer.cgi" method="post">
							<!-- TMPL_IF NAME=some_errors --><p class="error">Some fields were either invalid or missing. We have indicated the error next to each field</p><!-- /TMPL_IF -->
							<p>
								<label for="mailer"><em>*</em> Mailer Name:</label><br />
								<input type="text" id="mailer" name="mailer" value="<!-- TMPL_VAR NAME=mailer -->" /><br />
								<!-- TMPL_VAR NAME=err_mailer -->
							</p>
							<div id="newcpgn">
								<p>
			                		<label for="campaign"><em>*</em> New Campaign:</label><br />
									<input type="text" id="campaign" name="campaign" value="<!-- TMPL_VAR NAME=campaign -->" /><br />
									<!-- TMPL_VAR NAME=err_cmpgn_id_or_name -->
									<span class="formhint">No. <a href="#">I want to add to an older Campaign</a></span>
								</p>
							</div>
							<div id="oldcpgn">
								<p>
									<label for="campaignid"><em>*</em> Campaign:</label><br />
									<select id="campaignid" name="campaignid">
										<option value="">Select Campaign...</option>
										<!-- TMPL_LOOP NAME=CAMPAIGNS -->
										<option value="<!-- TMPL_VAR NAME=CAMPAIGNID -->"><!-- TMPL_VAR NAME=CAMPAIGN --></option>
										<!-- /TMPL_LOOP -->
									</select><br />
									<!-- TMPL_VAR NAME=err_cmpgn_id_or_name --><br />
									<span class="formhint">Not in this List? <a href="#">Create a New Campaign</a></span>
								</p>
							</div>
							<p>
								<label for="zipfile"><em>*</em> Add Zip File: </label><br />
								<input type="file" name="zipfile" id="zipfile" /><br />
								<!-- TMPL_VAR NAME=err_zipfile --><br />
							</p>
							<p class="buttonContainer">
								<input type="reset" value="Reset" />
								<input type="submit" name="upload" value="Upload" /><!--src="images/upload.gif" -->
							</p>
							<input type="hidden" name="rm" value="save_step1" />
						</form>
					</div>
					<div class="span-6 append-1 last">
					</div>
				</div>
			</div>
		</div>
	</body>
</html>
