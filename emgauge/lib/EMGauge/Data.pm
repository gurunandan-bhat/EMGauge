package EMGauge::Data;

use strict;
use warnings;

use ex::lib qw(../);
use base qw(EMGauge);

use POSIX qw{strftime};

use Data::FormValidator;
use Data::Dumper;
use Data::Serializer;
use JSON;
use Date::Manip;

use HTTP::BrowserDetect;
use File::Basename qw(fileparse fileparse_set_fstype);
use Spreadsheet::ParseExcel;
use Text::CSV_XS;
use Beanstalk::Client;

use EMGauge::Utils;
use EMGaugeDB::List;
use EMGaugeDB::Listmembers;
use EMGaugeDB::XLParseQueue;

my $mapping = [
	{dbcolname => 'ccode', frname  => 'Code'},
	{dbcolname => 'firstname', frname => 'First Name'},
	{dbcolname => 'lastname', frname => 'Last Name'},
	{dbcolname => 'fullname', frname  => 'Full Name'},
	{dbcolname => 'prefix', frname => 'Prefix'},
	{dbcolname => 'email', frname => 'Email'},
	{dbcolname => 'dob', frname => 'Date of Birth'},
	{dbcolname => 'gender', frname => 'Gender'},
	{dbcolname => 'organization', frname => 'Organization'},
	{dbcolname => 'phonelandline', frname => 'Phone: Landline'},
	{dbcolname => 'altphonelandline', frname => 'Phone: Landline (Alt)'},
	{dbcolname => 'phonemobile', frname => 'Phone: Mobile'},
	{dbcolname => 'altphonemobile', frname  => 'Phone: Mobile (Alt)'},
	{dbcolname => 'city', frname => 'City'},
	{dbcolname => 'custom1', frname => 'Custom Field 1'},
	{dbcolname => 'custom2', frname => 'Custom Field 2'},
	{dbcolname => 'custom3', frname => 'Custom Field 3'},
	{dbcolname => 'custom4', frname => 'Custom Field 4'},
];


sub setup {
	my $app = shift;

	$app->authen->protected_runmodes(':all');
}

sub list : StartRunmode {
	my $app = shift;
	
	my $page = $app->query->param('page') || 1;
	my $pager = EMGaugeDB::List->pager(
		where => {active => {'!=', 0}, createdby => $app->authen->username},
		order_by => 'id desc',
		per_page => $app->config_param('View.ItemsPerPage'),
		page => $page,
	);
	
	my $tpl = $app->load_tmpl('data/list.tpl', die_on_bad_params => 0, loop_context_vars => 1);
	
	my @lists = map {{
		LISTID => $_->id,
		LISTNAME => $_->name,
		LISTSOURCE => $_->source,
		LISTCREATEDON => UnixDate($_->createdon, '%d %b \'%y'),
		LISTRECORDS => $_->records,
		LISTACTIVE => 'Yes',
	}} $pager->search_where;
	
	$tpl->param(
		LISTS => \@lists,
		PAGENAV => $app->pager($page, $pager->last_page),
	);
	
	return $tpl->output;	
}

sub save_step0 : Runmode {
	
	my $app = shift;
	my $tpl = $app->load_tmpl('data/save_step0.tpl', die_on_bad_params => 0);

	my @alllists = map {{
		LISTID => $_->id,
		LISTNAME => $_->name,
	}} EMGaugeDB::List->retrieve_from_sql('active != 0 and createdby = \'' . $app->authen->username . '\'');
	
	$tpl->param(
		ALLLISTS => \@alllists,
	);

	if (my $pqid = $app->query->param('watch')) {
		if (my $pq = EMGaugeDB::XLParseQueue->retrieve(id => $pqid)) {
			my $rows = $pq->records;
			my $listid = $pq->listid;
			my $inrows = EMGaugeDB::Listmembers->sql_inrecords->select_val($listid);
			
			$tpl->param(
				WATCHSHEETID => $pq->id,
				WATCHSHEET => EMGaugeDB::List->retrieve(id => $listid)->name,
				WATCHROWS => $rows,
				WATCHDONE => $inrows,
				WATCHPERCENT => sprintf("%.2f", $inrows * 100 / $rows),
			);
		}
	}
	return $tpl->output;
}

