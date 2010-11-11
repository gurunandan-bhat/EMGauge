package EMGauge::User;

use strict;
use warnings;

use lib qw{../};

use base qw{EMGauge};

use EMGaugeDB::User;
use EMGaugeDB::Images;
use EMGaugeDB::Tracker;

use Data::FormValidator;
use Digest::MD5 qw {md5_hex};

use Digest::SHA qw{sha1_hex};

use MIME::Entity;
use Email::Sender::Simple  qw{sendmail};
use Email::Sender::Transport::SMTP::Persistent;

sub setup {

	my $app = shift;

	$app->authen->protected_runmodes('changepassword');
}

sub register : StartRunmode {

	my $app = shift;
	my $q = $app->query;
	
	my $tpl = $app->load_tmpl('default/register.tpl', die_on_bad_params => 0);
	return $tpl->output unless $q->param('register');
	
	my $dfv = {
		required => [ qw{fullname username email password rptpassword} ],
		constraints => {
			email => 'email',
			password => {
				name => 'pwdlength',
				constraint => sub {my $p = length(shift); ($p > 5) && ($p < 19); },
				params => 'password',
			},
			rptpassword => {
				name => 'pwdmatch',
				constraint => sub {my ($p, $rp) = @_; $p eq $rp;},
				params => [ qw{password rptpassword} ],
			},
		},
		filters => 'trim',
		msgs => {
			prefix => 'err_',
			any_errors => 'some_errors',
			constraints => {
				pwdlength => 'Must be between 6 &amp; 18 letters',
				pwdmatch => 'Must match Password above',
				email => 'Not a valid address',
			},
		},
	};
	
	my $check = Data::FormValidator->check($q, $dfv);
	my $valids = $check->valid;
	
	if ($check->has_invalid or $check->has_missing) {


		$tpl->param($check->msgs);
		$tpl->param($valids);

		return $tpl->output;
	}
	
	if (EMGaugeDB::User->search(username => $valids->{username})) {
		$tpl->param($valids);
		$tpl->param(DUPERROR => 1);
		return $tpl->output;
	};
	
	EMGaugeDB::User->insert({
		fullname => $valids->{fullname},
		username => $valids->{username},
		email => $valids->{email},
		password => md5_hex($valids->{password}),
		active => 1,
	});
	
	$tpl = $app->load_tmpl('default/registerthanks.tpl', die_on_bad_params => 0);
	$tpl->param($valids);
	
	return $tpl->output;
}


sub forgotpassword : Runmode {
	
	my $app = shift;
	my $q = $app->query;
	
	my $tpl = $app->load_tmpl('default/forgotpassword.tpl', die_on_bad_params => 0);
	return $tpl->output unless $q->param('forgotpassword');

	my $dfv = {
		required => 'email',
		constraints => {
			email => 'email',
		},
		filters => 'trim',
		msgs => {
			prefix => 'err_',
			any_errors => 'some_errors', 
			constraints => {
				email => 'Not a valid address',
			},
		},
	};

	my $check = Data::FormValidator->check($q, $dfv);
	my $valids = $check->valid;
	
	if ($check->has_invalid or $check->has_missing) {

		$tpl->param($check->msgs);
		$tpl->param($valids);

		return $tpl->output;
	}
	
	my @user;
	unless (@user = EMGaugeDB::User->search(email => $valids->{email})) {
		$tpl->param($valids);
		$tpl->param(NONEERROR => 1);
		return $tpl->output;
	};

	my $digest = md5_hex($app->config_param('Mail.DigestSekrit') . $valids->{email});
	my $mailtpl = $app->load_tmpl('default/forgotpassword_message.tpl', die_on_bad_params => 0);

	my $transport = Email::Sender::Transport::SMTP::Persistent->new({
		host => $app->config_param('Mail.SMTPRelay'),
		port => $app->config_param('Mail.SMTPPort'),
		sasl_username => $app->config_param('Mail.AuthUser'),
		sasl_password => $app->config_param('Mail.AuthPass'),
	});

	foreach (@user) {
		
		my $id = $_->id;
		my $fullname = $_->fullname;
		my $username = $_->username;

		my $digest = md5_hex($app->config_param('Mail.DigestSekrit') . $valids->{email} . $_->password);
		my $link = $app->config_param('URL.AppBase') . '/user.cgi?rm=resetpassword&id=' . $id . '&digest=' . $digest;
		
		$mailtpl->param(
			FULLNAME => $fullname,
			USERNAME => $username,
			RESETLINK => $link,
		);
		
		my $msg = MIME::Entity->build(
			Type => 'text/plain',
			To => $valids->{email},
			From => $app->config_param('Mail.AdminSender'),
			Subject => 'Your request for a Password Reset',
			Data => $mailtpl->output,
		);
		
		eval {
			sendmail($msg, {transport => $transport});
		};

		die({type => 'error', msg => "Cannot Sent Mail: $@"}) if $@;
	}
	
	my $acktpl = $app->load_tmpl('default/forgotpassword_ack.tpl', die_on_bad_params => 0);
	$acktpl->param($valids);
	
	return $acktpl->output;
}

