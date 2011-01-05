<!-- TMPL_IF NAME=rows -->
<!-- TMPL_LOOP NAME=clicks -->
<tr class="highlight">
	<td colspan="5">
		Clicks on <a href="<!-- TMPL_VAR NAME=href -->" title="<!-- TMPL_VAR NAME=title --> <!-- TMPL_VAR NAME=href -->" target="_blank">Link <!-- TMPL_VAR NAME=__counter__ --></a>
		(Hover to view URL. Click to visit)
	</td>
	<td><!-- TMPL_VAR NAME=hits --></td>
</tr>
<!-- /TMPL_LOOP -->
<!-- TMPL_ELSE -->
<tr>
	<td colspan="6" align="center">No Data to Display</td>
</tr>
<!-- /TMPL_IF -->