sub save_step1 : Runmode {
	
	my $app = shift;
	my $q = $app->query;
	
	my $dfv = {
		required => [ qw{datafile} ],
		require_some => {
			listid_or_name => [1, qw{listid list}],
		},
		dependencies => {
			name => 'listsrc',
			list => [qw{listsrc}],
		},
		filters => 'trim',
		msgs => {
			prefix => 'err_',
			any_errors => 'some_errors',
		},
	};

	my $check = Data::FormValidator->check($q, $dfv);
	my $valids = $check->valid;

	if ($check->has_invalid or $check->has_missing) {

		my $tpl = $app->load_tmpl('data/index.tpl', die_on_bad_params => 0);

		my @alllists = map {{
			LISTID => $_->id,
			LISTNAME => $_->name,
		}} EMGaugeDB::List->retrieve_from_sql('active != 0');
		
		$tpl->param(
			ALLLISTS => \@alllists,
		);
		$tpl->param($check->msgs);
		$tpl->param($valids);

		return $tpl->output;
	}
	
	my $listname =  $valids->{list} ||
		EMGaugeDB::List->retrieve(id => $valids->{listid})->name; 

	my $fname = $q->param('datafile');

	my $browser = HTTP::BrowserDetect->new();
	my $osstr = $browser->windows ? 'MSWin32' : (
		$browser->unix ? 'Unix' : (
			$browser->mac ? 'MacOS' : 'Unknown'
		)
	);
	fileparse_set_fstype($osstr);

	my $usrfldr = $app->config_param('Path.UserBase');
	my $datafldr = "$usrfldr/datafiles/xl";
	
	# Create required Folders - 
	if (-d $usrfldr and -w _) {
		check_make_path($datafldr) unless (-e $datafldr and -d _);
	}
	else {
		die({type => 'error', msg => "User Directory $usrfldr does not exist or is not wriatble!"});
	}

	my ($ofname, $odirname, $osufx) = fileparse($fname, qr/\.[^.]*/);
	my $datacpyname = "$datafldr/$ofname$osufx";
	my $upok = $app->query->upload($fname, $datacpyname);

	die({type => 'error', msg => "Error Copying File $fname to $datacpyname: " . $q->cgi_error})
		unless $upok;
	
	my $displayrows = $app->config_param('View.DisplayRows');
	my $metaxl = qkparsexl($datacpyname, $displayrows);
	
	my $opttpl = $app->load_tmpl('data/map_select.tpl');
	$opttpl->param(colmap => $mapping);
	my $optstr = $opttpl->output;
	
	my $tpl = $app->load_tmpl('data/save_step1.tpl', die_on_bad_params => 0, loop_context_vars => 1, global_vars => 1);
	$tpl->param(
		LIST => $listname,
		LISTID => $valids->{listid},
		LISTSRC => $valids->{listsrc},
		XLFNAME => $datacpyname,
		SHEETS => scalar @{$metaxl},
		METAXL => $metaxl,
		LISTOPTS => $optstr,
		DISPROWS => $displayrows,
	);

# 	return '<pre>' . Dumper($metaxl) . '</pre>';
	return $tpl->output;
}

