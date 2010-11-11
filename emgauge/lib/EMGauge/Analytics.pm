package EMGauge::Analytics;

use strict;
use warnings;


use ex::lib qw(../);
use base qw(EMGauge);

use EMGaugeDB::Report;

sub setup {

	my $app = shift;
	$app->authen->protected_runmodes(':all');
}

sub view_dashboard : StartRunmode {

	my $app = shift;

	my $page = $app->query->param('page') || 1;
	my $pager = EMGaugeDB::Report->pager(
		fields => [qw/mailer name schedules scheduled delivered bounced opened clicked/],
		order_by => 'mailer desc',
		per_page => $app->config_param('View.ItemsPerPage'),
		page => $page,
	);

	my @reports;
	for my $rpt ($pager->search_where) {

		my $id = $rpt->mailer;

		push @reports, {
			MAILER => $id,
			NAME => $rpt->name,
			SCHEDULES => $rpt->schedules,
			SCHEDULED => $rpt->scheduled,
			DELIVERED => $rpt->delivered,
			BOUNCED => $rpt->bounced,
			OPENED => $rpt->opened,
			CLICKED => $rpt->clicked,
		};
	}

	my $tpl = $app->load_tmpl('dashboard/dashboard.tpl',
		die_on_bad_params => 0,
		loop_context_vars => 1,
		global_vars => 1,
	);

	$tpl->param(
		REPORTS => \@reports,
		PAGENAV => $app->pager($page, $pager->last_page),
	);

	return $tpl->output;
}


1;
