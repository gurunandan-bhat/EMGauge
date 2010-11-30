#!/usr/bin/perl

use strict;
use warnings;

use lib qw{../../emgauge/lib};

use EMGauge::Main;
use EMGauge::Constants;

my $app = EMGauge::Main->new(
	cfg_file => $EMGauge::Constants::confdir . 'EMGauge.conf',
);

$app->run;

