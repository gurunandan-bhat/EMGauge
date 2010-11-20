<form enctype="multipart/form-data" id="metamailer" action="mailer.cgi" method="post">
<!-- TMPL_IF NAME=some_errors --><p class="error">Some fields are invalid or missing. These are indicated next to fields</p><!-- /TMPL_IF -->
	<fieldset>
		<legend>Edit Attributes for <span style="font-variant: small-caps;"><!-- TMPL_VAR NAME=name --></span></legend>
		<table width="100%">
			<tr>
				<td>
					<label for="name"><em>*</em> Mailer Name <!-- TMPL_VAR NAME=err_name --></label><br />
					<input type="text" id="name" name="name" value="<!-- TMPL_VAR NAME=name -->" />
				</td>
				<td>
					<label for="subject"><em>*</em> Subject Line <!-- TMPL_VAR NAME=err_subject --></label><br />
					<input tabindex="1" id="subject" type="text" name="subject" length="40" value="<!-- TMPL_VAR NAME=subject -->" />
				</td>
			</tr>
			<tr>
				<td>
					<label for="sendername"><em>*</em> Sender's Name <!-- TMPL_VAR NAME=err_sendername --></label><br />
					<input tabindex="2" id="sendername" type="text" name="sendername" length="40" value="<!-- TMPL_VAR NAME=sendername -->" />
				</td>
				<td>
					<label for="senderemail"><em>*</em> Sender's Email <!-- TMPL_VAR NAME=err_senderemail --></label><br />
					<input tabindex="3" id="senderemail" type="text" name="senderemail" length="40" value="<!-- TMPL_VAR NAME=senderemail -->" />
				</td>
			</tr>
		</table>
		<!-- TMPL_IF NAME=imgs -->
		<table width="100%" border="0" cellspacing="0" cellpadding="0" class="images">
			<tr>
				<td colspan="4">
					<strong>Select images to include with the mail. Click to view.</strong>
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
					<td><input type="checkbox" name="img" value="<!-- TMPL_VAR NAME=imgid -->" <!-- TMPL_IF NAME=include -->checked="checked"<!-- /TMPL_IF --> /></td>
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
		<!-- TMPL_ELSE -->												
			<p class="error">There are no images in your Mailer!</p>
		<!-- /TMPL_IF -->
		<!-- TMPL_IF NAME=lnks -->
		<table width="98%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td colspan="2">
					<strong>Select links to track. Click to test.</strong>
				</td>
			</tr>
			<tr>
				<th scope="col" width="6%">Track?</th><th scope="col">URL</th>
			</tr>
			<!-- TMPL_LOOP NAME=lnks -->
			<tr<!-- TMPL_IF NAME=__odd__ --> class="even"<!-- /TMPL_IF -->>
				<td>
					<input type="checkbox" name="lnk" value="<!-- TMPL_VAR NAME=lnkid -->" <!-- TMPL_IF NAME=track -->checked="checked"<!-- /TMPL_IF --> />
				</td>
				<td>
					<a href="<!-- TMPL_VAR NAME=href -->" target="_blank"><!-- TMPL_VAR NAME=href --></a>
				</td>
			</tr>
			<!-- /TMPL_LOOP -->
		</table>
		<!-- TMPL_ELSE -->
		<p class="error">There are no outbound links in your Mailer.</p>
		<!-- /TMPL_IF -->
		<input type="hidden" name="rm" value="save_meta_edited_mailer" />
		<input type="hidden" name="mailerid" value="<!-- TMPL_VAR NAME=mailerid -->" />
		<p style="text-align: center;"><input type="submit" name="resave" value="Save" /></p>
	</fieldset>
</form>
