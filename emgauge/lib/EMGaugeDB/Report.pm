package EMGaugeDB::Report;

use strict;
use warnings;

use lib qw(../);

use base qw(EMGaugeDB);

__PACKAGE__->table('report');

__PACKAGE__->columns(All => qw{
	mailer
	name
	schedules
	scheduled
	delivered
	bounced
	opened
	clicked
});
