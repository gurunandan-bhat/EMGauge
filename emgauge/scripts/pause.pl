#!/usr/bin/perl

use strict;
use warnings;

use lib::abs qw{/home/nandan/workspace/EMGauge/emgauge/lib};
use EMGaugeDB::Schedule;

use Getopt::Long;

my $sid = 0;
my $jobid = 0;

GetOptions(
	'schedule=i' => \$sid,
	'jobid=i' => \$jobid,
);

exit $jobid unless (my $schedule = EMGaugeDB::Schedule->retrieve(id => $sid));

open my $outfile, '>', '/home/nandan/signalled';

my $retval = kill USR1 => $schedule->pid;
print $outfile $retval . "\n";

exit $jobid;
