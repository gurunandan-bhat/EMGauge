package EMGaugeDB;

use strict;
use warnings;

use base qw(Class::DBI::mysql);

use Class::DBI::Plugin::AbstractCount;
use Class::DBI::Plugin::Pager;

use Config::Simple;

our $VERSION = '0.01';

use EMGauge::Constants;

my $cfg = new Config::Simple($EMGauge::Constants::confdir . 'EMGauge.conf');

my $dsn = $cfg->param('Database.DSN');
my $dbuser = $cfg->param('Database.DBUser');
my $dbpasswd = $cfg->param('Database.DBPassword');

__PACKAGE__->set_db(
	Main => $dsn,
	$dbuser,
	$dbpasswd,
	{
		AutoCommit => 1, 
		RaiseError => 1,
		PrintError => 1,
	},
);

1;
