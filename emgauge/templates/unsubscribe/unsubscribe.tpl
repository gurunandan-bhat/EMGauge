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
			<div class="span-24 last">
				<img src="images/airtel-logo.jpg" width="240" height="150" />
				<hr />
			</div>
			<div class="span-12">
				<h1>Unsubscribe me from Future Offers</h1>
				<div class="box">
					<p>
						Following your subscription to our email service offering exciting deals and offer, Airtel has been sending you these offers
						to your address <!-- TMPL_VAR NAME=EMAIL -->.
					</p>
					<p>
						To stop further emails notifying you about these offers, from being sent to you, please click the button below.
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
			<div class="span-12 last">
				<h1>See Some of our Exciting Offers!</h1>
				<div class="span-6">
					<a href="#"><img src="images/offer2.png" width="230" height="150" /></a>	
				</div>
				<div class="span-6 last">
					<a href="#"><img src="images/offer3.png" width="230" height="150" /></a>	
				</div>
				<div class="span-6">
					<a href="#"><img src="images/offer4.png" width="230" height="150" /></a>	
				</div>
				<div class="span-6 last">
					<a href=""><img src="images/offer5.png" width="230" height="150" /></a>	
				</div>
			</div>
		</div>
	</body>
</html>
