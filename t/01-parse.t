use v6;
use Test;
plan 3;

use Pod::Parser;
ok 1, 'Loading module succeeded';

my $pp = Pod::Parser.new;
isa_ok $pp, 'Pod::Parser';

my @result = $pp.parse_file('t/files/a.pod');
is_deeply @result, Array.new(
	"text before\n\n",
	"\n",
	"=head1 NAME",
	"\nText in name\n\n",
	"=head1 SYNOPSIS",
	"\n    some verbatim\n    text\n\n",
	"\ntext after\n\n\n",
	), 'parse a.pod';

done;
