<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
		<link rel="stylesheet" href="css/screen.css" type="text/css" media="screen, projection" />  
		<link rel="stylesheet" href="css/print.css" type="text/css" media="print" />  
		<!--[if lt IE 8]><link rel="stylesheet" href="css/ie.css" type="text/css" media="screen, projection" /><![endif]-->  
		<link rel="stylesheet" href="css/emgauge.css" type="text/css" media="screen, projection" />
		<title>Create List</title>
    </head>
	<body>
		<div class="container">
			<div class="span-24 banner last">
				<div class="banner"><!-- TMPL_INCLUDE NAME=default/bannermenu.tpl --></div>
			</div>
			<div class="span-24 last">
				<!-- TMPL_INCLUDE NAME=recipient_header.tpl -->
			</div>
			<div class="prepend-7 span-10 append-1">
				<h1 class="sectionhead">Recent Lists</h1>
				<!-- TMPL_LOOP NAME=LISTS -->
				<div class="listentry<!-- TMPL_IF NAME=__odd__ --> odd<!-- /TMPL_IF -->">
					<h1><!-- TMPL_VAR NAME=LISTNAME --></h1>
					<h2>Records: <!-- TMPL_VAR NAME=LISTRECORDS -->; Source: <!-- TMPL_VAR NAME=LISTSOURCE -->; Created: <!-- TMPL_VAR NAME=LISTCREATEDON --></h2>
					<p>
						<a href="data.cgi?rm=download_list&list=<!-- TMPL_VAR NAME=LISTID -->">Download</a> |
						<a href="data.cgi?rm=delete_list&list=<!-- TMPL_VAR NAME=LISTID -->">Delete</a>
					</p>
				</div>
				<hr />
				<!-- /TMPL_LOOP -->
				<!-- TMPL_VAR NAME=PAGENAV -->
				<!-- TMPL_UNLESS NAME=LISTS -->
				<p>
					You have not created lists yet.<br /><a href="data.cgi?rm=save_step0">Click here</a> to create a new recipient list from an Excel sheet 
				</p>
				<!-- /TMPL_UNLESS -->
			</div>
			<div class="span-6 last">
				<!-- TMPL_INCLUDE NAME=default/task_list.tpl -->
			</div>
		</div>
	</body>
</html>
