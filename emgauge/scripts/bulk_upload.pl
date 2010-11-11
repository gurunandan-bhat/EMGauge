#!/usr/bin/perl

use strict;
use warnings;

use lib qw{../lib/};

use EMGaugeDB::Recipient;
use EMGaugeDB::Listmembers;
use EMGaugeDB::List;

use Text::CSV_XS;
use Email::Valid;

use Getopt::Long;

my $listid;
my $csvfile;
my $col;

GetOptions(
	'list=i' => \$listid,
	'file=s' => \$csvfile,
	'column=i' => \$col
);

my $csv = Text::CSV_XS->new({binary => 1, eol => $/});
open my $csvfh, '<', $csvfile or die "$csvfile: $!";

my $count = 0;

CSVROW:
while (my $row = $csv->getline ($csvfh)) {

	my $email = $row->[$col];
	
	$email =~ s/^\s+//;
	$email =~ s/\s+$//;
	
	next CSVROW unless ($email = Email::Valid->address($email));
	
	my $rcpt = EMGaugeDB::Recipient->find_or_create({
		email => $email,
	});

	EMGaugeDB::Listmembers->insert({
		list => $listid,
		recipient => $rcpt->id,
	});
	
	print ++$count . "\n";
	
}	

my $list = EMGaugeDB::List->retrieve(id => $listid);
$list->set(
	records => $count,
	filename => $csvfile,
	active => 1,
);
$list->update;
	
print "$count\n";

exit;
