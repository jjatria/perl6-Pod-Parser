use v6;
use Test;
plan 3;

use Pod::Parser;
ok 1, 'Loading module succeeded';

my $pp = Pod::Parser.new;
isa_ok $pp, 'Pod::Parser';

my @result = $pp.parse_file('t/files/a.pod');
is_deeply @result, Array.new(
	{type => 'text', content => "text before\n\n"},
	{type => 'pod' , content => "\n"},
	"=head1 NAME",
	{type => 'pod', content => "\nText in name\n\n"},
	"=head1 SYNOPSIS",
	{type => 'pod', content => "\n    some verbatim\n    text\n\n"},
	{type => 'text', content => "\ntext after\n\n\n"},
	), 'parse a.pod';

done;
