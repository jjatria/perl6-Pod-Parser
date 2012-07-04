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
	{type => 'head2', content => "subtitle"},
	{type => 'pod', content => "\nsubtext\n\n"},
	{type => 'text', content => "\ntext after\n\n\n"},
	);

plan 4 + 2 * @expected.elems;

use Pod::Parser;
ok 1, 'Loading module succeeded';

my $pp = Pod::Parser.new;
isa_ok $pp, 'Pod::Parser';

my @result = $pp.parse_file('t/files/a.pod');
for 0 .. @expected.elems-1 -> $i {
	is @result[$i]<type>, @expected[$i]<type>, "part $i - type {@expected[$i]<type>}";
	is @result[$i]<content>, @expected[$i]<content>, "part $i - content";
}

is_deeply @result, @expected, 'parse a.pod';

try {
	$pp.parse_file('t/files/two-titles.pod');
	CATCH {
		when X::Parser {
			is $_.msg, 'TITLE set twice', 'exception on duplicate TITLE';
		}
	}
}

done;
