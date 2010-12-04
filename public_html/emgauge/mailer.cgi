#!/usr/bin/perl

use strict;
use warnings;

use ex::lib qw(../../emgauge/lib);

use EMGauge::Mailer;
use EMGauge::Constants;

my $app = EMGauge::Mailer->new(
	PARAMS => {
		cfgfile => $EMGauge::Constants::confdir . 'EMGauge.conf',
	},
);

$app->run;

