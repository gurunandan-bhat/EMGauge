package EMGaugeDB::List;

use lib qw(../);

use base qw(EMGaugeDB);

__PACKAGE__->table('list');

__PACKAGE__->columns(Primary => qw{id});
__PACKAGE__->columns(Others => qw{
	name
	description
	records
	source
	filename
	active
	createdon
	createdby
});

__PACKAGE__->has_many(listmembers => 'EMGaugeDB::Listmembers');
__PACKAGE__->has_many(members => ['EMGaugeDB::Listmembers' => 'recipient']);
__PACKAGE__->has_many(listschedules => 'EMGaugeDB::MailerLists');
__PACKAGE__->has_many(schedules => ['EMGaugeDB::MailerLists' => 'schedule']);

1;

# $list->mailers should give you all mailers that have been assigned to the list.
# Note this may seem useless at the moment but wil be useful in anayltics to see how 
# often a list has been used.
