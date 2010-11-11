<div class="pager">
<!-- TMPL_IF NAME=PREVLINK -->
	<div class="prevlink"><a href="<!-- TMPL_VAR NAME=PREVLINK -->">&laquo; Prev</a></div>	
<!-- /TMPL_IF -->
<p>
Page:
<!-- TMPL_LOOP NAME=PAGER -->
	<!-- TMPL_IF NAME=LINKED -->
		<a href="<!-- TMPL_VAR NAME=BASEURL -->?page=<!-- TMPL_VAR NAME=PAGE -->"><!-- TMPL_VAR NAME=PAGE --></a>
	<!-- TMPL_ELSE -->
		<!-- TMPL_VAR NAME=PAGE -->
	<!-- /TMPL_IF -->
	<!-- TMPL_UNLESS NAME=__last__ -->|<!-- /TMPL_UNLESS -->
<!-- /TMPL_LOOP -->
</p>
<!-- TMPL_IF NAME=NEXTLINK -->
	<div class="nextlink"><a href="<!-- TMPL_VAR NAME=NEXTLINK -->">Next &raquo;</a></div>
<!-- /TMPL_IF -->
</div>
