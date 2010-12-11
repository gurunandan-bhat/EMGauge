package EMGauge::Dispatch;

use strict;
use warnings;

use base qw{CGI::Application::Dispatch};

use lib::abs qw{../};
use EMGauge::Constants;

sub dispatch_args {
	
	return {
		prefix => 'EMGauge',
		args_to_new => {
			PARAMS => {
				cfgfile => $EMGauge::Constants::confdir . 'EMGauge.conf',
			},
		},
		table => [
			'' => {app => 'Index', rm => 'home'},
			'mailers/:page?' => {app => 'Mailer', rm => 'index'},
		],
		debug => 1,
	}	
}

1;
