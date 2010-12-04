#!/usr/bin/perl

use strict;
use warnings;

use ex::lib qw{../../emgauge/lib};

use EMGauge::User;
use EMGauge::Constants;

my $app = EMGauge::User->new(
	PARAMS => {
		cfgfile => $EMGauge::Constants::confdir . 'EMGauge.conf',
	},
);

$app->run;
