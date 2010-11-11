package EMGauge::Mailer;

# use criticism 'brutal';

use strict;
use warnings;

use ex::lib qw(../);
use base qw(EMGauge);

use File::Slurp qw{read_file write_file};
use File::Basename qw(fileparse fileparse_set_fstype);

use File::Spec;
use File::Path;
use File::Find;

use Storable;
use Data::UUID;
use Date::Manip;
use Data::FormValidator;

use EMGauge::Utils;
use EMGaugeDB::Campaign;
use EMGaugeDB::Mailer;

use HTML::TokeParser;
use Image::Magick;
use URI::Split;
use URI::Escape;

use MIME::Entity;
use HTML::TreeBuilder;
use Digest::SHA qw{sha1_hex};
use HTTP::BrowserDetect;
use Email::Sender::Simple qw{sendmail};
use Email::Sender::Transport::SMTP::Persistent;

use HTML::Template;
use Text::Template;

use Data::Dumper;

# TODO Overall Critical: Use encoded URLs 
our $CWD;

sub setup {

	my $app = shift;
	$app->authen->protected_runmodes(':all');
}


sub index : StartRunmode {

	my $app = shift;	

	my $page = $app->query->param('page') || 1;
	my $pager = EMGaugeDB::Mailer->pager(
		where => {createdby => $app->authen->username},
		order_by => 'id desc',
		per_page => $app->config_param('View.ItemsPerPage'),
		page => $page,
	);

	my @mailers;
	for my $mlr ($pager->search_where) {

		my $id = $mlr->id;

		my @schedules;
		@schedules = map {{
				SCHEDULEID => $_->id,
				SCHEDULEDATE => $_->scheduledfor ? UnixDate($_->scheduledfor, '%a, %d %b %y') : undef,
				SCHEDULELISTS =>  join(', ', map {$_->name} $_->lists),
		}} EMGaugeDB::Schedule->search(mailer => $id);

		my $nocache = ParseDate('now');

		push @mailers, {
			MAILERID => $id,
			MAILERNAME => $mlr->name,
			MAILERLANDINGPAGELINK => $mlr->landingpage || 'mailer.cgi?rm=create_landingpage&mailer=' . $id,
			MAILERLINK => $mlr->onlineurl . "?tstmp=$nocache",
			MAILERCAMPAIGN => EMGaugeDB::Campaign->retrieve(id => $mlr->campaign)->name,
			MAILERCREATEDON => UnixDate($mlr->createdon, '%d %b \'%y'),
			MAILERSCHEDULES => \@schedules,
		};
	}

	my $tpl = $app->load_tmpl('mailer/list.tpl',
		die_on_bad_params => 0,
		loop_context_vars => 1,
		global_vars => 1,
	);

	$tpl->param(
		MAILERS => \@mailers,
		PAGENAV => $app->pager($page, $pager->last_page),
	);

	return $tpl->output;
}

sub save_step0 : Runmode {

	my $app = shift;

	my @campaigns = map {{
		CAMPAIGNID => $_->id,
		CAMPAIGN => $_->name,
	}} EMGaugeDB::Campaign->retrieve_all;

	my $tpl = $app->load_tmpl('mailer/save_step0.tpl',
		die_on_bad_params => 0,
		loop_context_vars => 1,
		global_vars => 1,
	);

	$tpl->param(
		CAMPAIGNS => \@campaigns,
	);
	return $tpl->output;
}

