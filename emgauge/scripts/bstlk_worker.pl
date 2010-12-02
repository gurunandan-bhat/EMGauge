#!/usr/bin/perl

use strict;
use warnings;

use Beanstalk::Client;
use Data::Serializer;

use Log::Log4perl qw{:easy};
use Parallel::ForkManager;
use Data::Dumper;
use Config::Simple;
use DBI;
use Proc::Daemon;

use lib qw{/home/nandan/workspace/EMGauge/emgauge/lib};
use EMGauge::Constants;

my $confdir = $EMGauge::Constants::confdir;
my $pidfile = $confdir . 'bstlk_worker.pid';

if ( open my $pidfh, '<', $pidfile ) {
	
	my $pid = <$pidfh>;
	if (kill 0, $pid) {
		print "PID file exists and Process is alive. I am outta here\n";
		exit;
	}
	else {
		print "All Clear! Becoming a Daemon\n";
	}
}

my $daemon = Proc::Daemon->new(
	work_dir =>  $confdir,
	pid_file => $pidfile,
);

$daemon->Init();

my $cfg = new Config::Simple($confdir . 'EMGauge.conf');
Log::Log4perl::easy_init({
	level => $DEBUG,
	file => '>> ' . $cfg->param('Path.BeanstalkLog'),
	layout => 'Beanstalk Worker %c [%d] Line No: %L: %m%n',
});

my $clnt = Beanstalk::Client->new({
	server => '127.0.0.1:11300',
	default_tube => $cfg->param('JobManager.DefaultTube'),
	debug => 1,
});

$clnt->watch($cfg->param('JobManager.DefaultTube'));
$clnt->connect || LOGDIE "Cannot Connect to Queue Manager" . $clnt->error;

my $pmgr = Parallel::ForkManager->new(5);

$pmgr->run_on_start(
	sub {
		my ($pid, $ident) = @_;
		my ($type, $dbid, $jobid) = split /\|/, $ident;
		INFO "Start $type: Burying Job $jobid with DBId $dbid";
		INFO "Start $type: Error Burying Job $jobid with DBId $dbid: " . $clnt->error 
			unless $clnt->bury($jobid);
	}
);

$pmgr->run_on_finish(
	sub {
		my ($pid, $exit_code, $ident, $sgnl) = @_;
		my ($type, $dbid, $jobid) = split /\|/, $ident;

		($exit_code == $jobid) ?
			INFO "Finish $type: Delivery for DBId $dbid and Job $jobid Completed successfully" :
			INFO "Finish $type: Delivery with DBId $dbid and JobID $jobid returned failure. Signal: $sgnl";
 
		INFO "Finish $type: Deleting Job $jobid with DBId $dbid";
		if (! $clnt->delete($jobid)) {
			INFO "Finish $type: Error Deleting Job $jobid with DBID $dbid: " . $clnt->error;
		}
	}
);

my $srlzr = Data::Serializer->new(
	serializer => 'Storable',
	digester   => 'MD5',
	cipher     => 'DES',
	secret     => $cfg->param('Mail.DigestSekrit'),
	compress   => 1,
);

	
INFINITE_LOOP:
while (1) {

	my $job = $clnt->reserve();
	next INFINITE_LOOP unless $job;

	my $data = $srlzr->deserialize($job->data);

	my $jobid = $job->id;

	my $dbid = $data->{dbid};
	my $type = $data->{type};
	my $script = $data->{script} . " -j $jobid";

	$pmgr->start("$type|$dbid|$jobid") and next;

	exec($script);
	die "Cannot execute script $script\n";
}

exit;
