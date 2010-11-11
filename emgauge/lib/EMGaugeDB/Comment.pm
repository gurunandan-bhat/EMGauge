package EMGaugeDB::Comment;

use lib qw(../);

use base qw(EMGaugeDB);

__PACKAGE__->table('comments');

__PACKAGE__->columns(Primary => qw{id});
__PACKAGE__->columns(Others => qw{
	mailer
	email
	title
	body
	score
	commentedon
});

__PACKAGE__->has_a(mailer => 'EMGaugeDB::Mailer');

1;
