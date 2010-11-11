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

#use Proc::Daemon;
#Proc::Daemon::Init();

Log::Log4perl::easy_init({
	level => $DEBUG,
	file => '>> /home/nandan/beanstalk_worker_xlparser.log',
	layout => 'Beanstalk Worker: %c [%d] Line No: %L: %m%n',
});

my $clnt = Beanstalk::Client->new({
	server => '127.0.0.1:11300',
	default_tube =>'parsexl',
	debug => 1,
});

$clnt->watch('parsexl');
$clnt->connect || LOGDIE "Cannot Connect to Queue Manager" . $clnt->error;

my $pmgr = Parallel::ForkManager->new(5);

$pmgr->run_on_start(
	sub {
		my ($pid, $ident) = @_;
		my ($pqid, $jobid) = split /\|/, $ident;
		INFO "On Start: Burying Scheduled Job $jobid with ParseID $pqid";
		INFO "On Start: Error Burying Scheduled Job $jobid with ParseID $pqid: " . $clnt->error 
			unless $clnt->bury($jobid);
	}
);

$pmgr->run_on_finish(
	sub {
		my ($pid, $exit_code, $ident, $sgnl) = @_;
		my ($pqid, $jobid) = split /\|/, $ident;

		($exit_code == $jobid) ?
			INFO "On Finish: Delivery for ParseID $pqid and Job $jobid Completed successfully" :
			INFO "On Finish: Delivery with ParseID $pqid and JobID $jobid returned failure. Signal: $sgnl";
 
		INFO "On Finish: Deleting Scheduled Job $jobid with ParseID $pqid";
		if (! $clnt->delete($jobid)) {
			INFO "On Finish: Error Deleting Scheduled Job $jobid with ParseID $pqid: " . $clnt->error;
		}
	}
);

my $srlzr = Data::Serializer->new(
	serializer => 'Storable',
	digester   => 'MD5',
	cipher     => 'DES',
	secret     => 'Vishveshwar Nagarkatti',
	compress   => 1,
);

	
INFINITE_LOOP:
while (1) {

	my $job = $clnt->reserve();
	next INFINITE_LOOP unless $job;

	my $data = $srlzr->deserialize($job->data);

	my $pqid = $data->{parsequeueid};
	my $jobid = $job->id;
	my $script = $data->{script} . " -p $pqid -j $jobid";
	
	$pmgr->start("$pqid|$jobid") and next;
	exec($script);

	$pmgr->finish($job->id);
}

exit;
