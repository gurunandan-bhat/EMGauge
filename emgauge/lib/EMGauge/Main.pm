package EMGauge::Main;

use strict;
use warnings;

use lib qw{../};

use base qw{EMGauge};

sub setup {

	my $app = shift;

	$app->authen->protected_runmodes('hellop');
}


sub hello : StartRunmode {

	my $app = shift;
	my $tpl = $app->load_tmpl('default/hello.tpl', die_on_bad_params => 0);

	$tpl->param(MODE => 'Open');
	return $tpl->output;
}

sub hellop : Runmode {
	
	my $app = shift;
	my $tpl = $app->load_tmpl('default/hello.tpl', die_on_bad_params => 0);

	$tpl->param(MODE => 'Protected');
	return $tpl->output;
}

1;