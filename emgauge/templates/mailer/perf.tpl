	<!-- TMPL_IF NAME=MAILERSTATS -->
	<table>
	<tr><th>Date</th><th>Dlvrd</th><th>Ignrd</th><th>Bncd</th><th>Opnd</th><th>Read</th></tr>
	<!-- TMPL_LOOP NAME=MAILERSTATS -->
	<tr>
		<td><!-- TMPL_VAR NAME=schdt --></td>
		<td><!-- TMPL_VAR NAME=schdv --></td>
		<td><!-- TMPL_VAR NAME=schig --></td>
		<td><!-- TMPL_VAR NAME=schbc --></td>
		<td><!-- TMPL_VAR NAME=schop --></td>
		<td><!-- TMPL_VAR NAME=schck --></td>
	</tr>
	<!-- /TMPL_LOOP -->
	</table>
	<div id="chart<!-- TMPL_VAR NAME=MAILERID -->" style="height: 130px; width: 300px;"></div>
	<script type="text/javascript" src="js/FusionCharts.js"></script>    
	<script type="text/javascript">
		var myChart = new FusionCharts("swf/Doughnut3D.swf", "ChartId<!-- TMPL_VAR NAME=MAILERID -->", "300", "130", "0", "0");
		myChart.setDataXML('<chart palette="2" showBorder="0"><set label="Ignored" value="<!-- TMPL_VAR NAME=MAILERIG -->" /><set label="Bounced" value="<!-- TMPL_VAR NAME=MAILERBC -->" /><set label="Opened" value="<!-- TMPL_VAR NAME=MAILEROP -->" /><set label="Clicked" value="<!-- TMPL_VAR NAME=MAILERCK -->" /></chart>');
		myChart.render("chart<!-- TMPL_VAR NAME=MAILERID -->");
	</script>
	<!-- TMPL_ELSE -->
	<p class="notice"><strong>No Statistics Available</strong></p>
	<!-- /TMPL_IF -->
