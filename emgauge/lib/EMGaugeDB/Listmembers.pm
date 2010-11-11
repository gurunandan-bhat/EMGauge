package EMGaugeDB::Listmembers;

use lib qw(../);

use base qw(EMGaugeDB);

__PACKAGE__->table('listmembers');

__PACKAGE__->columns(Primary => qw{id});
__PACKAGE__->columns(Others => qw{
	list
	recipient
});

__PACKAGE__->has_a(recipient => 'EMGaugeDB::Recipient');
__PACKAGE__->has_a(list => 'EMGaugeDB::List');

__PACKAGE__->set_sql(inrecords => 'select count(*) from __TABLE__ where list = ?');

1;
