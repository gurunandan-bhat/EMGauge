package EMGauge;

use strict;
use warnings;

use base qw(CGI::Application);

use CGI::Application::Plugin::Config::Simple;
use CGI::Application::Plugin::Authentication;
use CGI::Application::Plugin::Session;
use CGI::Application::Plugin::DBH qw{dbh_config dbh};
use CGI::Application::Plugin::Redirect;
use CGI::Application::Plugin::AutoRunmode;

use POSIX qw{strftime};

sub cgiapp_init {
	
	my ($app, %params) = @_;

	$app->config_file($params{cfg_file});

	$app->html_tmpl_class('HTML::Template::Pro');
	$app->tmpl_path( $app->config_param('Path.Templates') );
	
	$app->dbh_config(
		$app->config_param('Database.DSN'),
		$app->config_param('Database.DBUser'),
		$app->config_param('Database.DBPassword'),
		{
			PrintError => 1,
			RaiseError => 1,
		}
	);
	
	$app->session_config(
		CGI_SESSION_OPTIONS => [
			$app->config_param('Session.Driver'),
			$app->query,
			{
				DataSource => $app->config_param('Database.DSN'),
				User => $app->config_param('Database.DBUser'),
				Password => $app->config_param('Database.DBPassword'),
				TableName => $app->config_param('Session.TableName'),
				IdColName => $app->config_param('Session.IdColName'),
				DataColName => $app->config_param('Session.DataColName'),
				ColumnType => 'binary',
			},
		],
		DEFAULT_EXPIRY => $app->config_param('Session.Expiry'),
		COOKIE_PARAMS => {
			-name => $app->config_param('Session.CookieName'),
			-expires => $app->config_param('Session.CookieExpires'),
		},
	);

	CGI::Session->name($app->config_param('Session.CookieName'));
	
	$app->authen->config(
		DRIVER => [
			'DBI',
			DBH => $app->dbh,
			TABLE => 'users',
			CONSTRAINTS => {
				'username' => '__CREDENTIAL_1__',
				'MD5_hex:password' => '__CREDENTIAL_2__',
				'active' => 1,
			},
		],
		STORE => 'Session',
		LOGIN_RUNMODE => 'login',
		LOGOUT_RUNMODE => 'logout',
	);
	
}

sub cgiapp_prerun {
	
	my $app = shift;
	my $rm = shift;
	
	return if ($rm eq 'login') || ($rm eq 'logout');
	
	my $set_status = sub {
		my ($c, $ht_params, $tmpl_params, $tmpl_file) = @_;

		$ht_params->{die_on_bad_params} = 0;
		
		$tmpl_params->{USERNAME} = $app->authen->username;
		$tmpl_params->{LASTLOGIN} = $app->lastlogin;
	};

	$app->add_callback('load_tmpl', $set_status);
}

sub pager {
	
	my $app = shift;
	my $page = shift;
	my $maxpage = shift;
	
	return undef unless ($maxpage > 1);

	my $url = $app->query->url(-relative => 1) || 'index.cgi';

	my @pages = map {{
		PAGE => $_, 
		LINKED => ($_ != $page)
	}} ( 1 .. $maxpage);
	
	my $pgtpl = $app->load_tmpl('default/pager.tpl', 
		die_on_bad_params => 0,
		loop_context_vars => 1,
		global_vars => 1,
	);

	$pgtpl->param(
		BASEURL => $url,
		PAGER => \@pages,
		PREVLINK => ($page > 1) ? $url . '?page=' . ($page - 1) : undef,
		NEXTLINK => ($page < $maxpage) ? $url . '?page=' . ($page + 1) : undef, 
	);
	
	return $pgtpl->output;
}

sub login : Runmode {

	my $app = shift;

	$app->redirect('index.cgi') if $app->authen->username;
	
	my $tpl = $app->load_tmpl('default/login.tpl');
	my $q = $app->query;
	my $auth = $app->authen;
	
	$tpl->param(
		DESTINATION => $q->param('destination') || $q->self_url,
		URL => $q->url(-absolute => 1, -path_info => 1),
		RAWDESTINATION => $q->param('destination') || 'None',
		SELFURL => $q->self_url,
		ATTEMPTS => $auth->login_attempts,
		USERNAME => $auth->is_authenticated ? 'Yes' : 'No',
		DEBUG => 0,
	);

	return $tpl->output;
}

sub logout : Runmode {
	my $app = shift;
	$app->redirect('index.cgi');
}

sub teardown {
	my $app = shift;
	$app->session->flush if $app->session_loaded;;
}

sub lastlogin {
	my $app = shift;

	if ($app->authen->username) {
		return strftime('%a, %d %b %y %H:%M', localtime($app->authen->last_login));
	}

	return;
}

sub cgiapp_get_query {

	use CGI::Simple qw{-default};

	$CGI::Simple::DISABLE_UPLOADS = 0;
	$CGI::Simple::POST_MAX = 12048000;

	return CGI::Simple->new()
}
   
sub errhndlr : ErrorRunmode {
	my $app = shift;
	my $err = shift;
	
	my $tpl = $app->load_tmpl('error/index.tpl');

	if (ref($err) eq 'HASH') {
		$tpl = $app->load_tmpl('async_error.tpl') if exists $err->{async};  
		$tpl->param(CLASS => $err->{type});
		$tpl->param(MSG => $err->{msg});
	}
	else {
		my $errstr = "Unexpected System Error.<br />Contact Gurunandan R. Bhat (guru\@dygnos.com) with the following error message:<br /><br />";
		$tpl->param(CLASS => 'error');
		$tpl->param(MSG => "$errstr\n$err");
	}

	return $tpl->output;
}

1;
