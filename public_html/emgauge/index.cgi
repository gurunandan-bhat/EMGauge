#!/usr/bin/perl

use strict;
use warnings;


use lib::abs qw{../../emgauge/lib};

use EMGauge::Dispatch;

EMGauge::Dispatch->dispatch;
