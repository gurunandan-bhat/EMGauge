package EMGaugeDB::Recipient;

use lib qw(../);

use base qw(EMGaugeDB);

__PACKAGE__->table('recipient');

__PACKAGE__->columns(Primary => qw{id});
__PACKAGE__->columns(Others => qw{
	ccode
	firstname
	lastname
	fullname
	prefix
	email
	dob
	gender
	organization
	phonelandline
	altphonelandline
	phonemobile
	altphonemobile
	city
	custom4
	custom3
	custom2
	custom1
	unsubscribed
});

__PACKAGE__->has_many(listmembers => 'EMGaugeDB::Listmembers');
__PACKAGE__->has_many(subscriptions => ['EMGaugeDB::Listmembers' => 'list']);
__PACKAGE__->has_many(visits => 'EMGaugeDB::Tracker');



#__PACKAGE__->add_constructor(membersof => qq{
#	recipient.id in (select 
#		recipient.id 
#	from 
#		recipient, listmembers
#	where recipient.id = listmembers.recipient
#	and listmembers.list in (?)
#		)
#});

sub membersof{

	my $self = shift;	
	my $lists = shift;

	my $query = 'SELECT 
					distinct recipient.id 
				FROM 
					recipient, 
					listmembers 
				WHERE 
					recipient.id = listmembers.recipient
					and listmembers.list in ('. $lists. ')';

	my $dbh = $self->db_Main();
	my $sth = $dbh->prepare_cached($query);
	$sth->execute();

	my @results = $self->sth_to_objects($sth);
}


# This is how you might use it;
# @recpt = EMGaugeDB::Recipient->membersof(join(', ', @lists));

sub forschedule{

	my $self = shift;	
	my $schdid = shift;

	my $query = qq{SELECT 
					distinct recipient.id 
				FROM 
					recipient, 
					listmembers, 
					mailerlists 
				WHERE
					recipient.id = listmembers.recipient and
					listmembers.list = mailerlists.list and
					mailerlists.schedule = ?};

	my $dbh = $self->db_Main();
	my $sth = $dbh->prepare_cached($query);
	$sth->execute($schdid);

	my @results = $self->sth_to_objects($sth);
}

1;
