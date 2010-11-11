<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
		<link rel="stylesheet" href="css/screen.css" type="text/css" media="screen, projection" />  
		<link rel="stylesheet" href="css/print.css" type="text/css" media="print" />  
		<!--[if lt IE 8]><link rel="stylesheet" href="css/ie.css" type="text/css" media="screen, projection" /><![endif]-->  
		<link rel="stylesheet" href="css/emgauge.css" type="text/css" media="screen" />
		<title>Save Your Mailer - Step 3</title>
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
						<li><span>3</span> <div class="step_desc">Manage and Track Images</div></li>
						<li id="current"><span>4</span> <div class="step_desc">Manage and Track Links</div></li>
						<li><span>5</span> <div class="step_desc">Add File Attachment</div></li>
						<li><span>6</span> <div class="step_desc">Test, Save, Done!</div></li>
					</ul>
				</div>
			</div>
			<div class="prepend-3 span-18 append-3 last formholder">
				<div class="innerholder">
					<div class="prepend-1 span-9 append-1 last">
						<form  name="savestep3" method="post" action="mailer.cgi">
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
							<p><input type="submit" name="next" value="Next" />
							</p>
							<input type="hidden" name="rm" value="save_step4" />
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