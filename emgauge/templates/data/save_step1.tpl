<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
		<link rel="stylesheet" href="css/screen.css" type="text/css" media="screen, projection" />  
		<link rel="stylesheet" href="css/print.css" type="text/css" media="print" />  
		<!--[if lt IE 8]><link rel="stylesheet" href="css/ie.css" type="text/css" media="screen, projection" /><![endif]-->  
		<link rel="stylesheet" href="css/emgauge.css" type="text/css" media="screen, projection" />
		<link rel="stylesheet" href="css/edmanage_validate.css" type="text/css" media="screen, projection" />
		<link type="text/css" media="screen" rel="stylesheet" href="css/colorbox.css" />
		<script src="http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"></script>
		<script type="text/javascript" src="js/jquery.colorbox-min.js"></script>		 		
		<script type="text/javascript" src="js/show_sample_data.js"></script>		 		
		<script type="text/javascript" src="js/map_lists.js"></script>
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
						<li id="current"><span>2</span> <div class="step_desc">Map Excel Columns</div></li>
						<li><span>3</span> <div class="step_desc">Track Progress</div></li>
					</ul>
				</div>
			</div>
		</div>
		<form id="metamailer" action="data.cgi" method="post" >
			<!-- TMPL_LOOP NAME=METAXL -->
			<div class="container">
				<div class="prepend-3 span-18 append-3 last formholder">
					<div class="innerholder">
						<div class="prepend-1 span-9 append-1">
							<fieldset>
								<legend>Worksheet <!-- TMPL_VAR NAME=sheetnum -->: <!-- TMPL_VAR NAME=name --></legend>
								<p>
									<strong>There are <!-- TMPL_VAR NAME=totrows --> Rows in this Worksheet.</strong><br />
									Choose a Database field for each column in your Worksheet(s).<br />
									<a id="link<!-- TMPL_VAR NAME=sheetnum -->" href="#">First <!-- TMPL_VAR NAME=DISPROWS --> rows of this Worksheet</a>
								</p>
								<table width="99%" cellspacing="0" cellpadding="0">
									<tr><th>Your Columns</th><th>Database Fileds</th></tr>
									<!-- TMPL_LOOP NAME=headers -->
									<tr>
										<td><!-- TMPL_VAR NAME=colname --></td>
										<td>
											<select id="<!-- TMPL_VAR NAME=colname -->_<!-- TMPL_VAR NAME=dsetnum -->" name="group[<!-- TMPL_VAR NAME=dsetnum -->]">
												<!-- TMPL_VAR NAME=LISTOPTS -->
											</select>
										</td>
									</tr>
									<!-- /TMPL_LOOP -->
								</table>
							</fieldset>
						</div>
						<div class="span-6 append-1 last listentry">
							<h1>Importing into List "<!-- TMPL_VAR NAME=LIST -->"</h1>
							<h2>Worksheet <!-- TMPL_VAR NAME=sheetnum --> of <!-- TMPL_VAR NAME=SHEETS -->: <!-- TMPL_VAR NAME=name --><br /> Rows: <!-- TMPL_VAR NAME=totrows --></h2>
						</div>
					</div>
				</div>
			</div>
			<div style="display: none">
				<div id="datasample<!-- TMPL_VAR NAME=sheetnum -->">
					<h2>Sample from <!-- TMPL_VAR NAME=name --> (First <!-- TMPL_VAR NAME=DISPROWS --> Rows)</h2>
					<table width="99%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<!-- TMPL_LOOP NAME=headers -->
							<th><!-- TMPL_VAR NAME=colname --></th>
							<!-- /TMPL_LOOP -->
						</tr>
						<!-- TMPL_LOOP NAME=rows -->
						<tr<!-- TMPL_IF NAME=__odd__ --> class="even"<!-- /TMPL_IF -->>
							<!-- TMPL_LOOP NAME=cols -->
								<td><!-- TMPL_VAR NAME=value --></td>
							<!-- /TMPL_LOOP -->
						</tr>
						<!-- /TMPL_LOOP -->
					</table>
				</div>
			</div>
			<input type="hidden" name="sheetrows" value="<!-- TMPL_VAR NAME=totrows -->" />
			<!-- /TMPL_LOOP -->
			<div class="container">
				<div class="prepend-7 span-10 append-7 last">
					<p class="buttonContainer" style="text-align: center; margin-top: 10px">
						<input class="resetButton" type="reset" value="Reset"/>
						<input class="primaryAction" type="submit" id="list_submit" value="Save Data" />
					</p>
				</div>
			</div>
			<input type="hidden" name="xlname" value="<!-- TMPL_VAR NAME=XLFNAME -->" />
			<input type="hidden" name="listname" value="<!-- TMPL_VAR NAME=LIST -->" />
			<input type="hidden" name="listid" value="<!-- TMPL_VAR NAME=LISTID -->" />
			<input type="hidden" name="listsrc" value="<!-- TMPL_VAR NAME=LISTSRC -->" />
			<input id="listsheets" type="hidden" name="sheets" value="<!-- TMPL_VAR NAME=SHEETS -->" />
			<input type="hidden" name="rm" value="save_step2" />
		</form>
	</body>
</html>
