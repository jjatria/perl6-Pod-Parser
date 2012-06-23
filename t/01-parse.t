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
	"\n=head1 NAME\n\nText in name\n\n=head1 SYNOPSIS\n\n    some verbatime\n    text\n\n",
	"\ntext after\n\n\n",
	), 'parse a.pod';
#say Pod::Parser::parse($case);

#say %tree;

#is_deeply(


done;
