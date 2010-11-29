package EMGaugeDB::Links;

use strict;
use warnings;

use lib qw(../);

use base qw(EMGaugeDB);

__PACKAGE__->table('links');

__PACKAGE__->columns(Primary => qw{id});
__PACKAGE__->columns(Others => qw{
	mailer
	myhref
	href
	target
	title
	track
	imap
});

__PACKAGE__->has_a(mailer => 'EMGaugeDB::Mailer');
