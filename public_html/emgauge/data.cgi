#!/usr/bin/perl

use strict;
use warnings;

use lib::abs qw{../../emgauge/lib};

use EMGauge::Data;
use EMGauge::Constants;

my $app = EMGauge::Data->new(
	PARAMS => {
		cfgfile => $EMGauge::Constants::confdir . 'EMGauge.conf',
	},
);

$app->run;
	