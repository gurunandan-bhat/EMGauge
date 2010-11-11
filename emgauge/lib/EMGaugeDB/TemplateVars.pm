package EMGaugeDB::TemplateVars;

use lib qw(../);

use base qw(EMGaugeDB);

__PACKAGE__->table('tplvars');

__PACKAGE__->columns(Primary => qw{id});
__PACKAGE__->columns(Others => qw{
	mailer
	field
});

__PACKAGE__->has_a(mailer => 'EMGaugeDB::Mailer');
