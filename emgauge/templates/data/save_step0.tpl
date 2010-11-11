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
		<script type="text/javascript" src="js/jquery.progressbar.min.js"></script>    
		<script type="text/javascript" src="js/list_upload.js"></script>    
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
						<li id="current"><span>1</span> <div class="step_desc">Upload an Excel Sheet</div></li>
						<li><span>2</span> <div class="step_desc">Map Excel Columns</div></li>
						<li><span>3</span> <div class="step_desc">Track Progress</div></li>
					</ul>
				</div>
			</div>
			<div class="prepend-3 span-18 append-3 last formholder">
				<div class="innerholder">
					<div class="prepend-1 span-9 append-1">
						<form action="data.cgi" method="post" enctype="multipart/form-data"  id="metalist">
							<!-- TMPL_IF NAME=some_errors -->
							<p class="error">
								Some fields were either invalid or missing. 
								We have indicated the error next to each field
							</p>
							<!-- /TMPL_IF -->
							<p>Import data from a Spreadsheet and create a new List or add data in the spreadsheet to an existing list </p>
							<div id="newlist">			
								<p>
									<label for="list"><em>*</em> Create a New List:</label> <!-- TMPL_VAR NAME=err_listid_or_name --><br />
									<input class="textInput" type="text" id="list" name="list" value="<!-- TMPL_VAR NAME=list -->" /><br />
									<span class="formHint">No. <a href="#">Add to an existing List</a></span>
								</p>
								<p>
									<label for="listsrc">Source:</label> <!-- TMPL_VAR NAME=err_listsrc --><br />
									<textarea type="text" id="listsrc" name="listsrc" rows="4"><!-- TMPL_VAR NAME=listsrc --></textarea><br />
								</p>
							</div>					
							<div id="oldlist">
								<p>
									<label for="listid">Add Recipients to an earlier List:</label> <!-- TMPL_VAR NAME=err_listid_or_name --><br />
									<select id="listid" name="listid">
										<option value="0" selected="selected">Select List...</option>
										<!-- TMPL_LOOP NAME=ALLLISTS -->
										<option value="<!-- TMPL_VAR NAME=LISTID -->"><!-- TMPL_VAR NAME=LISTNAME --></option>
										<!-- /TMPL_LOOP -->
									</select><br />
									<span class="formHint">Not here? <a href="#">Create a New List</a></span>
								</p>
							</div>
							<p>
								<label for="datafile">Select a Spreadsheet: </label> <!-- TMPL_VAR NAME=err_datafile --><br />
								<input type="file" name="datafile" id="datafile" /><br />
								
							</p>
							<p class="buttonContainer">
								<input type="reset" name="reset" value="Reset"/>
								<input type="submit" name="upload" value="Upload"/>
								<input type="hidden" name="rm" value="save_step1" />
							</p>
						</form>
					</div>
					<div class="span-6 append-1 last">
						<h2>Uploads in Progress </h2>
						<!-- TMPL_IF NAME=WATCHSHEETID -->
						<p><strong><!-- TMPL_VAR NAME=WATCHSHEET --></strong></p>
						<div id="goodbar"></div>
						<p><a href="#" id="showdetail">Show Details</a></p>
						<div id="watchdetail">
							<table class="notice" cellspacing="0" cellpadding="0" listid="<!-- TMPL_VAR NAME=WATCHSHEETID -->">
								<tr>
									<td>Rows to be Imported:</td>
									<td><!-- TMPL_VAR NAME=WATCHROWS --></td>
								</tr>
								<tr>
									<td>Rows Completed:</td>
									<td id="donerows"><!-- TMPL_VAR NAME=WATCHDONE --></td>
								</tr>
								<tr>
									<td>Percentage Completed:</td>
									<td id="donepercent"><!-- TMPL_VAR NAME=WATCHPERCENT --></td>
								</tr>
							</table>
						</div>
						<!-- /TMPL_IF -->
					</div>
				</div>
			</div>
		</div>
	</body>
</html>