sub resetpassword : Runmode {
	
	my $app = shift;
	my $q = $app->query;
	
	my $id = $q->param('id');
	my $digest = $q->param('digest');
	
	return $app->load_tmpl('default/illegal_request.tpl')->output 
		unless (($id =~ /^\d+$/) and $digest);

	my $user = EMGaugeDB::User->retrieve(id => $id);

	return $app->load_tmpl('default/illegal_request.tpl')->output 
		unless (md5_hex($app->config_param('Mail.DigestSekrit') . $user->email . $user->password) eq $digest);
	
	my $tpl = $app->load_tmpl('default/resetpassword.tpl', die_on_bad_params => 0);
	$tpl->param(
		FULLNAME => $user->fullname,
		USERNAME => $user->username,
		ID => $id,
		DIGEST => $digest,
	);

	return $tpl->output unless $q->param('reset');

	my $dfv = {
		required => [ qw{password rptpassword} ],
		constraints => {
			password => {
				name => 'pwdlength',
				constraint => sub {my $p = length(shift); ($p > 5) && ($p < 19); },
				params => 'password',
			},
			rptpassword => {
				name => 'pwdmatch',
				constraint => sub {my ($p, $rp) = @_; $p eq $rp;},
				params => [ qw{password rptpassword} ],
			},
		},
		filters => 'trim',
		msgs => {
			prefix => 'err_',
			any_errors => 'some_errors', 
			constraints => {
				'pwdlength' => 'Not bet. 6 &amp; 18 chars',
				'pwdmatch' => 'Must match Password above',
			},
		},
	};
	
	my $check = Data::FormValidator->check($q, $dfv);
	my $valids = $check->valid;
	
	if ($check->has_invalid or $check->has_missing) {

		$tpl->param($check->msgs);
		$tpl->param($valids);

		return $tpl->output;
	}
	
	$user->password( md5_hex($valids->{password}) );
	$user->update;
	
	$tpl = $app->load_tmpl('default/resetdone.tpl', die_on_bad_params => 0);
	$tpl->param(
		FULLNAME => $user->fullname,
		USERNAME => $user->username,
	);
	
	return $tpl->output;
}

sub changepassword : Runmode {
	
	my $app = shift;
	my $q = $app->query;
	
	return $app->load_tmpl('default/illegal_request.tpl')->output 
		unless (my $uname = $app->authen->username);

	my ($user) = EMGaugeDB::User->search(username => $uname);
	
	my $tpl = $app->load_tmpl('default/changepassword.tpl', die_on_bad_params => 0);
	$tpl->param(
		FULLNAME => $user->fullname,
		USERNAME => $user->username,
	);

	return $tpl->output unless $q->param('change');

	my $dfv = {
		required => [ qw{password rptpassword} ],
		constraints => {
			password => {
				name => 'pwdlength',
				constraint => sub {my $p = length(shift); ($p > 5) && ($p < 19); },
				params => 'password',
			},
			rptpassword => {
				name => 'pwdmatch',
				constraint => sub {my ($p, $rp) = @_; $p eq $rp;},
				params => [ qw{password rptpassword} ],
			},
		},
		filters => 'trim',
		msgs => {
			prefix => 'err_',
			any_errors => 'some_errors', 
			constraints => {
				'pwdlength' => 'Not bet. 6 &amp; 18 chars',
				'pwdmatch' => 'Must match Password above',
			},
		},
	};
	
	my $check = Data::FormValidator->check($q, $dfv);
	my $valids = $check->valid;
	
	if ($check->has_invalid or $check->has_missing) {

		$tpl->param($check->msgs);
		$tpl->param($valids);

		return $tpl->output;
	}
	
	$user->password( md5_hex($valids->{password}) );
	$user->update;
	
	$app->authen->logout;
	
	$tpl = $app->load_tmpl('default/changedone.tpl', die_on_bad_params => 0);
	$tpl->param(
		FULLNAME => $user->fullname,
		USERNAME => $user->username,
	);
	
	return $tpl->output;
}

