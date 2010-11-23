package EMGaugeDB::Bounce;

use strict;
use warnings;

use lib qw(../);

use base qw(EMGaugeDB);

__PACKAGE__->table('bounces');

__PACKAGE__->columns(Primary => qw{id});
__PACKAGE__->columns(Others => qw{
	email
	recipient
	mailer
	schedule
	status
	reason
	bdate
	bhost
});

1;
