#!/usr/bin/perl

use strict;
use warnings;

use Mail::Log::Parse::Postfix;
use Getopt::Long;
use Text::CSV_XS;
use DateTime;

my $logfile;
my $res = GetOptions('file=s' => \$logfile);

die "No Log File Specified. Aborting\n" unless $logfile;

my $log = Mail::Log::Parse::Postfix->new({
	log_file => $logfile
});

my @flds = qw{
	delay_before_queue
	delay_connect_setup
	delay_in_queue
	delay_message_transmission
	from
	host
	id
	msgid
	pid
	program
	relay
	size
	status
	text
	timestamp
	to
	delay
	connect
	disconnect
	previous_host
	previous_host_name
	previous_host_ip
};

open my $fh, ">:encoding(utf8)", 'new.csv' or die "Error Opening new.csv: $!\n";
my $csv = Text::CSV_XS->new({binary => 1}) or
	die 'Cannot Create CSV Object: ' . Text::CSV->error_diag;


my $status = $csv->combine(@flds);
die 'Cannot convert to CSV. Aborting: ' . $csv->error_diag unless $status;
print $fh $csv->string;
print $fh "\n";

while (my $line = $log->next) {

	next unless ((defined $line->{program}) and ($line->{program} =~ /smtp$/));

	my ($addr) = $line->{to};
#	$addr =~ /\<(.*)\>/;
#	$addr = $1;

	my $relay = $line->{relay};
	
	my $dt = DateTime->from_epoch(epoch => $line->{timestamp});
	my $tstmp = $dt->dmy . ' ' . $dt->hms;
	
	my ($status, $msg);
	
	if ($status = $line->{status}) {
		$status =~ /(.*?)(\s+)(.*)/;
		$status = $1;
		$msg = $3;
	}

	my @fields = ($tstmp, $addr, $relay, $status, $msg);

	my $res = $csv->combine(@fields);
	
	die 'Cannot convert to CSV. Aborting: ' . $csv->error_diag unless $res;
	print $fh $csv->string;
	print $fh "\n";
}