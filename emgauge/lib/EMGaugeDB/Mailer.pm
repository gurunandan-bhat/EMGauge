package EMGaugeDB::Mailer;

use lib qw(../);

use base qw(EMGaugeDB);

__PACKAGE__->table('mailer');

__PACKAGE__->columns(Primary => qw{id});
__PACKAGE__->columns(Others => qw{
	name
	description
	campaign
	landingpage
	htmlfilepath
	dfilepath
	subject
	sendername
	senderemail
	replytoemail
	onlineurl
	autoaddforward
	autoaddsubscribe
	autoaddunsubscribe
	autoaddonlinelink
	attachment
	attachmentmimetype
	createdby
	createdon
});

__PACKAGE__->has_a(campaign => 'EMGaugeDB::Campaign');

__PACKAGE__->has_many(images => 'EMGaugeDB::Images');
__PACKAGE__->has_many(links => 'EMGaugeDB::Links');
__PACKAGE__->has_many(tplvars => 'EMGaugeDB::TemplateVars');
__PACKAGE__->has_many(schedules => 'EMGaugeDB::Schedule');
__PACKAGE__->has_many(openers => 'EMGaugeDB::Tracker');
__PACKAGE__->has_many(comments => 'EMGaugeDB::Comment');

__PACKAGE__->add_constructor(mymailers => 'createdby = ?');

# so you can call $mailer->lists($scheduleid);
sub lists {
	use EMGaugeDB::Schedule;

	my $mailer = shift;

	if(my $scheduleid = shift) {
		return EMGaugeDB::Schedule->retrieve(id => $scheduleid)->lists;
	}
	else {
		return map {$_->lists} $mailer->schedules;
	}
}

1;

# $mailer->lists should give you all the lists that a mailer has been assigned to.