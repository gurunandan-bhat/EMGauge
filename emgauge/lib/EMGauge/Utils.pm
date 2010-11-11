package EMGauge::Utils;

use strict;
use warnings;

use base qw{Exporter};
use File::Path qw(make_path);

our @EXPORT = qw{check_make_path};


sub check_make_path {
	
	my $fldr = shift;
	my $err;

	make_path($fldr, {
		mode => oct('0775'),
		error => \$err,
	});
	
	if (@$err) {
		for my $diag (@$err) {
			my ($file, $messsage) = %$diag;
			if ($file eq '') {
				die({type => 'error', msg => "General Error: $messsage"});
			}
			else {
				die({type => 'error', msg => "Error processing $file: $messsage"});
			}
		} 
	}
	return 1;
}

1;
