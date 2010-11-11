#!/usr/bin/perl

use strict;
use warnings;

use lib qw{../lib};

use EMGaugeDB::Schedule;
use EMGaugeDB::Tracker;
use EMGaugeDB::MailerLog;


foreach (EMGaugeDB::Schedule->retrieve_all) {
	
	next unless my $mailer = $_->mailer;

	$mailer = $mailer->id;
	my $schedule = $_->id;
	
	next unless ($mailer && $schedule);
	
	my $scheduled = EMGaugeDB::Schedule->sql_count_scheduled->select_val($schedule);
	my $bounced = EMGaugeDB::Schedule->sql_count_bounced->select_val($schedule);
	my $delivered = $scheduled - $bounced;
	my $opened = EMGaugeDB::Tracker->sql_count_opened->select_val($schedule);
	my $clicked = EMGaugeDB::Tracker->sql_count_clicked->select_val($schedule);

	print join(':', ($scheduled, $bounced, $delivered, $opened, $clicked));
	print "\n";
	
	my $mailerlog = EMGaugeDB::MailerLog->find_or_create({
		mailer => $mailer,
		schedule => $schedule,
	});
	
	$mailerlog->scheduled($scheduled);
	$mailerlog->delivered($delivered);
	$mailerlog->bounced($bounced);
	$mailerlog->opened($opened);
	$mailerlog->clicked($clicked);

	$mailerlog->update;
	
}