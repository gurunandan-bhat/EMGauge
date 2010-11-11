package EMGaugeDB::Campaign;

use lib qw(../);

use base qw(EMGaugeDB);

__PACKAGE__->table('campaign');

__PACKAGE__->columns(Primary => qw{id});
__PACKAGE__->columns(Others => qw{
	name
	description
	createdon
	createdby
});

__PACKAGE__->has_many(mailers => 'EMGaugeDB::Mailer');

1;
