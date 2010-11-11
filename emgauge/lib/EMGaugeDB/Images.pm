package EMGaugeDB::Images;

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
	found
	include
});

__PACKAGE__->has_a(mailer => 'EMGaugeDB::Mailer');
