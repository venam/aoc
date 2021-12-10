use strict;
use warnings;
use Data::Dumper;


my sub get_points {
	my ($line) = @_;
	my @chrs = split //, $line;
	my @stack;
	my %scores = (
		')' => 3,
		']' => 57,
		'}' => 1197,
		'>' => 25137,
	);
	for (@chrs) {
		#print Dumper(\@stack);
		if ($_ eq '{'||$_ eq '['||$_ eq '('||$_ eq '<') {
			push @stack, $_;
		} else {
			if (scalar(@stack) == 0) {
				return $scores{$_};
			}
			my $l_c = $stack[-1];
			if (
				($_ eq '}' && $l_c ne '{') ||
				($_ eq ']' && $l_c ne '[') ||
				($_ eq ')' && $l_c ne '(') ||
				($_ eq '>' && $l_c ne '<')) {
				#print "unmatched $l_c\n";
				return $scores{$_};
			}
			pop @stack;
		}
	}
	#if len(stack) != 0:
	#	return "NO"
	return 0;
}

my $points = 0;
while (my $line = <>) {
	chomp $line;
	$points += get_points($line);
}
print "POINTS: $points\n";