sub qkparsexl {
	my $xlfile = shift;
	my $disprows = shift || 5;
	
	my ($hdr, $data);
	my $colcount = 0;
	my $idx;
	my $pwsidx = 0;
	
	my $rdcell = sub {
	
		my ($wb, $wsidx, $row, $col, $cell) = @_;
		return if ($row > $disprows);
	
		if ($row == 0) {
			$colcount = 0 if ($wsidx != $pwsidx);
			++$colcount;
			$hdr->[$wsidx]->[$col] = {
				colname => $cell->value || 'No Header Found',
			};
			$pwsidx = $wsidx;
		}
		else {
			$data->[$wsidx]->[$row * $colcount + $col] = {
				value => ((defined $cell->{Type}) && ($cell->{Type} eq 'Date')) ? ExcelFmt('dd/mm/yy', $cell->unformatted) : $cell->value,
			};
		}
		
	};
	
	my $parser = Spreadsheet::ParseExcel->new(CellHandler => $rdcell, NotSetCell => 1);
	my $wb = $parser->Parse($xlfile);

	die({type => 'error', msg => 'Parser Error: ' . $parser->error}) unless $wb;
	
	my $xl;
	my $wsidx = 0;
	my $metawb;

	foreach (@{$data}) {

		for my $r (0 .. $disprows-1) {
			for my $c (0 .. $colcount-1) {
				$xl->[$wsidx]->[$r]->{cols}->[$c] = $_->[($r + 1) * $colcount + $c] || {value => undef};
			}
		}

		my ($rmin, $rmax) = $wb->worksheet($wsidx)->row_range;
		
		$metawb->[$wsidx] = {
			name => $wb->worksheet($wsidx)->get_name,
			sheetnum => $wsidx + 1,
			dsetnum => $wsidx,
			totrows => $rmax - $rmin,
			rows => $disprows,
			cols => $colcount,
			headers => $hdr->[$wsidx],
			rows => $xl->[$wsidx],
		};

		++$wsidx;
	}

	return $metawb;
}

sub save_step2 : Runmode {
	
	my $app = shift;
	my $q = $app->query;
	
	my $fname = $app->query->param('xlname');

	my $listname = $q->param('listname');
	my $listid = $q->param('listid');
	my $listsrc = $q->param('listsrc');
	my $sheets = $q->param('sheets');
	my @sheetrows = $q->param('sheetrows');
	
	my $totrows = 0;
	foreach (@sheetrows) {
		$totrows += $_;
	}

	my $group;
	foreach (0 .. $sheets - 1) {
		@{$group->[$_]} = $app->query->param("group[$_]");
	}   	

#	return '<pre>' . Dumper($group) . '</pre>';
	
	my $clnt = Beanstalk::Client->new({
		server => $app->config_param('JobManager.BeanstalkServer'),
		default_tube => $app->config_param('JobManager.DefaultDataTube'),
		debug => 0,
	});

	$clnt->connect;
	die({type => 'error', msg => 'Connect to Beanstalk Server threw error: <strong>' . $clnt->error . '</strong> Please contact guru@dygnos.com with this error message'}) if $clnt->error;

	my $list = $listid ?  EMGaugeDB::List->retrieve(id => $listid) :
		EMGaugeDB::List->insert({
			name => $listname,
			source => $listsrc,
			records => 0,
			active => 1,
			filename => $fname,
			createdby => $app->authen->username,
		});

	my $srlzr = Data::Serializer->new(
		serializer => 'Storable',
		digester   => 'MD5',
		cipher     => 'DES',
		secret     => $app->config_param('Mail.DigestSekrit'),
		compress   => 1,
	);

	my $xlq = EMGaugeDB::XLParseQueue->insert({
		filename => $fname,
		listid => $list->id,
		importfields => $srlzr->serialize($group),
		records => $totrows,
		createdby => $app->authen->username,
	}) or die({type => 'error', msg => 'Could not Insert Job Description in Database'});

	my $jobh = {
		script => $app->config_param('Path.ParseXLCommand'),
		parsequeueid => $xlq->id,
		insertedon => strftime('%Y/%m/%d %H:%M:%S', localtime),
	};

	my $job = $clnt->put({
		data => $srlzr->serialize($jobh),
		ttr => 60,
	});
	
	if ($clnt->error) {
		$list->delete;
		$xlq->delete;
		die({type => 'error', msg => 'Excel Import could not be scheduled. Please contact guru@dygnos.com with the error message: ' . $clnt->error});
	}
	$xlq->bjobid($job->id);
	$xlq->update;
	
	$app->redirect('data.cgi?rm=watchlist&id=' . $xlq->id);
}