sub chkuname : Runmode {
	
	my $app = shift;
	my $uname = $app->query->param('uname');
	
	return EMGaugeDB::User->search(username => $uname) ?
		'<span style="color: red; font-weight: bold;">Not Available. Already Taken</span>' :
		'<span style="color: green; font-weight: bold;">Available!</span>';
		
}


sub sendimg : Runmode {
	
	my $app = shift;
	my $q = $app->query;
	
	my $sch = $q->param('scheduleid');
	my $mlr = $q->param('mailerid');
	my $img = $q->param('imgid');
	my $rcpt = $q->param('rcpt');
	
	my $valid = ($sch and $mlr and $img and $rcpt);
	
	$valid = $valid and ($sch =~ /^\d+$/);
	$valid = $valid and ($mlr =~ /^\d+$/);
	$valid = $valid and ($img =~ /^\d+$/);
	$valid = $valid and ($rcpt =~ /^\d+$/);
	
	my $image = EMGaugeDB::Images->retrieve(id => $img);
	
	return '' unless ($valid and $image);

	EMGaugeDB::Tracker->insert({
		recipient => $rcpt,
		mailer => $mlr,
		schedule => $sch,
		objtype => 'image',
		obj => $img,
	});

	use CGI::Application::Plugin::Stream qw/stream_file/;
	if (my $imgfile = $image->fullsrc) {
		$app->stream_file($imgfile);
	};

	return;
}

sub tracklink : Runmode {
	
	my $app = shift;
	my $q = $app->query;

	my $sch = $q->param('scheduleid');
	my $mlr = $q->param('mailerid');
	my $lnk = $q->param('linkid');
	my $rcpt = $q->param('rcpt');
	
	my $valid = ($sch and $mlr and $lnk and $rcpt);

	$valid = $valid and ($sch =~ /^\d+$/);
	$valid = $valid and ($mlr =~ /^\d+$/);
	$valid = $valid and ($lnk =~ /^\d+$/);
	$valid = $valid and ($rcpt =~ /^\d+$/);
	
	my $link = EMGaugeDB::Links->retrieve(id => $lnk);
	
	return '' unless ($valid and $link);
	
	EMGaugeDB::Tracker->insert({
		recipient => $rcpt,
		mailer => $mlr,
		schedule => $sch,
		objtype => 'link',
		obj => $lnk,
	});
	
	$app->redirect($link->href);
	
	return;
}

sub unsubscribetest : Runmode {
	
	my $app = shift;

	my $rcpt = $app->query->param('rcpt');
	my $digest = $app->query->param('digest');
	
	my $email = EMGaugeDB::Recipient->retrieve(id => $rcpt)->email;
	
	my $testdigest = sha1_hex($app->config_param('Mail.DigestSekrit') . $email);

	my $tpl = $app->load_tmpl('unsubscribetest.tpl', die_on_bad_params => 0);

	
	my $success;
	if ($digest eq $testdigest) {
		$success = 1;
	}

	$tpl->param(
		RCPT => $rcpt,
		DIGEST => $digest,
		TESTDIGEST => $testdigest,
		SUCCESS => $success,
	);
	return $tpl->output;
}

sub unsubscribe : Runmode {	
	
	my $app = shift;
	
	my $rcpt = $app->query->param('rcpt');
	my $digest = $app->query->param('digest');

	die({type => 'error', msg => 'Sorry, We cannot unsubscribe you with incomplete information. Please click on a link sent to you in our communication' . "$rcpt $digest"})
		unless $rcpt && $digest;

	die ({type => 'error', msg => 'Sorry, we do not have your email in our Database. Please click on a link sent to in our communication  . "$rcpt $digest"'}) 
		unless (my $user = EMGaugeDB::Recipient->retrieve(id => $rcpt));
		
	die ({type => 'error', msg => 'Sorry, We cannot unsubscribe you with incomplete information. Please click on a link sent to you in our communication' . "$rcpt $digest"}) 
		unless ($digest eq sha1_hex($app->config_param('Mail.DigestSekrit') . $user->email));
	
	my $tpl = $app->load_tmpl('unsubscribe/ipf_unsubscribe.tpl', die_on_bad_params => 0);

	$tpl->param(
		EMAIL => $user->email,
		RCPT => $rcpt,
		DIGEST => $digest,
	);
	
	return $tpl->output;
}

