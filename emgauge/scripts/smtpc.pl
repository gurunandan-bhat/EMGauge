#!/usr/bin/perl

use strict;
use warnings;

use MIME::Entity;
use Email::Sender::Simple qw{sendmail};
use Email::Sender::Transport::SMTP::Persistent;

my $transport = Email::Sender::Transport::SMTP::Persistent->new({
	host => '123.201.136.153',
	port => 25,
	sasl_username => 'offers@ipfoffers.com',
	sasl_password => 'ip31415',
});

my $msg = MIME::Entity->build(
	Type => 'text/plain',
	To => 'guru@dygnos.com',
	From => 'guru@informationmatters.in',
	Subject => 'This is a Test',
	Encoding => 'quoted-printable',
	Data => 'This is the full message for the Test',
);

my ($status, $message);
eval {
	sendmail($msg, {transport => $transport});
};
if ($@) {
	die 'Failed Sending Mail: ' . $@;
}

exit;
