<!-- TMPL_IF NAME=MAILERSTATS -->
<table>
<tr><th>Date</th><th>Dlvrd</th><th>Ignrd</th><th>Bncd</th><th><a href="mailer.cgi?rm=getlist&mid=<!-- TMPL_VAR NAME=MAILERID -->&sid=0&obj=image" title="Download Full List of Openers">Opnd</a></th><th><a href="mailer.cgi?rm=getlist&mid=<!-- TMPL_VAR NAME=MAILERID -->&sid=0&obj=link" title="Download Full List of Clickers">Read</a></th></tr>
<!-- TMPL_LOOP NAME=MAILERSTATS -->
<tr>
	<td><!-- TMPL_VAR NAME=schdt --></td>
	<td><!-- TMPL_VAR NAME=schdv --></td>
	<td><!-- TMPL_VAR NAME=schig --></td>
	<td><!-- TMPL_VAR NAME=schbc --></td>
	<td>
		<a href="mailer.cgi?rm=getlist&mid=<!-- TMPL_VAR NAME=MAILERID -->&sid=<!-- TMPL_VAR NAME=schid -->&obj=image" title="Download List of Openers">
			<!-- TMPL_VAR NAME=schop -->
		</a>
	</td>
	<td>
		<a href="mailer.cgi?rm=getlist&mid=<!-- TMPL_VAR NAME=MAILERID -->&sid=<!-- TMPL_VAR NAME=schid -->&obj=link" title="Download List of Clickers">
			<!-- TMPL_VAR NAME=schck -->
		</a>&nbsp;&nbsp;
		<a href="#" class="clicks" mlrid="<!-- TMPL_VAR NAME=MAILERID -->" schid="<!-- TMPL_VAR NAME=schid -->" title="See which Links were clicked">&raquo;</a>
	</td>
</tr>
<!-- /TMPL_LOOP -->
</table>
<div id="chart<!-- TMPL_VAR NAME=MAILERID -->" style="height: 130px; width: 305px;"></div>
<script type="text/javascript" src="js/FusionCharts.js"></script>    
<script type="text/javascript">
	var myChart = new FusionCharts("swf/Doughnut3D.swf", "ChartId<!-- TMPL_VAR NAME=MAILERID -->", "305", "130", "0", "0");
	myChart.setDataXML('<chart palette="2" showBorder="1" borderColor="D7DBAF" enableSmartLabels="1" captionPadding="0" chartLeftMargin="0" chartRightMargin="0" chartTopMargin="0" chartBottomMargin="0" caption="<!-- TMPL_VAR NAME=MAILERNAME -->"><set label="Ignrd" value="<!-- TMPL_VAR NAME=MAILERIG -->" /><set label="Bncd" value="<!-- TMPL_VAR NAME=MAILERBC -->" /><set label="Opnd" value="<!-- TMPL_VAR NAME=MAILEROP -->" /><set label="Clkd" isSliced="1" value="<!-- TMPL_VAR NAME=MAILERCK -->" /></chart>');
	myChart.render("chart<!-- TMPL_VAR NAME=MAILERID -->");
</script>
<!-- TMPL_ELSE -->
<p class="notice"><strong>No Statistics Available</strong></p>
<!-- /TMPL_IF -->
