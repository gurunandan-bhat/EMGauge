package EMGaugeDB::QueueLog;

use strict;
use warnings;

use lib qw(../);

use base qw(EMGaugeDB);

__PACKAGE__->table('queuelog');

__PACKAGE__->columns(Primary => qw{id});
__PACKAGE__->columns(Others => qw{
	user
	scheduleid
	beanstalkid
	script
	delay
	status
	message
	at
});

1;
