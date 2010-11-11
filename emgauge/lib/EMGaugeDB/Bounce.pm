package EMGaugeDB::Bounce;

use lib qw(../);

use base qw(EMGaugeDB);

__PACKAGE__->table('bounces');

__PACKAGE__->columns(Primary => qw{id});
__PACKAGE__->columns(Others => qw{
	recipient
	email
	status
	bhost
	reason
	bdate
});

1;
