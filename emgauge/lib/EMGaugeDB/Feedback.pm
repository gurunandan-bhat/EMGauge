package EMGaugeDB::Feedback;

use lib qw(../);

use base qw(EMGaugeDB);

__PACKAGE__->table('airtel_feedback');

__PACKAGE__->columns(Primary => qw{id});
__PACKAGE__->columns(Others => qw{
	sales
	ccenter
	frepair
	network
	browsing
	billing
	payment
	resol
	cntnu
	recco
	fname
	lname
	company
	email
	phone
	altphone
	callme
	suggest
	rcptid
	rcpt
	filedon
});

1;
