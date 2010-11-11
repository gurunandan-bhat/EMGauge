#!/usr/bin/perl

use strict;
use warnings;

use Spreadsheet::ParseExcel;
use Data::Dumper;

chomp(my $fname = <>);

my $disprows = 5;

my ($hdr, $data);
my $colcount;
my ($nr, $nc);
my $idx;

my $rdcell = sub {

	my ($wb, $wsidx, $row, $col, $cell) = @_;
	return if $row > $disprows;

	if ($row == 0) {
		++$colcount;
		$hdr->[$wsidx]->[$col] = {
			colname => $cell->value || 'No Header Found',
		};
	}
	else {
		$data->[$wsidx]->[$row * $colcount + $col] = {
			value => ((defined $cell->{Type}) && ($cell->{Type} eq 'Date')) ? ExcelFmt('dd/mm/yy', $cell->unformatted) : $cell->value,
		};
	}
};

my $parser = Spreadsheet::ParseExcel->new(CellHandler => $rdcell, NotSetCell => 1);
my $wb = $parser->Parse($fname);
die "Parser Error: " . $parser->error unless $wb;

my $xl;
my $wsidx = 0;
foreach (@{$data}) {
	for my $r (0 .. $disprows-1) {
		for my $c (0 .. $colcount-1) {
			$xl->[$wsidx]->[$r]->{cols}->[$c] = $_->[($r + 1) * $colcount + $c] || {value => undef};
		}
	}
	++$wsidx;
}

print '<pre>' . Dumper($xl) . '</pre>';
print '<pre>' . Dumper($hdr) . '</pre>';

exit;
