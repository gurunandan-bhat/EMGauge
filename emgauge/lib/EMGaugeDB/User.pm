package EMGaugeDB::User;

use lib qw(../);

use base qw(EMGaugeDB);

__PACKAGE__->table('users');

__PACKAGE__->columns(Primary => qw{id});
__PACKAGE__->columns(Others => qw{
	fullname
	username
	password
	email
	active
	createdon
	createdby
});

1;
