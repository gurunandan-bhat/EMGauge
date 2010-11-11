package EMGaugeDB::DeliveryLog;

use lib qw(../);

use base qw(EMGaugeDB);

__PACKAGE__->table('deliverylog');

__PACKAGE__->columns(Primary => qw{id});
__PACKAGE__->columns(Others => qw{
	schedule
	recipient
	relayhost
	status
	message
	deliveredat
	postdeliverystatus
	postdeliveryreason
});

__PACKAGE__->set_sql(count_delivered => 'select count(*) from __TABLE__ where schedule = ?');

1;
