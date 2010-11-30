#!/usr/bin/perl

use strict;
use warnings;

use ex::lib qw(../../emgauge/lib);

use EMGauge::Constants;
use EMGauge::Analytics;

my $app = EMGauge::Analytics->new(
	cfg_file => $EMGauge::Constants::confdir . 'EMGauge.conf',
);

$app->run;
