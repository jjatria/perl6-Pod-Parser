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
	{type => 'head1', content => 'NAME'},
	{type => 'pod', content => "\nText in name\n\n"},
	{type => 'head1', content => 'SYNOPSIS'},
	{type => 'verbatim', content => "    some verbatim\n    text\n\n"},
	{type => 'text', content => "\ntext after\n\n\n"},
	), 'parse a.pod';

done;
