use v6;
use Test;

my @expected = Array.new(
	{type => 'text', content => "text before\n\n"},
	{type => 'pod' , content => "\n"},
	{type => 'title', content => 'document POD'},
	{type => 'pod' , content => "\n"},
	{type => 'head1', content => 'NAME'},
	{type => 'pod', content => "\nText in name\n\n"},
	{type => 'head1', content => 'SYNOPSIS'},
	{type => 'pod',   content => "\n"},
	{type => 'verbatim', content => "    some verbatim\n    text\n\n"},
	{type => 'head1', content => 'OTHER'},
	{type => 'pod', content => "\nreal text\nmore text\n\n"},
	{type => 'verbatim', content => "  verbatim\n      more verb\n\n"},
	{type => 'pod', content => "text\n\n"},
	{type => 'text', content => "\ntext after\n\n\n"},
	);

plan 3 + @expected.elems;

use Pod::Parser;
ok 1, 'Loading module succeeded';

my $pp = Pod::Parser.new;
isa_ok $pp, 'Pod::Parser';

my @result = $pp.parse_file('t/files/a.pod');
for 0 .. @expected.elems-1 -> $i {
	is @result[$i], @expected[$i], "part $i - {@expected[$i]<type>}";
}

is_deeply @result, @expected, 'parse a.pod';

done;
