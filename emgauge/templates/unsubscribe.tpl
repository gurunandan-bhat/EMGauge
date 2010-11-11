<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<link rel="stylesheet" href="css/screen.css" type="text/css" media="screen, projection" />  
		<link rel="stylesheet" href="css/print.css" type="text/css" media="print" />  
		<!--[if lt IE 8]><link rel="stylesheet" href="css/ie.css" type="text/css" media="screen, projection" /><![endif]-->  
		<link rel="stylesheet" href="css/edmanage.css" type="text/css" media="screen, projection" />
		<title>Create Mailer</title>
    </head>
	<body>
		<div class="container">
			<div class="span-24 banner last">
				<img src="images/response_banner.jpg" width="950" height="75" />
			</div>
			<div class="span-9">
				<h1>Unsubscribe me from Future Offers</h1>
				<div class="box">
					<p>
						Following your subscription to our email service offering exciting travel deals, SOTC has been sending you these offers
						to your address <!-- TMPL_VAR NAME=EMAIL -->.
					</p>
					<p>
						To stop further emails notifying you about these offers, from being sent to you, please click the button below. 
						You can always re-subscribe later by sending an email to <a href="mailto:subscribe@sotcoffers.com">subscribe@sotcoffers.com</a>
					</p>
					<form method="post" action="user.cgi">
						<input type="submit" name="unsubscribe" value="Unsubscribe Me" />
						<input type="hidden" name="rcpt" value="<!-- TMPL_VAR NAME=RCPT -->" />
						<input type="hidden" name="digest" value="<!-- TMPL_VAR NAME=DIGEST -->" />
						<input type="hidden" name="email" value="<!-- TMPL_VAR NAME=EMAIL -->" />
						<input type="hidden" name="rm" value="trulyunsubscribe" />
					</form> 
				</div>
			</div>
			<div class="span-15 last">
				<h1>Read About Our Exciting Offers!</h1>
				<div class="span-5">
					<a href="http://www.sotc.in/Destinations.aspx?ServiceType=2&Destination=30"><img src="images/usa.jpg" width="190" height="150" /></a>	
					<h2>U.S.A.</h2>
				</div>
				<div class="span-5">
					<a href="http://www.sotc.in/Destinations.aspx?ServiceType=2&Destination=94"><img src="images/singapore.jpg" width="190" height="150" /></a>	
					<h2>South East Asia</h2>
				</div>
				<div class="span-5 last">
					<a href="http://www.sotc.in/Destinations.aspx?ServiceType=2&Destination=11"><img src="images/europe.jpg" width="190" height="150" /></a>	
					<h2>Europe</h2>
				</div>
				<div class="span-5">
					<a href="http://www.sotc.in/Destinations.aspx?ServiceType=2&Destination=92"><img src="images/egypt.jpg" width="190" height="150" /></a>	
					<h2>Exotic Destinations</h2>
				</div>
				<div class="span-5">
					<a href="http://www.sotc.in/Destinations.aspx?ServiceType=2&Destination=101"><img src="images/australia.jpg" width="190" height="150" /></a>	
					<h2>Australia</h2>
				</div>
				<div class="span-5 last">
					<a href=http://www.sotc.in/Services.aspx?ServiceType=3"><img src="images/india.jpg" width="190" height="150" /></a>	
					<h2>Domestic</h2>
				</div>
			</div>
		</div>
	</body>
</html>
