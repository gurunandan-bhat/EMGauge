#!/usr/bin/perl

use criticism 'gentle';

use strict;
use warnings;

use Config::Simple;

use Net::POP3;
use Mail::DeliveryStatus::BounceParser;

use Date::Manip;

use lib::abs qw{../lib/};

use EMGauge::Constants;
use EMGaugeDB::Bounce;
use EMGaugeDB::Recipient;

my $cfg = Config::Simple->new($EMGauge::Constants::confdir . 'EMGauge.conf');

my $srvr = $cfg->param('Mail.POPServer');
my $user = $cfg->param('Mail.AuthUser');
my $pwd = $cfg->param('Mail.AuthPass');

my $pop = Net::POP3->new($srvr, TimeOut => 90)
	or die "Cannot connect to POP Server: $!\n";

my $msgs = $pop->login($user, $pwd)
	or die "Cannot Login to POP Server: " . $pop->message;

print "There are $msgs in the Mailbox\n";

my $messages = $pop->list;

MESSAGE:
foreach my $msgnum (keys %$messages) {
	
	my $delete_this = 0;
	
	my $msg = $pop->get($msgnum);
	my $bounce;
	eval {
		$bounce = Mail::DeliveryStatus::BounceParser->new($msg);
	};
	if ($@) {
		print "Cannot Parse Message: $msgnum\n";
		next MESSAGE;
	}
	next MESSAGE unless $bounce->is_bounce;
	

	foreach ($bounce->reports) {

		my $email = $_->get('email');
		next unless $email;
		
		my $bdate = $_->get('arrival-date');
		$bdate = UnixDate($bdate, '%Y-%m-%d %H:%M:%S') if $bdate;
		my $bhost = $_->get('host');
		my $status = $_->get('action');
		my $reason = $_->get('reason') . ' ' . $_->get('std-reason');
		$reason =~ s/\s+/ /g;
		
		my @rcpts = EMGaugeDB::Recipient->search(email => $email);
		foreach(@rcpts) {
			EMGaugeDB::Bounce->insert({
				recipient => $_,
				email => $email,
				status => $status,
				bhost => $bhost,
				reason => $reason,
				bdate => $bdate,
			});
		}
	}
	print "Deleting Message: $msgnum\n";
	$pop->delete($msgnum);
}
$pop->quit;

exit;
