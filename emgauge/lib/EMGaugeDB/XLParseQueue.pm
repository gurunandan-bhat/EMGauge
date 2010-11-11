package EMGaugeDB::XLParseQueue;

use lib qw(../);

use base qw(EMGaugeDB);

__PACKAGE__->table('xlparsequeue');

__PACKAGE__->columns(Primary => qw{id});
__PACKAGE__->columns(Others => qw{
	filename
	listid
	bjobid
	records
	recordsin
	schtime
	importfields
	createdby
	starttime
	endtime
});

__PACKAGE__->has_a(listid => 'EMGaugeDB::List');

1;

# $list->mailers should give you all mailers that have been assigned to the list.
# Note this may seem useless at the moment but wil be useful in anayltics to see how 
# often a list has been used.
