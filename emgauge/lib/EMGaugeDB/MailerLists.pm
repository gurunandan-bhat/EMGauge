package EMGaugeDB::MailerLists;

use lib qw(../);

use base qw(EMGaugeDB);

__PACKAGE__->table('mailerlists');

__PACKAGE__->columns(Primary => qw{id});
__PACKAGE__->columns(Others => qw{
	schedule
	list
	assignedon
	assignedby
});

__PACKAGE__->has_a(schedule => 'EMGaugeDB::Schedule');
__PACKAGE__->has_a(list => 'EMGaugeDB::List');

1;
