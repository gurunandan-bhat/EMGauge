#!/usr/bin/perl

use strict;
use warnings;

use lib::abs qw{../../emgauge/lib};

use EMGauge::Schedule;
use EMGauge::Constants;

my $app = EMGauge::Schedule->new(
	PARAMS => {
		cfgfile => $EMGauge::Constants::confdir . 'EMGauge.conf',
	},
);

$app->run;
