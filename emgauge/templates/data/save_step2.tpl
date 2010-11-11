<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
		<link rel="stylesheet" href="css/screen.css" type="text/css" media="screen, projection" />  
		<link rel="stylesheet" href="css/print.css" type="text/css" media="print" />  
		<!--[if lt IE 8]><link rel="stylesheet" href="css/ie.css" type="text/css" media="screen, projection" /><![endif]-->  
		<link type="text/css" href="css/ui-lightness/jquery-ui-1.8rc3.custom.css" rel="stylesheet" />	
		<link rel="stylesheet" href="css/emgauge.css" type="text/css" media="screen, projection" />
		<script src="http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"></script>
 		<script type="text/javascript" src="js/jquery.validate.pack.js"></script>
		<script type="text/javascript" src="js/jquery-ui-1.8rc3.pbar.min.js"></script>    
		<script type="text/javascript" src="js/xlwatch.js"></script>    
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
						<li><span>1</span> <div class="step_desc">Upload an Excel Sheet</div></li>
						<li><span>2</span> <div class="step_desc">Map Excel Columns</div></li>
						<li id="current"><span>3</span> <div class="step_desc">Track Progress</div></li>
					</ul>
				</div>
			</div>
			<div class="prepend-3 span-18 append-3 last formholder">
				<div class="innerholder">
					<div class="prepend-1 span-9 append-1">
						<h2>Uploads in Progress </h2>
						<!-- TMPL_IF NAME=WATCHSHEETID -->
						<p>
							<strong><!-- TMPL_VAR NAME=WATCHSHEET --></strong><br/>
							Upload Started on: <!-- TMPL_VAR NAME=WATCHSTARTTIME -->
						</p>
						<div id="watchdetail">
							<table class="notice" cellspacing="0" cellpadding="0" listid="<!-- TMPL_VAR NAME=WATCHSHEETID -->" border="0">
								<tr><td colspan="2"><div id="goodbar"></div></td></tr>
								<tr>
									<td>Rows to be Imported:</td>
									<td style="text-align: right;"><!-- TMPL_VAR NAME=WATCHROWS --></td>
								</tr>
								<tr>
									<td>Rows Completed:</td>
									<td id="donerows" style="text-align: right;"><!-- TMPL_VAR NAME=WATCHDONE --></td>
								</tr>
								<tr>
									<td>Percentage Completed:</td>
									<td id="donepercent" style="text-align: right;"><!-- TMPL_VAR NAME=WATCHPERCENT --></td>
								</tr>
							</table>
						</div>
					</div>
					<div class="span-6 append-1 last">
						<h2>Something Useful Here</h2>
					</div>
				</div>
			</div>
		</div>
	</body>
</html>
