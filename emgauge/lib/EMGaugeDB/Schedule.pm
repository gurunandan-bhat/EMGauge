package EMGaugeDB::Schedule;

use lib qw(../);

use base qw(EMGaugeDB);

__PACKAGE__->table('schedule');

__PACKAGE__->columns(Primary => qw{id});
__PACKAGE__->columns(Others => qw{
	name
	mailer
	jobid
	pid
	scheduled
	scheduledfor
	startedon
	completedon
	status
	scheduledby
	scheduledon
});

__PACKAGE__->has_a(mailer => 'EMGaugeDB::Mailer');
__PACKAGE__->has_many(schedulelists => 'EMGaugeDB::MailerLists');
__PACKAGE__->has_many(lists => ['EMGaugeDB::MailerLists' => 'list'], {cascade => 'None'});

__PACKAGE__->set_sql(count_scheduled => qq{SELECT 
		count(distinct recipient.id) 
	FROM 
		mailerlists,
		listmembers, 
		recipient
	WHERE
		mailerlists.schedule = ? and
		mailerlists.list = listmembers.list and
		listmembers.recipient = recipient.id
	}
);

__PACKAGE__->set_sql(count_bounced => qq{SELECT 
		count(distinct bounces.recipient) 
	FROM 
		mailerlists,
		listmembers,
		bounces
	WHERE
		mailerlists.schedule = ? and
		mailerlists.list = listmembers.list and
		listmembers.recipient = bounces.recipient
	}
);

1;

# $schedule->lists will give you all the lists that will be used in a particular batch
# useful only in the delivery section.
# $schedule->mailers gives you all the mailers that will be sent in one batch. Note that
# Business logic disallows the possibility that this list will be greater than one.
