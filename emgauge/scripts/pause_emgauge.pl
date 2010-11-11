#/usr/bin/perl

use strict;
use warnings;

use Getopt::Long;

my $pid = 0;

GetOptions(
	'process=i' => \$pid,
);

kill 9, $pid;
exit;

