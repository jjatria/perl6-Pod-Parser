use v6;
use Test;
plan 2;

use Pod::Parser;
ok 1, 'Loading module succeeded';

my $pp = Pod::Parser.new;
isa_ok $pp, 'Pod::Parser';

done;
