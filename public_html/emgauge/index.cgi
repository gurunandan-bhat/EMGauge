#!/usr/bin/perl

use strict;
use warnings;

use ex::lib qw(../../emgauge/lib);

use EMGauge::Index;
use EMGauge::Constants;

my $app = EMGauge::Index->new(
	PARAMS => {
		cfgfile => $EMGauge::Constants::confdir . 'EMGauge.conf',
	},
);

$app->run;