sub save_step1 : Runmode {

	# TODO Better handling file type error
	# TODO Add taint mode and file size limit (1 MB)

	my $app = shift;
	my $q = $app->query;

	my $dfv = {
		required => [ qw{mailer zipfile} ],
		require_some => {
			cmpgn_id_or_name => [1, qw{campaignid campaign}],
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

		my $tpl = $app->load_tmpl('mailer/save_step0.tpl', die_on_bad_params => 0);
		$tpl->param($check->msgs);
		$tpl->param($valids);

		return $tpl->output;
	}

	my ($campaignid, $campaign);
	if (! ($campaign = $valids->{campaign}) ) {
		$campaignid = $valids->{campaignid};
		$campaign = EMGaugeDB::Campaign->retrieve(id => $campaignid)->name;
	}
	# For Old Campaigns, Both Id and Name are known here.
	# For New campaigns, only Name is known

	my $mailer = $valids->{mailer};

	my $appfldr = $app->config_param('Path.AppBase');
	my $usrfldr = $app->config_param('Path.UserBase');

	my $cmpgnfldr = "$usrfldr/$campaign";
	my $zipfldr = "$usrfldr/$campaign/zips";
	my $mlrfldr = "$usrfldr/$campaign/$mailer";

	# Create required Folders and check permissions- 
	check_make_path($usrfldr) unless (-d $usrfldr and -w _);
	check_make_path($cmpgnfldr) unless (-d $cmpgnfldr and -w _);
	check_make_path($mlrfldr) unless (-d $mlrfldr and -w _);
	check_make_path($zipfldr) unless (-d $zipfldr and -w _);

	# Try Hard to get Uploaded Filename
	my $fname = $q->param('zipfile');

	my $browser = HTTP::BrowserDetect->new();
	my $osstr = $browser->windows ? 'MSWin32' : (
		$browser->unix ? 'Unix' : (
			$browser->mac ? 'MacOS' : 'Unknown'
		)
	);
	fileparse_set_fstype($osstr);

	my ($ofname, $odirname, $osufx) = fileparse($fname, qr/\.[^.]*/);
	my $zipcpyname = "$zipfldr/$mailer$osufx";
	my $upok = $app->query->upload($fname, $zipcpyname);

	die({type => 'error', msg => "Error Copying File $fname to $zipcpyname: " . $app->query->cgi_error})
		unless $upok;

	# Step 1 - Unzip File in mailer folder
	# Step 2 - Look for an HTML file in the mailer folder and parse it.
	# Step 3 - Show a List of Images and their relative paths and the set of links to track

	if ($osufx =~ /^\.zip/i) {
		use Archive::Extract;
		my $arc;
		$arc = Archive::Extract->new(archive => $zipcpyname) or
			die({type => 'error', msg => "Eror Linking to $zipcpyname" . $arc->error});
	
		$arc->extract(to => $mlrfldr) or
			die({type => 'error', msg => "Eror Extracting $zipcpyname" . $arc->error});
	}
	elsif ($osufx =~ /^\.rar/i) {
		use File::chdir;
		use Archive::Rar;
		{
			local $CWD = $mlrfldr;
			my $rarc = Archive::Rar->new(
				-archive => $zipcpyname,
				-quiet => 1,
			);
			my $ret = $rarc->Extract();
			die({type => 'Error', msg => "Could not Extract this RAR File: $zipcpyname. Please check that this is a valid RAR archive"}) if $ret;
		}
	}

	my $htmlfile;
	my $fcount = 0;
	
	# File::Find::wanted
	my $handle_file = sub {

		my $filename = $File::Find::name;

		chmod 0644, $filename if -f $filename;
		chmod 0755, $filename if -d _;

		return 1 if (! /\.htm(l|)$/i ) or $fcount;
		
		$htmlfile =  $app->parse_htmlfile($filename);
		++$fcount;

		return 1;
	};

	File::Find::find({wanted => $handle_file, no_chdir => 0}, $mlrfldr);

	my $ustr = new Data::UUID;
	my $dfile = $usrfldr . '/tmp/' . $ustr->create_str() . '.data';

	my $mdata = {
		mailerid => undef,
		mailer => $mailer,
		campaignid => $campaignid,
		campaign => $campaign,
		htmlfile => $htmlfile,
	};

	my $res = eval {
		Storable::store($mdata, $dfile);
	};
	die({type => 'error', msg => "Fatal Error from Storable: $@"}) if $@;
	die({type => 'error', msg => "I/O Error from Storable: $!"}) if (not defined $res); 
	
	my $tpl = $app->load_tmpl('mailer/save_step1.tpl', die_on_bad_params => 0);

	$tpl->param(
		TMPDATAFILE => $dfile,
		CAMPAIGN => $campaign,
		MAILER => $mailer,
		MAILERLINK => $mdata->{htmlfile}->{relpath},
		DUMPER => undef,
	);

	return $tpl->output;
}

# STORED DATA STRUCTURE
# mailerid
# mailer
# campaignid
# campaign
# htmlfile -> (
# 	name
#	fullpath
#	relpath
#	imgs -> (src, fullsrc, url, width, height, alt, thmb, thmbw, thmbh, found, include)
#	lnks -> (myhref, href, target, title, track)
#	tplvars -> (tplvar)
# )
# attachment
# attachmentmimetype

sub parse_htmlfile {
	
	my $app = shift;
	my $filename = shift; # complete path of file

	# Use Images and Links if file has been parsed once and the data structure is passed to us

	my ($oldimgs, $oldlnks);
	if (my $mdata = shift) {
		$oldimgs = $mdata->{htmlfile}->{imgs};
		$oldlnks = $mdata->{htmlfile}->{lnks};
	}

	my $filedir = (fileparse($filename))[1]; # directory path 

	my $appfldr = $app->config_param('Path.AppBase');
	my $relpath = File::Spec->abs2rel($filedir, $appfldr); # relpath contains no leading slash (dir-separator)
	
	die ({type => 'error', msg => "Cannot open $_ in $filedir : $!"})
		unless open(my $fh, '<:utf8', $filename);

	my $p = HTML::TokeParser->new($fh);

	my @tmpimg;
	my @tmplnk;

	my %imgfiles;
	NEXTTAG:
	while (my $tag = $p->get_tag('img', 'a')) {
		if ($tag->[0] eq 'img') { # image!

			my $imgsrc = $tag->[1]->{src};
			
			# Image re-used. Update Count and move on, else mark as new.
			if (exists $imgfiles{$imgsrc}) {
				++$imgfiles{$imgsrc};
				next NEXTTAG; 
			} 
			$imgfiles{$imgsrc} = 1;
			
			my $imgpath = File::Spec->canonpath("$filedir/$imgsrc");
			my $imgrelpath = File::Spec->abs2rel($imgpath, $appfldr);

			unless (-e $imgpath) { # say does not exist and move on
				push @tmpimg, {
					src => $imgsrc,
					fullsrc => $imgpath,
					url => undef,
					width => $tag->[1]->{width},
					height => $tag->[1]->{height},
					size => undef,
					alt => $tag->[1]->{alt},
					thmb => undef,
					thmbw => undef,
					thmbh => undef,
					found => 0,
				};
				next NEXTTAG;
			}

			# Found! Get Size, Make Thumbnail (always!), Get new width, height, Save to disk.
			# TODO Is a thumbnail always required? Avoid making one when not required.
			my $thumbnail = $app->make_thumbnail($imgpath);
			my $fsize = -s _;

			# Check if image was included earlier (only used when called from save_edited_mailer)
			my $include = 0;
			if ($oldimgs) {
				foreach (@{$oldimgs}) {
					next unless $_->{fullsrc} eq $imgpath;
					$include = $_->{include};
					last;
				}
			}

			# Add to imagelist structure
			push @tmpimg, {
				src => $imgsrc,
				fullsrc => $imgpath,
				url => $imgrelpath,
				width => $tag->[1]->{width},
				height => $tag->[1]->{height},
				size => $fsize,
				alt => $tag->[1]->{alt},
				thmburl => $thumbnail->{url},
				thmbw => $thumbnail->{w},
				thmbh => $thumbnail->{h},
				found => 1,
				include => $include,
			};
		}
		elsif ($tag->[0] eq 'a') { # link!

			my $href = $tag->[1]->{href};
			next if ($href eq '#');

			my ($urischm, $uriauth, $uripath, $uriqry, $urifrgmnt) = URI::Split::uri_split($href);

			my $myhref = $urischm ? $href : "$relpath/$href";

			my $track = 0;
			if ($oldlnks) {
				foreach (@{$oldlnks}) {
					next unless $_->{href} eq $href;
					$track = $_->{track};
					last;
				}
			}

			push @tmplnk, {
				myhref => $myhref,
				href => $href,
				target => $tag->[1]->{target},
				title => $tag->[1]->{title},
				track => $track,
				show => ! ($href =~ /\{\$/),
			};
		}
	}

	# Update image count in img data structure
	foreach (@tmpimg) {
		$_->{count} = $imgfiles{$_->{src}};
	}
	
	# Look for template variables and store them:
	my $mtpl = HTML::Template->new(filename => $filename, die_on_bad_params => 0);
	my @mtplvars = map {{tplvar => $_}} ($mtpl->query());
	
	close($fh); # File handle for TokeParser


	return {
		name => File::Spec->abs2rel($filename, $filedir),
		fullpath => $filename, # TODO is crying out for URI or URI::Split!
		relpath => File::Spec->abs2rel($filename, $appfldr),
		imgs => \@tmpimg,
		lnks => \@tmplnk,
		tplvars => \@mtplvars,
	};
}

sub make_thumbnail {

	my $app = shift;
	my $imgpath = shift;

	my $imgck = Image::Magick->new();
	my $x = $imgck->Read($imgpath);
	die({type => 'error', msg => $x}) if $x;

	my $thmb = $imgck->Scale(geometry => '100x100');
	die({type => 'error', msg => $thmb}) if $thmb;

	my ($thmbw, $thmbh) = $imgck->Get('width', 'height');

	# Generate thumbnail file path
	my ($imgfname, $imgdir) = fileparse($imgpath);
	my $thmbpath = $imgdir . 'thumb_' . $imgfname;

	$thmb = $imgck->Write($thmbpath);
	die({type => 'error', msg => $thmb}) if $thmb;

	return {
		path => $thmbpath,
		url => File::Spec->abs2rel($thmbpath, $app->config_param('Path.AppBase')),
		w => $thmbw,
		h => $thmbh,
	};
}

sub save_step2 : Runmode {

	my $app = shift;
	my $q = $app->query;
	
	my $dfile = $q->param('dfile');
	my $mdata = eval{
		Storable::retrieve($dfile);
	};
	die({type => 'error', msg => "Fatal Error from Storable: $@"}) if $@;
	die({type => 'error', msg => "I/O Error from Storable: $!"}) if (not defined $mdata);
	die({type => 'error', msg => "Object from Storable not a Hash Reference"}) unless ref($mdata) eq 'HASH';

	my $dfv = {
		required => [ qw{subject sendername senderemail} ],
		filters => 'trim',
		constraints => {
			senderemail => 'email',
		},
		msgs => {
			prefix => 'err_',
			any_errors => 'some_errors',
		},
	};
		
	my $check = Data::FormValidator->check($q, $dfv);
	my $valids = $check->valid;
	
	if ($check->has_invalid or $check->has_missing) {
		
		my $tpl = $app->load_tmpl('mailer/save_step1.tpl', die_on_bad_params => 0);
		$tpl->param(
			TMPDATAFILE => $dfile,
			CAMPAIGN => $mdata->{campaign},
			MAILER => $mdata->{mailer},
			MAILERLINK => $mdata->{htmlfile}->{relpath},
		);
		$tpl->param($check->msgs);
		$tpl->param($valids);
		
		return $tpl->output;
	}
	
	$mdata->{subject} = $valids->{subject};
	$mdata->{sendername} = $valids->{sendername};
	$mdata->{senderemail} = $valids->{senderemail};
	$mdata->{replyemail} = $q->param('replyemail');
	
	my $res = eval {
		Storable::store($mdata, $dfile);
	};
	die({type => 'error', msg => "Fatal Error from Storable: $@"}) if $@;
	die({type => 'error', msg => "I/O Error from Storable: $!"}) if (not defined $res); 
	
	my $tpl = $app->load_tmpl('mailer/save_step2.tpl', die_on_bad_params => 0, loop_context_vars => 1);
	$tpl->param(
		TMPDATAFILE => $dfile,
		CAMPAIGN => $mdata->{campaign},
		MAILER => $mdata->{mailer},
		MAILERLINK => $mdata->{htmlfile}->{relpath},
		imgs => $mdata->{htmlfile}->{imgs},
		DUMPER => undef,
	);
	
	return $tpl->output;
	
}

sub save_step3 : Runmode {

	my $app = shift;
	my $q = $app->query;
	
	my $dfile = $q->param('dfile');
	my $mdata = eval{
		Storable::retrieve($dfile);
	};
	die({type => 'error', msg => "Fatal Error from Storable: $@"}) if $@;
	die({type => 'error', msg => "I/O Error from Storable: $!"}) if (not defined $mdata);
	die({type => 'error', msg => "Object from Storable not a Hash Reference"}) unless ref($mdata) eq 'HASH';

	my @incimages = $app->query->param('fileimg');
	for my $inc (@incimages) {
		$mdata->{htmlfile}->{imgs}->[$inc - 1]->{include} = 1;
	} 

	my $res = eval {
		Storable::store($mdata, $dfile);
	};
	die({type => 'error', msg => "Fatal Error from Storable: $@"}) if $@;
	die({type => 'error', msg => "I/O Error from Storable: $!"}) if (not defined $res); 
	
	my $tpl = $app->load_tmpl('mailer/save_step3.tpl', die_on_bad_params => 0, loop_context_vars => 1);
	$tpl->param(
		TMPDATAFILE => $dfile,
		CAMPAIGN => $mdata->{campaign},
		MAILER => $mdata->{mailer},
		MAILERLINK => $mdata->{htmlfile}->{relpath},
		lnks => $mdata->{htmlfile}->{lnks},
		DUMPER => undef,
	);
	
	return $tpl->output;
	
}

sub save_step4 : Runmode {

	my $app = shift;
	my $q = $app->query;
	
	my $dfile = $q->param('dfile');
	my $mdata = eval{
		Storable::retrieve($dfile);
	};
	
	die({type => 'error', msg => "Fatal Error from Storable: $@"}) if $@;
	die({type => 'error', msg => "I/O Error from Storable: $!"}) if (not defined $mdata);
	die({type => 'error', msg => "Object from Storable not a Hash Reference"}) unless ref($mdata) eq 'HASH';

	my @trklnks = $app->query->param('filelnk');
	for my $trk (@trklnks) {
		$mdata->{htmlfile}->{lnks}->[$trk - 1]->{track} = 1;
	} 

	my $res = eval {
		Storable::store($mdata, $dfile);
	};
	die({type => 'error', msg => "Fatal Error from Storable: $@"}) if $@;
	die({type => 'error', msg => "I/O Error from Storable: $!"}) if (not defined $res); 

	my $tpl = $app->load_tmpl('mailer/save_step4.tpl', die_on_bad_params => 0,);
	$tpl->param(
		TMPDATAFILE => $dfile,
		CAMPAIGN => $mdata->{campaign},
		MAILER => $mdata->{mailer},
		MAILERLINK => $mdata->{htmlfile}->{relpath},
		lnks => $mdata->{htmlfile}->{lnks},
		DUMPER => undef,
	);
	
	return $tpl->output;
	
}

sub save_step5 : Runmode {

	my $app = shift;
	my $q = $app->query;
	
	my $dfile = $q->param('dfile');
	my $mdata = eval{
		Storable::retrieve($dfile);
	};
	die({type => 'error', msg => "Fatal Error from Storable: $@"}) if $@;
	die({type => 'error', msg => "I/O Error from Storable: $!"}) if (not defined $mdata);
	die({type => 'error', msg => "Object from Storable not a Hash Reference"}) unless ref($mdata) eq 'HASH';

	if (my $attchname = $q->param('attachment')) {
		
		my $attchtype = $q->upload_info($attchname, 'mime');
		
		my $browser = HTTP::BrowserDetect->new();
		my $osstr = $browser->windows ? 'MSWin32' : (
			$browser->unix ? 'Unix' : (
				$browser->mac ? 'MacOS' : 'Unknown'
			)
		);
		fileparse_set_fstype($osstr);
		my ($ofname, $odirname, $osufx) = fileparse($attchname, qr/\.[^.]*/);
		
		my $usrfldr = $app->config_param('Path.UserBase');
		my $cmpgnfldr = $mdata->{campaign};
		my $mlrfldr = $mdata->{mailer};
		my $attchfldr = "$usrfldr/$cmpgnfldr/$mlrfldr/attachment";

		# Create required Folders and check permissions- 
		check_make_path($attchfldr) unless (-d $attchfldr and -w _);

		# Copy file to a standard location
		my $upok = $q->upload($attchname, "$attchfldr/$ofname$osufx");
		die({type => 'error', msg => "Error Copying File $attchname to $attchfldr/$ofname$osufx: " . $q->cgi_error})
			unless $upok;

		$mdata->{attachment} = "$attchfldr/$ofname$osufx";
		$mdata->{attachmentmimetype} = $attchtype;
	}
	
	my $res = eval {
		Storable::store($mdata, $dfile);
	};
	die({type => 'error', msg => "Fatal Error from Storable: $@"}) if $@;
	die({type => 'error', msg => "I/O Error from Storable: $!"}) if (not defined $res); 

	my $tpl = $app->load_tmpl('mailer/save_step5.tpl', die_on_bad_params => 0);
	$tpl->param(
		TMPDATAFILE => $dfile,
		CAMPAIGN => $mdata->{campaign},
		MAILER => $mdata->{mailer},
		MAILERLINK => $mdata->{htmlfile}->{relpath},
		DUMPER => undef,
	);
	
	return $tpl->output;
	
}

sub save_mailer : Runmode {
	
	my $app = shift;
	
	my $dfile = $app->query->param('dfile');
	my $mdata = eval{
		Storable::retrieve($dfile);
	};
	die({type => 'error', msg => "Fatal Error from Storable: $@"}) if $@;
	die({type => 'error', msg => "I/O Error from Storable: $!"}) if (not defined $mdata);
	die({type => 'error', msg => "Object from Storable not a Hash Reference"}) unless ref($mdata) eq 'HASH';

	# Get the campaign or create new if requested

	my $campaign = defined $mdata->{campaignid} ?
		EMGaugeDB::Campaign->retrieve(id => $mdata->{campaignid}) :
		EMGaugeDB::Campaign->insert({name => $mdata->{campaign}, createdby => $app->authen->username(),});

	# Now create the Mailer:
	my $mailer = $campaign->add_to_mailers({
		name => $mdata->{mailer},
		htmlfilepath => $mdata->{htmlfile}->{fullpath},
		dfilepath => $dfile,
		subject => $mdata->{subject},
		sendername => $mdata->{sendername},
		senderemail => $mdata->{senderemail},
		replytoemail => $mdata->{replyemail},
		onlineurl => $mdata->{htmlfile}->{relpath},
		attachment => $mdata->{attachment},
		attachmentmimetype => $mdata->{attachmentmimetype},
		createdby => $app->authen->username(),
	});

	for (@{$mdata->{htmlfile}->{imgs}}) {
		$mailer->add_to_images({
			src => $_->{src},
			count => $_->{count},
			fullsrc => $_->{fullsrc},
			url => $_->{url},
			width => $_->{width},
			height => $_->{height},
			size => $_->{size},
			alt => $_->{alt},
			thmb => $_->{thmb},
			thmbw => $_->{thmbw},
			thmbh => $_->{thmbh},
			found => $_->{found},
			include => $_->{include},
		});
	}
		
	for (@{$mdata->{htmlfile}->{lnks}}) {
		$mailer->add_to_links({
			myhref => $_->{myhref},
			href => $_->{href},
			target => $_->{target},
			title => $_->{title},
			track => $_->{track},
		});
	}

	# Save updated data structure for later re-use. Assign campaignid if new campaign 	

	$mdata->{campaignid} = $campaign->id unless $mdata->{campaignid};
	my $res = eval {
		Storable::store($mdata, $dfile);
	};
	die({type => 'error', msg => "Fatal Error from Storable: $@"}) if $@;
	die({type => 'error', msg => "I/O Error from Storable: $!"}) if (not defined $res); 
	
	$app->redirect('mailer.cgi');
}

sub create_landingpage : Runmode {

	my $app = shift;
	my $tpl = $app->load_tmpl('mailer/landingpage.tpl', die_on_bad_params => 1);
	
	die({type => 'error', msg => 'No Mailer Specified. Please specify a mailer that will point to this landing page.'})
		unless (my $mailerid = $app->query->param('mailer'));
		
	my $mailername = EMGaugeDB::Mailer->retrieve(id => $mailerid)->name;
	$tpl->param(
		MAILERNAME => $mailername,
		MAILERID => $mailerid,
	);
	
	return $tpl->output;
}

sub save_landingpage : Runmode {
	
	use Archive::Extract;

	# TODO Better handling file type error
	# TODO Add taint mode and file size limit (1 MB)

	my $app = shift;

	my $mailerid = $app->query->param('mailerid');
	my $mailername = $app->query->param('mailername');
	
	my $mailer = EMGaugeDB::Mailer->retrieve(id => $mailerid);
	die ({type => 'error', msg => 'Cannot Find Mailer to add Landing Page'}) unless $mailer;	

	my $appfldr = $app->config_param('Path.AppBase');
	my $usrfldr = $app->config_param('Path.UserBase');

	my $zipfldr = "$usrfldr/landingpages/$mailerid/zips";
	my $pagefldr = "$usrfldr/landingpages/$mailerid/landingpage";
	
	# Create required Folders and check permissions- 
	check_make_path($usrfldr) unless (-d $usrfldr and -w _);
	check_make_path($zipfldr) if (!(-d $zipfldr and -w _));
	check_make_path($pagefldr) if (!(-d $pagefldr and -w _));

	# Try Hard to get Uploaded Filename
	my $fname = $app->query->param('zipfile');
	 	
	my $browser = HTTP::BrowserDetect->new();
	my $osstr = $browser->windows ? 'MSWin32' : (
		$browser->unix ? 'Unix' : (
			$browser->mac ? 'MacOS' : 'Unknown'
		)
	);
	
	fileparse_set_fstype($osstr);
	my ($ofname, $odirname, $osufx) = fileparse($fname, qr/\.[^.]*/);
	my $zipcpyname = "$zipfldr/$mailer$osufx";

	my $upok = $app->query->upload('zipfile', $zipcpyname);

	die({type => 'error', msg => "Error Copying File $fname to $zipcpyname: " . $app->query->cgi_error})
		unless $upok;

	if ($osufx =~ /^\.zip/i) {
		use Archive::Extract;
		my $arc;
		$arc = new Archive::Extract(archive => $zipcpyname) or 
			die({type => 'error', msg => "Eror Linking to $zipcpyname" . $arc->error});
	
		$arc->extract(to => $pagefldr) or
			die({type => 'error', msg => "Eror Extracting $zipcpyname" . $arc->error});
	}
	elsif ($osufx =~ /^\.rar/i) {
		use File::chdir;
		use Archive::Rar;
		{
			local $CWD = $pagefldr;
			my $rarc = Archive::Rar->new(
				-archive => $zipcpyname,
				-quiet => 1,
			);
			my $ret = $rarc->Extract();
			die({type => 'Error', msg => "Could not Extract this RAR File: $zipcpyname. Please check that this is a valid RAR archive"}) if $ret;
		}
	}
		
	require File::Find;

	# File::Find uses this to handle a file that it finds

	my $handle_file = sub {
		
		chmod 0644, $File::Find::name if -f $File::Find::name;
		chmod 0755, $File::Find::name if -d _;
				
		return 1 unless ( /\.htm(l|)$/i );
		
		my $fullpath = $File::Find::dir;
		(my $relpath = $fullpath) =~ s/^\Q$appfldr\///;
	
		$mailer->landingpage($relpath . "/$_");
		$mailer->update;

		return 1;
	};
	
	File::Find::find({wanted => $handle_file, no_chdir => 0}, $pagefldr);

	$app->redirect('mailer.cgi');	
}

sub edit_mailer : Runmode {
	
	my $app = shift;
	
	die({type => 'error', msg => 'Uh! No Mailer ID was passed? I have no idea what to do!'}) 
		unless my $mailerid = $app->query->param('mailerid');
	
	die({type => 'error', msg => 'I cant find the Mailer that you want to edit!'}) 
		unless my $mailer = EMGaugeDB::Mailer->retrieve(id => $mailerid);
	
	my $filepath = $mailer->htmlfilepath;
	open my $htmlfile, "<", $filepath or
		die({type => 'error', msg => "Cannot Open File $filepath: $!"});
	
	my $content = read_file($htmlfile);

	my $tpl = $app->load_tmpl('mailer/edit_mailer.tpl', die_on_bad_params => 0);

	my ($basehref) = (fileparse($mailer->onlineurl))[1];
	$basehref = $app->config_param('URL.AppBase') . '/' . $basehref;
	
	$tpl->param(
		MAILERNAME => $mailer->name,
		MAILERID => $mailer->id,
		MAILERCONTENT => $content,
		MAILERBASEHREF => $basehref,
	);
	
	return $tpl->output;
}

sub save_edited_mailer : Runmode {
	
	my $app = shift;

	die({type => 'error', msg => 'Cannot find edited Content. Are you sure you came here from the HTML EDitor Page?'})
		unless (my $body = $app->query->param('ckeditor1'));
	
	die({type => 'error', msg => 'Cannot find the Mailer you just edited. Are you sure you came here from the HTML EDitor Page?'})
		unless (my $mailerid = $app->query->param('mailerid'));

	die({type => 'error', msg => 'Cannot find the Mailer in the Database! Something is seriously wrong. Are you sure you came here from the HTML EDitor Page?'})
		unless (my $mailer = EMGaugeDB::Mailer->retrieve(id => $mailerid));
	
	my $filename = $mailer->htmlfilepath;
	die ({type => 'error', msg => 'Cannot Write to Disk! Please ensure that you have the correct permissions to do so!'})
		unless (-w $filename);

	die({type => 'error', msg => "Could not write file"}) unless write_file($filename, $body);

	$app->redirect('mailer.cgi');
	
}

sub delete_mailer : Runmode {
	
	my $app = shift;
	
	die({type => 'error', msg => 'I cannot find the Mailer you want to delete. Are you sure you had saved this mailer?'})
		unless my $mailerid = $app->query->param('selectedmailer');

	die({type => 'error', msg => 'I cannot find the Mailer you want to delete. Are you sure you had saved this mailer?'})
		unless my $mailer = EMGaugeDB::Mailer->retrieve(id => $mailerid);
	
	my @schedules = EMGaugeDB::Schedule->search(mailer => $mailerid);
	for (@schedules) {
		$_->delete;
	}

# TODO Important! Delete the HTML File, else reappears in another campaign if name reused!!!

	my $campaign = $mailer->campaign->name;
	my $mailername = $mailer->name;
	my $mlrfldr = $app->config_param('Path.UserBase') . "/$campaign/$mailer";
	
	File::Path::remove_tree($mlrfldr);	
	
	$mailer->delete;
	
	$app->redirect('mailer.cgi');
}

sub test_mailer : Runmode {

	my $app = shift;

	my $dfile = $app->query->param('dfile') || 
		die({type => 'error', msg => 'No Data File Found!!'});
		
	my $rcpt = $app->query->param('rcpt') || 
		die({type => 'error', msg => 'No Recipient specified!!'});

	my @recipients = split(/\s*\,\s*/, $rcpt);
	
#	return '<pre>' . Dumper(\@recipients) . '</pre>';
	
	my $mdata = eval{
		Storable::retrieve($dfile);
	};
	die({type => 'error', msg => "Fatal Error from Storable: $@", async => 1}) if $@;
	die({type => 'error', msg => "I/O Error from Storable: $!", async => 1}) if (not defined $mdata);
	die({type => 'error', msg => "Object from Storable not a Hash Reference", async => 1}) unless ref($mdata) eq 'HASH';
		

	my $fname = $mdata->{htmlfile}->{fullpath};
	die({type => 'error', msg => 'Cannot Read HTML File: ' . $fname}) unless (-f $fname and -r _);


	my $baseurl = $app->config_param('URL.AppBase');
	my $mlrurl = $baseurl . '/' . $mdata->{htmlfile}->{relpath};

	my $tree = HTML::TreeBuilder->new_from_file($fname);

	my @attachments;
	my $cidx = 1;
	foreach my $img (@{$mdata->{htmlfile}->{imgs}}) {
	
		my $src = $img->{src};
		my $fullsrc = $img->{fullsrc};
		my $url = $img->{url};
		
		die({type => 'error', msg => 'Aborting!! No image found at: ' . $fullsrc}) unless -f $fullsrc;

		my @images = $tree->look_down(
			_tag => 'img',
			src => $src,
		);

		if ($img->{include}) {

			my ($imgid) = (split('/', $src))[-1];
			$imgid =~ /(.*)\.(.*)/;
			my $type = $2;
			
			my $gid = 'EMGAUGE_' .  $cidx;
			foreach (@images) {
				$_->attr(src => "cid:$gid");
			}

			push @attachments, {
				Type => "image/$type",
				Id => $gid,
				Path => $fullsrc,
			};
			$cidx++;
		}
		else {
			foreach (@images) {
				$_->attr('src', $baseurl . '/' . uri_escape($url));
			}
		}
	}

	if (exists $mdata->{attachment}) {
		push @attachments, {
			Type => $mdata->{attachmentmimetype},
			Path => $mdata->{attachment},
			Filename => (fileparse($mdata->{attachment}))[1],
		}
	}

	my $digest = sha1_hex($app->config_param('Mail.DigestSekrit') . $rcpt);
	my $unsubscribelink = $baseurl . '/user.cgi?rm=unsubscribetest&rcpt=' . uri_escape($rcpt) . qq{&id=$digest};
	my $mlrstr = $tree->as_HTML();

	$tree->delete;

	my $ttpl = Text::Template->new(TYPE => 'STRING', SOURCE => $mlrstr);
	my $count = 1;

	my $transport = Email::Sender::Transport::SMTP::Persistent->new({
		host => $app->config_param('Mail.SMTPRelay'),
		port => 25,
		sasl_username => $app->config_param('Mail.AuthUser'),
		sasl_password => $app->config_param('Mail.AuthPass'),
	});

	foreach(@recipients) {
		
		my $msg = MIME::Entity->build(
			Type => 'multipart/related',
			To => $_,
			From => $mdata->{sendername} . '<' . $mdata->{senderemail} . '>',
			'Reply-To' => $mdata->{replyemail},
			Subject => $mdata->{subject},
		);
	
		my $digest = sha1_hex($app->config_param('Mail.DigestSekrit') . $_);
		
		$msg->attach(
			Type => 'text/html',
			Data => $ttpl->fill_in(HASH => {
				unsubscribelink => $baseurl . '/user.cgi?rm=unsubscribe&rcpt=' . uri_escape($_) . '&digest=' . $digest,
				viewonlinelink => $mlrurl,
			}),
			Encoding => 'quoted-printable',
		);
	
		for (@attachments) {
			$msg->attach(
				Type => $_->{Type},
				Id => '<' . $_->{Id} . '>',
				Path => $_->{Path},
				Disposition => 'inline',
				Encoding => 'base64',
			);
		}
	
		my ($status, $message);
		eval {
			sendmail($msg, {transport => $transport});
		};
		if ($@) {
			return 'Failed Sending Mail: ' . $@;
		}
	}
	return 'Mail sent successfully. Check your Inbox';
}


1;
