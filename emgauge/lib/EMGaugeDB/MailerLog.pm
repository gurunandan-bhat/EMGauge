package EMGaugeDB::MailerLog;

use lib qw(../);

use base qw(EMGaugeDB);

__PACKAGE__->table('mailerlog');

__PACKAGE__->columns(Primary => qw{id});
__PACKAGE__->columns(Others => qw{
	mailer
	schedule
	scheduled
	delivered
	bounced
	opened
	clicked
	updatedon
});

1;
