use v6;
class Pod::Parser;

use Pod::Parser::Common;

=begin pod

=head1 NAME

Pod::Parser - parsing files with POD in them (Perl 6 syntax)

=end pod

my $in_pod = 0;
my $in_verbatim = 0;
my $pod = '';
my $verbatim = '';
my $text = '';

has @.data;
has $.title is rw;

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
			self.end_pod;
			next;
		}

		if $in_pod {
			if $row ~~ m/^ \=TITLE \s+ (.*) $/ {
				self.end_pod;
				self.set_title($0.Str);
				next;
			}
			if $row ~~ m/^ \=(head<[12]>) \s+ (.*) $/ {
				self.end_pod;
				self.head($0.Str, $1.Str);
				next;
			}
			if $row ~~ m/^\s+\S/ {
				self.include_pod;
				$in_verbatim = 1;
			}

			if $in_verbatim {
				if $row ~~ m/^\S/ {
					self.include_verbatim;
				} else {
					$verbatim ~= "$row\n";
					next;
				}
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

# TODO throw exception objects!
method set_title($text) {
	X::Parser.new(msg => 'TITLE set twice').throw if self.title;
	X::Parser.new(msg => 'No value given for TITLE').throw if $text !~~ /\S/;
	#die 'No POD should be before TITLE' if self.data;

	$.title = $text;
	self.data.push({ type => 'title', content => $text });
	return;
}

method head($type, $text) {
	self.data.push({ type => $type, content => $text });
	return;
}

method include_text () {
	if $text ne '' {
		self.data.push({ type => 'text', content => $text });
		$text = '';
	}
}

method end_pod() {
	if $in_verbatim {
		self.include_verbatim;
	} else {
		self.include_pod;
	}
	return;
}
method include_pod () {
	if $pod ne '' {
		self.data.push({ type => 'pod', content => $pod });
		$pod = '';
	}
	return;
}

method include_verbatim () {
	if $verbatim ne '' {
		self.data.push({ type => 'verbatim', content => $verbatim });
		$verbatim = '';
	}
	$in_verbatim = 0;
	return;
}



method parse_file (Str $filename) {
	my $string = slurp($filename);
	self.parse($string);
}

# vim: ft=perl6
