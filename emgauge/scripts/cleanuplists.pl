#!/usr/bin/perl

use strict;
use warnings;

use lib qw{../lib/};

use DBI;
use Text::CSV_XS;

my $csv = Text::CSV_XS->new({
	sep_char => "\t",
	binary => 1, 
	eol => $/,
});
my $fname = 'latestbounces.csv';

open my $csvfh, '<', $fname or die "$fname: $!";

my $dbh = DBI->connect("DBI:mysql:database=emgauge;host=localhost", 'emgauge', 'ip31415', {
	RaiseError => 1,
	PrintError => 1,
}) or die $DBI::errstr;
	
my $findsth = $dbh->prepare("select id from recipient where email = ?");
my $delsth = $dbh->prepare("delete from listmembers where list = ? and recipient = ?");

my $count = 0;

CSVROW:
while (my $row = $csv->getline ($csvfh)) {

	my $listid = $row->[0];
	my $email = $row->[1];
	
	$email =~ s/^\s+//;
	$email =~ s/\s+$//;
	
	$findsth->execute($email);
	while (my $row = $findsth->fetchrow_arrayref) {
		$delsth->execute($listid, $row->[0]);
		print ++$count . "\n";
	}
}	
