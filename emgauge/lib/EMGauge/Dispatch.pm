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
			'mailer/list/:page?' => {app => 'Mailer', rm => 'index'},
			'mailer/create/start' => {app => 'Mailer', rm => 'save_step0'},
			'mailer/create/step2' => {app => 'Mailer', rm => 'save_step1'},
			'mailer/create/step3' => {app => 'Mailer', rm => 'save_step2'},
			'mailer/create/step4' => {app => 'Mailer', rm => 'save_step3'},
			'mailer/create/step5' => {app => 'Mailer', rm => 'save_step4'},
			'mailer/create/step6' => {app => 'Mailer', rm => 'save_step5'},
			'mailer/create/finish' => {app => 'Mailer', rm => 'save_mailer'},
		],
		debug => 1,
	}	
}

1;
