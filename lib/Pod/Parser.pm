use v6;
class Pod::Parser;

=begin pod

=head1 NAME

Pod::Parser - parsing files with POD in them (Perl 6 syntax)

=end pod

my $in_pod = 0;
my $pod = '';
my $text = '';

has @.data;

method parse (Str $string) {
	my @lines = $string.split("\n");
	for @lines -> $row {
		if $row ~~ m/^\=begin \s+ pod \s* $/ {
			$in_pod = 1;
			self.include_text;
			next;
		}
		if $row ~~ m/^\=end \s+ pod \s* $/ {
			$in_pod = 0;
			self.include_pod;
			next;
		}
		if $in_pod {
			if $row ~~ m/^ \=head1 \s+ .* $/ {
				self.include_pod;
				self.data.push($row);
				next;
			}
			$pod ~= "$row\n";
			next;
		}
		$text ~= "$row\n";
	}

	# after ending all the rows:
	if $in_pod {
		die "file ended in the middle of a pod";
	}
	self.include_text;

	return self.data;
}

method include_text () {
	if $text ne '' {
		self.data.push($text);
		$text = '';
	}
}
method include_pod () {
	if $pod ne '' {
		self.data.push($pod);
		$pod = '';
	}
}

method parse_file (Str $filename) {
	my $string = slurp($filename);
	self.parse($string);
}


# vim: ft=perl6
