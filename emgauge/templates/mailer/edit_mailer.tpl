<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
		<link rel="stylesheet" href="css/screen.css" type="text/css" media="screen, projection" />  
		<link rel="stylesheet" href="css/print.css" type="text/css" media="print" />  
		<!--[if lt IE 8]><link rel="stylesheet" href="css/ie.css" type="text/css" media="screen, projection" /><![endif]-->  
		<link rel="stylesheet" href="css/emgauge.css" type="text/css" media="screen, projection" />
		<script src="http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"></script>
		<script type="text/javascript" src="js/ckeditor/ckeditor.js"></script>
		<script type="text/javascript" src="js/ckeditor/adapters/jquery.js"></script>
		<script type="text/javascript">
			$(document).ready(function() {
				$('#ckeditor1').ckeditor(
					function() {}, {
					height: '800px',
					baseHref: '<!-- TMPL_VAR NAME=MAILERBASEHREF -->',
					fullPage: true
				});
			});
		</script>
		<title>Create Mailer</title>
    </head>
	<body>
		<div class="container">
			<div class="span-24 last">
				<div class="banner"><!-- TMPL_INCLUDE NAME=default/bannermenu.tpl --></div>
			</div>
			<div class="prepend-3 span-18 append-3 last">
				<h1>Edit <!-- TMPL_VAR NAME=MAILERNAME --></h1>
				<form action="mailer.cgi" method="post">
					<div><textarea id="ckeditor1" name="ckeditor1" style="width: 100%;"><!-- TMPL_VAR NAME=MAILERCONTENT --></textarea></div>
					<input type="hidden" name="rm" value="save_edited_mailer" />
					<input type="hidden" name="mailerid" value="<!-- TMPL_VAR NAME=MAILERID -->" />
				</form>
			</div>
		</div>
	</body>
</html>
