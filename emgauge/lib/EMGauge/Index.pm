package EMGauge::Index;

# use criticism 'brutal';

use strict;
use warnings;

use ex::lib qw(../);
use base qw(EMGauge);

sub setup {

	my $app = shift;
	$app->authen->protected_runmodes(':all');
}

sub home : StartRunmode {
	
	my $app = shift;

	my $tpl = $app->load_tmpl('default/index.tpl', die_on_bad_params => 0);
	return $tpl->output;
}

1