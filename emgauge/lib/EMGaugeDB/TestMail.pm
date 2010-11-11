package EMGaugeDB::TestMail;

use lib qw(../);

use base qw(EMGaugeDB);

__PACKAGE__->table('testmail');

__PACKAGE__->columns(Primary => qw{id});
__PACKAGE__->columns(Others => qw{
	rcpt
	mailer
	senton
	status
});

__PACKAGE__->has_a(mailer => 'EMGaugeDB::Mailer');

1;
