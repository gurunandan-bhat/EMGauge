#!/usr/bin/perl

use strict;
use warnings;

use lib qw{../../emgauge/lib};

use EMGauge::User;
use EMGauge::Constants;

my $app = EMGauge::User->new(
	cfg_file => $EMGauge::Constants::confdir . 'EMGauge.conf',
);

$app->run;
