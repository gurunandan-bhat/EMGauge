#!/usr/bin/perl

use Beanstalk::Client;
use Data::Serializer;

use Log::Log4perl qw{:easy};
use Parallel::ForkManager;
use Data::Dumper;
use Config::Simple;
use DBI;
use Proc::Daemon;

Proc::Daemon::Init();

Log::Log4perl::easy_init({
	level => $DEBUG,
	file => '>> /home/nandan/beanstalk_worker.log',
	layout => 'Beanstalk Worker: %c [%d] Line No: %L: %m%n',
});

my $clnt = Beanstalk::Client->new({
	server => '127.0.0.1:11300',
	default_tube =>'emgauge',
	debug => 0,
});

$clnt->watch('emgauge');
$clnt->connect || LOGDIE "Cannot Connect to Queue Manager" . $clnt->error;

my $pmgr = Parallel::ForkManager->new(5);

$pmgr->run_on_start(
	sub {
		my ($pid, $ident) = @_;
		my ($schedule, $job) = split /\|/, $ident;
		INFO "On Start: Burying Scheduled Job $job with ScheduleID $schedule";
		INFO "On Start: Error Burying Scheduled Job $job with ScheduleID $schedule: " . $clnt->error 
			unless $clnt->bury($job);
	}
);

$pmgr->run_on_finish(
	sub {
		my ($pid, $exit_code, $ident, $sgnl) = @_;
		my ($schedule, $job) = split /\|/, $ident;

		($exit_code == $job) ?
			INFO "On Finish: Delivery for Schedule $schedule and Job $job Completed successfully" :
			INFO "On Finish: Delivery with ScheduleID $schedule and JobID $job returned failure. Signal: $sgnl";
 
		INFO "On Finish: Deleting Scheduled Job $job with ScheduleID $schedule";
		if (! $clnt->delete($job)) {
			INFO "On Finish: Error Deleting Scheduled Job $job with ScheduleID $schedule: " . $clnt->error;
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

	my $schedule = $data->{schedule};
	my $runas = $data->{runas};
	my $jobid = $job->id;

	my $script = $data->{script} . " -j $jobid'";
	
	$pmgr->start($schedule . '|' . $job->id) and next;
	exec($script);

	$pmgr->finish($job->id);
}

exit;
