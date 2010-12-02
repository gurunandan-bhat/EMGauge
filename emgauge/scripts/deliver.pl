#!/usr/bin/perl

use strict;
use warnings;

use lib::abs qw{/home/nandan/workspace/EMGauge/emgauge/lib};

use EMGauge::Constants;

use EMGaugeDB::Recipient;
use EMGaugeDB::Mailer;
use EMGaugeDB::DeliveryLog;
use EMGaugeDB::MailerLog;

use Getopt::Long;
use HTML::TreeBuilder;

use File::Basename qw{fileparse fileparse_set_fstype};

use Config::Simple;

use Digest::SHA qw{sha1_hex};
use URI::Escape;
use Text::Template;

use MIME::Entity;
use Email::Sender::Simple  qw{sendmail};
use Email::Sender::Transport::SMTP::Persistent;
use Email::Sender::Transport::Test;

use POSIX;

my $sid = 0;
my $jobid = 0;
my $force;

GetOptions(
	'schedule=i' => \$sid,
	'jobid=i' => \$jobid,
	'force'	=> \$force,
);

die ("Error: Invalid Schedule ID") unless ($sid and $jobid);

exit $jobid unless (my $schedule = EMGaugeDB::Schedule->retrieve(id => $sid));
exit $jobid unless ($schedule->jobid == $jobid);

$SIG{USR1} = sub {

	my $sigid = shift;
	local $SIG{$sigid} = 'IGNORE';

	$schedule->set(
		status => 2,
		completedon => POSIX::strftime("%Y/%m/%d %H:%M:%S", localtime),
	);
	$schedule->update;
	
	exit $jobid;
};

my $mailer = EMGaugeDB::Mailer->retrieve(id => $schedule->mailer) ||
	die("Cannot Find Mailer for Schedule $sid");

my $mlrid = $mailer->id;

my $mlrname = $mailer->name;
my $mlrsender = $mailer->sendername;
my $mlrsenderemail = $mailer->senderemail;
my $mlrsubject = $mailer->subject;
my $mlrreplyto = $mailer->replytoemail;

my $mlrfile = $mailer->htmlfilepath;
die "Cannot Read HTML File: $mlrfile for Mailer ID $mlrid, Name: $mlrname" unless (-f $mlrfile and -r _);

my $cfg = Config::Simple->new($EMGauge::Constants::confdir . 'EMGauge.conf');

my $baseurl = $cfg->param('URL.AppBase');
my $mlrurl = $baseurl . '/' . $mailer->onlineurl;

my $tree = HTML::TreeBuilder->new_from_file($mlrfile);

my @attachments;
my $smallsrc;
my $smallimgid;
my $smallsize = 100000000;

my $index = 1;

foreach my $img ($mailer->images) {

	my $imgid = $img->id;
	my $src = $img->src;
	my $fullsrc = $img->fullsrc;
	my $url = $img->url;
	
	die "No Image found at: $fullsrc" unless -f $fullsrc;

	if ($img->include) { # Include - replace src by cid

		my ($imgfile, $imgdir, $imgsfx) = fileparse($fullsrc, qr/\.[^.]*/);
		$imgfile = $imgfile . $imgsfx;
		(my $type = $imgsfx) =~ s/^\.//;
		 
		my @images = $tree->look_down(
			_tag => 'img',
			src => $src,
		);

		foreach (@images) {
			my $gid = 'EMGAUGE_' . $index;
			$_->attr(src => "cid:$gid");

			push @attachments, {
				Type => "image/$type",
				Id => "<$gid>",
				Path => $fullsrc,
			};
			
			++$index;
		}
	}
	else {
		
		my @images = $tree->look_down(
			_tag => 'img',
			src => $src,
		);

		foreach (@images) {
			
			$_->attr(src => $baseurl . uri_escape(qq[/$url]));
		}

		if ($img->size < $smallsize) {
			$smallimgid = $imgid;
			$smallsrc = $baseurl . uri_escape(qq[/$url]);
			$smallsize = $img->size;
		}
	}
}

my @smallimages = $tree->look_down(
	_tag => 'img',
	src => $smallsrc,
);
if (@smallimages) {
	$smallimages[0]->attr(src => $baseurl . qq[/user.cgi?rm=sendimg&scheduleid=$sid&mailerid=$mlrid&imgid=$smallimgid&rcpt={\$recipient}]);
}

