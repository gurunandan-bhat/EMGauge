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
		<script type="text/javascript" src="js/landingpage_upload.js"></script>    
		<title>Create Landing Page</title>
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
					</ul>
				</div>
			</div>
			<div class="prepend-3 span-18 append-3 last formholder">
				<div class="innerholder">
					<div class="prepend-1 span-9 append-1">
						<form enctype="multipart/form-data" id="metamailer" action="mailer.cgi" method="post">
							<!-- TMPL_IF NAME=some_errors --><p class="error">Some fields were either invalid or missing. We have indicated the error next to each field</p><!-- /TMPL_IF -->
							<p>
								<label for="mailer">Create a Landing Page for:</label><br />
								<input type="text" id="mailername" name="mailername" value="<!-- TMPL_VAR NAME=MAILERNAME -->" readonly="readonly" /><br />
							</p>
							<p>
								<label for="zipfile"><em>*</em> Add Zip File: </label><br />
								<input type="file" name="zipfile" id="zipfile" /><br />
								<!-- TMPL_VAR NAME=err_zipfile --><br />
							</p>
							<p class="buttonContainer">
								<input type="reset" value="Reset" />
								<input type="submit" name="upload" value="Upload" />
							</p>
							<input type="hidden" name="rm" value="save_landingpage" />
							<input type="hidden" name="mailerid" value="<!-- TMPL_VAR NAME=MAILERID -->" />
						</form>
					</div>
					<div class="span-6 append-1 last">
					</div>
				</div>
			</div>
		</div>
	</body>
</html>