sub watchlist : Runmode {
	
	my $app = shift;
	
	my $pqid = $app->query->param('id') ||
		die({type => 'error', msg => 'No Row to Watch!'});
	my $pq = EMGaugeDB::XLParseQueue->retrieve(id => $pqid);
	
	my $rows = $pq->records;

	my $listid = $pq->listid;
	my $inrows = EMGaugeDB::Listmembers->sql_inrecords->select_val($listid);

	my $tpl = $app->load_tmpl('data/save_step2.tpl', die_on_bad_params => 0);			

	$tpl->param(
		WATCHSHEETID => $pq->id,
		WATCHSHEET => EMGaugeDB::List->retrieve(id => $listid)->name,
		WATCHROWS => $rows,
		WATCHDONE => $inrows,
		WATCHPERCENT => sprintf("%.2f", $inrows * 100 / $rows),
		WATCHSTARTTIME => $pq->schtime,
	);

	return $tpl->output;
}

sub updatewatch : Runmode {

	my $app = shift;
	my $q = $app->query;
	
	my $pqid = $q->param('pqid');
		
	if (my $pq = EMGaugeDB::XLParseQueue->retrieve(id => $pqid)) {
		my $rows = $pq->records;
		my $listid = $pq->listid;
		my $inrows = EMGaugeDB::Listmembers->sql_inrecords->select_val($listid);

		return JSON->new->encode({
			donerows => $inrows,
			donepercent => sprintf("%.2f", $inrows * 100 / $rows),
			donestatus => $pq->recordsin,
		});
	}
	else {
		return JSON->new->encode({
			donerows => 'Not Available',
			donepercent => 'Not Available',
		});
	}
}

sub download_list : Runmode {

	use Spreadsheet::WriteExcel;
	use CGI::Application::Plugin::Stream (qw/stream_file/);

	my $app = shift;

	my @selectedlists;
	@selectedlists = $app->query->param("list");

	# setup the location where the resulting xls will be stored
	my $usrfldr = $app->config_param('Path.UserBase');
	my $xlfldr = "$usrfldr/datafiles/xl/tmp";
	
	# Create required Folders - 
	if (-d $usrfldr and -w _) {
		check_make_path($xlfldr) unless (-e $xlfldr and -d _);
	}
	else {
		die({type => 'error', msg => "User Directory $usrfldr does not exist or is not wriatble!"});
	}
	

	my $xlsuffix = ".xls";
	my $fname = "EMGauge_List";	
	my $xldefname = "$xlfldr/$fname$xlsuffix";

	my $workbook = Spreadsheet::WriteExcel->new($xldefname);
	my $worksheet = $workbook->add_worksheet();

	# print the header
	for (my $t=0; $t<@$mapping; ++$t){
		$worksheet->write(0,$t, $mapping->[$t]->{'frname'});
	}

	#print the data	 - use set_sql
	my $r=1;
	DBI->trace(2);


	#return '<pre>' . Data::Dumper::Dumper(EDManageDB::Recipient->membersof(join(',',@selectedlists))) . '</pre>';
	for(EMGaugeDB::Recipient->membersof(join(', ', @selectedlists))){
		$worksheet->write($r,0,$_->ccode);
		$worksheet->write($r,1,$_->firstname);
		$worksheet->write($r,2,$_->lastname);
		$worksheet->write($r,3,$_->fullname);
		$worksheet->write($r,4,$_->prefix);
		$worksheet->write($r,5,$_->email);
		$worksheet->write($r,6,$_->dob);
		$worksheet->write($r,7,$_->gender);
		$worksheet->write($r,8,$_->organization);
		$worksheet->write($r,9,$_->phonelandline);
		$worksheet->write($r,10,$_->altphonelandline);
		$worksheet->write($r,11,$_->phonemobile);
		$worksheet->write($r,12,$_->altphonemobile);
		$worksheet->write($r,13,$_->city);
		++$r;
	}

	$workbook->close();

	if ( $app->stream_file( $xldefname ) ) {
		return;
	} else {
		return $app->error_mode();
	}

	$app->redirect('data.cgi');

}

sub delete_list : Runmode {

	my $app = shift;

	my @selectedlists = $app->query->param("list");

	for (my $i = 0; $i < @selectedlists; ++$i){

		my $list = EMGaugeDB::List->retrieve(id => $selectedlists[$i]);

		if ($list) {
			$list->active(0);
			$list->update();
		}
	}

	$app->redirect('data.cgi');
}

1;