if ($mailer->attachment) {
	push @attachments, {
		Type => $mailer->attachmentmimetype,
		Path => $mailer->attachment,
		Filename => (fileparse($mailer->attachment))[1],
	}
}

foreach my $lnk ($mailer->links) {
	
	my $lnkid = $lnk->id;
	
	if ($lnk->track) {
		
		my @inclnks = $tree->look_down(
			href => $lnk->href,
		);

		foreach (@inclnks) {
			$_->attr(href => $baseurl . qq[/user.cgi?rm=tracklink&scheduleid=$sid&mailerid=$mlrid&linkid=$lnkid&rcpt={\$recipient}]);
		}
	}
}

my $mlrdata = $tree->as_HTML();
$tree->delete;

my $ttpl = Text::Template->new(
	TYPE => 'STRING', 
	SOURCE => $mlrdata,
);

my $subttpl = Text::Template->new(
	TYPE => 'STRING', 
	SOURCE => $mlrsubject,
);

my $mailerlog = EMGaugeDB::MailerLog->find_or_create({
	mailer => $mlrid,
	schedule => $sid,
});
$mailerlog->scheduled($schedule->scheduled);
$mailerlog->update;

my $transport = $cfg->param('Mail.TestTransport') ?
	Email::Sender::Transport::Test->new() : 
	Email::Sender::Transport::SMTP::Persistent->new({
		host => $cfg->param('Mail.SMTPRelay'),,
		port => 25,
		sasl_username => $cfg->param('Mail.AuthUser'),
		sasl_password => $cfg->param('Mail.AuthPass'),
	});

$schedule->set(
	pid => $$,
	startedon => POSIX::strftime("%Y/%m/%d %H:%M:%S", localtime),
	status => 1,
);
$schedule->update;

my $count = $mailerlog->delivered + 0;
my $offset = $mailerlog->offset + 0;
foreach(EMGaugeDB::Recipient->forschedule($sid, $offset)) {
	
	++$offset;

	next if $_->unsubscribed;

	my $msg = MIME::Entity->build(
		Type => 'multipart/related',
		To => $_->email,
		From => "$mlrsender <$mlrsenderemail>",
		'Reply-To' => $mlrreplyto,
		Subject => $subttpl->fill_in(HASH => {
			recipient => $_->id,
			email => $_->email,
			firstname => $_->firstname,
			lastname => $_->lastname,
			fullname => $_->fullname,
			custom1 => $_->custom1,
			custom2 => $_->custom2,
			custom3 => $_->custom3,
			custom4 => $_->custom4,
		}),
		'X-Emgaugeid' => join('|', ($_->id, $sid, $mlrid)), 
	);

	my $digest = sha1_hex($cfg->param('Mail.DigestSekrit') . $_->email);
	
	$msg->attach(
		Type => 'text/html',
		Data => $ttpl->fill_in(HASH => {
			recipient => $_->id,
			unsubscribelink => $baseurl . '/user.cgi?rm=unsubscribe&id=' . $_->id . '&digest=' . $digest,
			viewonlinelink => $mlrurl,
			commentlink => $baseurl . '/user.cgi?rm=comment&id=' . $_->id . '&mlr=' . $mlrid . '&digest=' . $digest,
			firstname => $_->firstname,
			lastname => $_->lastname,
			fullname => $_->fullname,
			custom1 => $_->custom1,
			custom2 => $_->custom2,
			custom3 => $_->custom3,
			custom4 => $_->custom4,
		}),
		Encoding => 'quoted-printable',
	);

	for (@attachments) {
		$msg->attach(
			Type => $_->{Type},
			Id => $_->{Id},
			Path => $_->{Path},
			Disposition => 'inline',
			Encoding => 'base64',
		);
	}

	my ($status, $message);
	eval {
		sendmail($msg, {transport => $transport});
	};
	if ($@) {
		EMGaugeDB::DeliveryLog->insert({
			schedule => $sid,
			recipient => $_->id,
			status => 0,
			message => $@,
		});
	}
	else {
		++$count;
	}

	$mailerlog->set(
		delivered => $count,
		offset => $offset,
	);
	$mailerlog->update;

	sleep 30;
}

$mailerlog->offset(0);
$mailerlog->update;

$schedule->status(0);
$schedule->completedon( POSIX::strftime("%Y/%m/%d %H:%M:%S", localtime) );
$schedule->update;

print Dumper($transport->deliveries)
	if $cfg->param('Mail.TestTransport');

exit $jobid;
