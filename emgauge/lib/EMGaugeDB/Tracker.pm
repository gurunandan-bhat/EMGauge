package EMGaugeDB::Tracker;

use lib qw(../);

use base qw(EMGaugeDB);

__PACKAGE__->table('tracker');

__PACKAGE__->columns(Primary => qw{id});
__PACKAGE__->columns(Others => qw{
	recipient
	mailer
	schedule
	objtype
	obj
	reqtstamp
});

__PACKAGE__->has_a(mailer => 'EMGaugeDB::Mailer');
__PACKAGE__->has_a(recipient => 'EMGaugeDB::Recipient');

__PACKAGE__->set_sql(count_opened => qq{SELECT 
		count(distinct recipient) 
	FROM 
		tracker
	WHERE
		tracker.schedule = ? and 
		tracker.objtype = 'image'
	}
);

__PACKAGE__->set_sql(count_clicked => qq{SELECT 
		count(distinct recipient) 
	FROM 
		tracker
	WHERE
		tracker.schedule = ? and 
		tracker.objtype = 'link'
	}
);

1;
