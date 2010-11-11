<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
		<link rel="stylesheet" href="css/screen.css" type="text/css" media="screen, projection" />  
		<link rel="stylesheet" href="css/print.css" type="text/css" media="print" />  
		<!--[if lt IE 8]><link rel="stylesheet" href="css/ie.css" type="text/css" media="screen, projection" /><![endif]-->  
		<link rel="stylesheet" href="css/emgauge.css" type="text/css" media="screen, projection" />
		<title>Mailer Dashboard</title>
    </head>
	<body>
		<div class="container">
			<div class="span-24 last">
				<div class="banner"><!-- TMPL_INCLUDE NAME=default/bannermenu.tpl --></div>
			</div>
			<div class="span-16">
				<h1 class="sectionhead">Delivery and Reach Status</h1>
				<table>
					<tr><th colspan="8">Click on a Mailer Name to Download Comments for that Mailer.</th></tr>
				</table>
				<table>
					<tr class="title">
						<th>Mailer</th>
						<th class="numeric">Schedules</th>
						<th class="numeric">Scheduled</th>
						<th class="numeric">Delivered</th>
						<th class="numeric">Bounced</th>
						<th class="numeric">Opened</th>
						<th class="numeric">Clicked</th>
					</tr>
					<!-- TMPL_LOOP NAME=REPORTS -->
					<tr<!-- TMPL_IF NAME=__odd__ --> class="odd"<!-- /TMPL_IF -->>
						<td><!-- TMPL_VAR NAME=NAME --></td>
						<td class="numeric"><!-- TMPL_VAR NAME=SCHEDULES --></td>
						<td class="numeric"><!-- TMPL_VAR NAME=SCHEDULED --></td>
						<td class="numeric"><!-- TMPL_VAR NAME=DELIVERED --></td>
						<td class="numeric"><!-- TMPL_VAR NAME=BOUNCED --></td>
						<td class="numeric"><!-- TMPL_VAR NAME=OPENED --></td>
						<td class="numeric"><!-- TMPL_VAR NAME=CLICKED --></td>
					</tr>
					<!-- /TMPL_LOOP -->
				</table>
				<!-- TMPL_VAR NAME=PAGENAV -->
			</div>
			<div class="span-8 last">
			</div>			
		</div>
	</body>
</html>
