#!/usr/bin/perl

use strict;
use warnings;

use lib qw{../lib/};

use EMGaugeDB::Recipient;
use EMGaugeDB::Listmembers;
use EMGaugeDB::List;

use Text::CSV_XS;
use Email::Valid;

use File::Find;

use Getopt::Long;

my $csvdir = '.';
my $column = 0;

GetOptions(
	'directory=s' => \$csvdir,
	'column=i' => \$column,
);

my $wanted = sub {

	return unless (-f and -r _);
	return unless /\.csv$/;
	

	(my $listname = $_) =~ s/\.csv$//;
	$listname =~ s/\_/ /g;
	
	my $fname = $File::Find::name;
	my $listid = EMGaugeDB::List->find_or_create(name => $listname)->id;

	my $records = import_records($fname, $column, $listid);
	
	print "$_\t$records\n";
	return;
};

File::Find::find($wanted, '/home/guru/Work/Airtel/New Data');

exit;

sub import_records {
	
	my $fname = shift;
	my $col = shift;
	my $listid = shift;
	
	my $csv = Text::CSV_XS->new({binary => 1, eol => $/});
	open my $csvfh, '<', $fname or die "$fname: $!";

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
		filename => $_,
		active => 1,
	);
	$list->update;
	
	return $count;
}  
