#!/usr/bin/perl

use criticism 'gentle';

use strict;
use warnings;

use Config::Simple;

use Net::POP3;
use Mail::DeliveryStatus::BounceParser;
use Date::Manip;
use DBI;

use Fcntl qw{LOCK_EX LOCK_NB};

use lib qw{/home/nandan/workspace/EMGauge/emgauge/lib};

use EMGauge::Constants;
use EMGaugeDB::Bounce;
use EMGaugeDB::Recipient;

unless ( flock DATA, LOCK_EX | LOCK_NB ) {
	print STDERR "Found duplicate script run. Stopping\n";
	exit(0);
}

my $cfg = Config::Simple->new($EMGauge::Constants::confdir . 'EMGauge.conf');

my $popsrvr = $cfg->param('Mail.POPServer');

my $dbsrvr = $cfg->param('Mail.MailDBHost');
my $user = $cfg->param('Mail.MailDBUser');
my $pwd = $cfg->param('Mail.MailDBPassword');
my $db = $cfg->param('Mail.MailDBDatabase');

my $dsn = "DBI:mysql:database=$db;host=$dbsrvr";

my $dbh = DBI->connect($dsn, $user, $pwd, {
	RaiseError => 1,
	PrintError => 1,
	AutoCommit => 1,
}) or die "Cannot connect to Database: $DBI::errstr";

my $sth = $dbh->prepare("select username, password from mailbox");
$sth->execute;

while (my ($popusr, $poppwd) = $sth->fetchrow_array) {
	
	my $pop = Net::POP3->new($popsrvr, TimeOut => 120)
		or die "Cannot connect to POP Server: $!\n";
	my $msgs = $pop->login($popusr, $poppwd)
		or die "Cannot Login to POP Server: " . $pop->message;
	
	my $messages = $pop->list;
	
	MESSAGE:
	foreach my $msgnum (keys %$messages) {
		
		my $delete_this = 0;
		
		my $msg = $pop->get($msgnum);
		my $bounce;
		eval {
			$bounce = Mail::DeliveryStatus::BounceParser->new($msg);
		};
		next MESSAGE if ($@);

		if (! $bounce->is_bounce) {
			$pop->delete($msgnum);
			next MESSAGE;
		}

		my ($brcpt, $bschedule, $bmailer);

		if (my $orig_message = $bounce->orig_message) {
			if (my $orig_head = $orig_message->head) {
				if (my $orig_id = $orig_head->get('x-emgaugeid')) {
					chomp($orig_id);
					($brcpt, $bschedule, $bmailer) = split(/\|/, $orig_id);
				}
			}
		}
		
		REPORT:
		foreach ($bounce->reports) {
	
			my $email = $_->get('email');
			next REPORT unless $email;
			
			if (! $brcpt) {
				if (my @rcpts = EMGaugeDB::Recipient->search(email => $email)) {
					$brcpt = $rcpts[0];
				}
				else {
					last REPORT;
				}
			}

			my $bdate = $_->get('arrival-date');
			$bdate = UnixDate($bdate, '%Y-%m-%d %H:%M:%S') if $bdate;
			my $bhost = $_->get('host');
			my $status = $_->get('action');
			my $reason = $_->get('reason') . ' ' . $_->get('std-reason');
			$reason =~ s/\s+/ /g;
			
			my $brec = EMGaugeDB::Bounce->insert({
				email => $email,
				recipient => $brcpt,
				mailer => $bmailer,
				schedule => $bschedule,
				status => $status,
				reason => $reason,
				bdate => $bdate,
				bhost => $bhost,
			});
		}

		$pop->delete($msgnum);
	}

	$pop->quit();
}

### DO NOT REMOVE THE FOLLOWING LINES ###

__DATA__
This exists to allow the locking code at the beginning of the file to work.
DO NOT REMOVE THESE LINES!