sub trulyunsubscribe : Runmode {
	
	my $app = shift;
	
	my $rcpt = $app->query->param('rcpt');
	my $digest = $app->query->param('digest');
	my $email = $app->query->param('email');

	die({type => 'error', msg => 'Sorry, We cannot unsubscribe you with incomplete information. Please click on a link sent to you in our communication' . "$rcpt|$digest"})
		unless $rcpt && $digest;

	die ({type => 'error', msg => 'Sorry, we do not have your email in our Database. Please click on a link sent to in our communication  . "$rcpt||$digest"'}) 
		unless (my $user = EMGaugeDB::Recipient->retrieve(id => $rcpt));
		
	die ({type => 'error', msg => 'Sorry, We cannot unsubscribe you with incomplete information. Please click on a link sent to you in our communication' . "$rcpt|||$digest"}) 
		unless ($digest eq sha1_hex($app->config_param('Mail.DigestSekrit') . $user->email));
	
	$user->set(unsubscribed => 1);
	$user->update;
		
	return $app->redirect('http://ipfonline.com/');
}

sub addcomment : Runmode {
	
	my $app = shift;

	my $tpl = $app->load_tmpl('comment.tpl', die_on_bad_params => 0);
	
	my $mlrid = $app->query->param('mlrid');
	my $email = $app->query->param('email');
	my $digest = $app->query->param('digest');
	
	my $mailer = EMGaugeDB::Mailer->retrieve(id => $mlrid);
	
	die ({type => 'error', msg => 'Sorry, You cannot add comments you with incomplete information about yourself. Please click on a link sent to you in our communication' . "$email|||$digest"}) 
		unless ($digest eq sha1_hex($app->config_param('Mail.DigestSekrit') . $email));

	my $qry = "select
				rtrim(ltrim(body)) tightbody,
				score,
				date_format(commentedon, '%a %e %b, %Y %H:%i') dated
			from
				comments
			where 
				mailer = ?
			order by 
				commentedon desc";	

	my $sth = $app->dbh->prepare($qry);
	$sth->execute($mlrid);

	my @comments;
	while (my $row = $sth->fetchrow_hashref) {
		push @comments, $row;
	}
		
	$tpl->param(
		MLRID => $mlrid,
		EMAIL => $email,
		DIGEST => $digest,
		COMMENTS => \@comments,
	);

	return $tpl->output;
}

sub savecomment : Runmode {
	
	my $app = shift;

	my $tpl = $app->load_tmpl('comment.tpl', die_on_bad_params => 0);
	
	my $mlrid = $app->query->param('mlrid');
	my $email = $app->query->param('email');
	my $digest = $app->query->param('digest');

	my $title = $app->query->param('subject');
	my $rating = $app->query->param('rating');
	my $comments = $app->query->param('comments');
		
	my $mailer = EMGaugeDB::Mailer->retrieve(id => $mlrid);
	
	die ({type => 'error', msg => 'Sorry, You cannot add comments you with incomplete information about yourself. Please click on a link sent to you in our communication' . "$email|||$digest"}) 
		unless ($digest eq sha1_hex($app->config_param('Mail.DigestSekrit') . $email));
		
	EMGaugeDB::Comment->insert({
		mailer => $mlrid,
		email => $email,
		title => $title,
		body => $comments,
		score => $rating,
	});
	
	my $qry = "select
				rtrim(ltrim(body)) tightbody,
				score,
				date_format(commentedon, '%a %e %b, %Y %H:%i') dated
			from
				comments
			where 
				mailer = ?
			order by 
				commentedon desc";	

	my $sth = $app->dbh->prepare($qry);
	$sth->execute($mlrid);

	my @comments;
	while (my $row = $sth->fetchrow_hashref) {
		push @comments, $row;
	}
		
	$tpl->param(
		SUBMITTED => 1,
		EMAIL => $email,
		TITLE => $title,
		BODY => $comments,
		RATING => $rating,
		COMMENTS => \@comments,
	);

	return $tpl->output;
}

1;