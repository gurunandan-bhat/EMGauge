package EMGaugeDB::Images;

use strict;
use warnings;

use lib qw(../);

use base qw(EMGaugeDB);

__PACKAGE__->table('images');

__PACKAGE__->columns(Primary => qw{id});
__PACKAGE__->columns(Others => qw{
	mailer
	src
	count
	fullsrc
	url
	width
	height
	size
	alt
	thmb
	thmbw
	thmbh
	imap
	found
	include
});

__PACKAGE__->has_a(mailer => 'EMGaugeDB::Mailer');
