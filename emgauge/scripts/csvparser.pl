#!/usr/bin/perl

use strict;
use warnings;

use lib::abs qw{/home/nandan/workspace/EMGauge/emgauge/lib};

use EMGauge::Constants;

use EMGaugeDB::Recipient;
use EMGaugeDB::XLParseQueue;
use EMGaugeDB::Listmembers;

use Getopt::Long;
use Config::Simple;
use Text::CSV_XS;
use Email::Valid;

use Digest::SHA qw{sha1_hex};
use Data::Serializer;

use Data::Dumper;

my $pqid = 0;
my $jobid = 0;

GetOptions(
	'pqid=i' => \$pqid,
	'jobid=i' => \$jobid,
);

($pqid and $jobid) or die "Parse and/or Job Ids not available";
my $pq = EMGaugeDB::XLParseQueue->retrieve(id => $pqid) or exit $jobid;

($pq->bjobid == $jobid) or exit $jobid;

my $csvfile = $pq->filename;
my $listid = $pq->listid->id;

my $list = EMGaugeDB::List->retrieve(id => $listid);

my $cfg = Config::Simple->new($EMGauge::Constants::confdir . '/EMGauge.conf');

my $srlzr = Data::Serializer->new(
	serializer => 'Storable',
	digester   => 'MD5',
	cipher     => 'DES',
	secret     => $cfg->param('Mail.DigestSekrit'),
	compress   => 1,
);

my $group = $srlzr->deserialize($pq->importfields);

open my $csvfh, "<", $csvfile or die "Cannot Open CSV file: $!\n";
my $csv = Text::CSV_XS->new({binary => 1});

my $hdr = $csv->getline($csvfh);

my $recordcount = 0;
while (my $row = $csv->getline($csvfh)) {
	
	my $rowhash;
	my $idx = 0;
	foreach (@{$row}) {

		if (my $field = $group->[0]->[$idx]) {
			$rowhash->{$field} = $_;
		}
		++$idx;
	}
	
#	print Dumper($rowhash);
#	next;
	
	my $email = Email::Valid->address($rowhash->{email});
	next unless $email;
	
	if (my @recs = EMGaugeDB::Recipient->search({email => $email})) {
		foreach (@recs) {
			$_->set(%$rowhash);
			$_->update;

			if (! $_->subscriptions(list => $list->id)) {
				$list->add_to_members({recipient => $_,});
				++$recordcount;
			}
		}
	}
	else {

		my $rec = EMGaugeDB::Recipient->insert($rowhash);

		if (! $rec->subscriptions(list => $list->id)) {
			$list->add_to_members({recipient => $rec,});
			++$recordcount;
		}
	}
}

$pq->recordsin($recordcount);
$pq->update;
$list->records($recordcount);
$list->update;

exit $jobid;

