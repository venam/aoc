use strict;
use warnings;
use Data::Dumper;


my sub get_points {
	my ($line) = @_;
	my @chrs = split //, $line;
	my @stack;
	my %scores = (
		'(' => 1,
		'[' => 2,
		'{' => 3,
		'<' => 4,
	);
	for (@chrs) {
		#print Dumper(\@stack);
		if ($_ eq '{'||$_ eq '['||$_ eq '('||$_ eq '<') {
			push @stack, $_;
		} else {
			if (scalar(@stack) == 0) {
				return -1;
			}
			my $l_c = $stack[-1];
			if (
				($_ eq '}' && $l_c ne '{') ||
				($_ eq ']' && $l_c ne '[') ||
				($_ eq ')' && $l_c ne '(') ||
				($_ eq '>' && $l_c ne '<')) {
				#print "unmatched $l_c\n";
				return -1;
			}
			pop @stack;
		}
	}
	if (scalar(@stack) == 0) {
		return -1;
	}

	my $line_p = 0;
	while (scalar(@stack) > 0) {
		my $c = pop @stack;
		$line_p *= 5;
		$line_p += $scores{$c};
	}
	
	return $line_p;
}

my @all_scores;
while (my $line = <>) {
	chomp $line;
	my $points = get_points($line);
	if ($points != -1) {
		push @all_scores, $points;
	}
}
#print Dumper(\@all_scores);
@all_scores = sort { $b <=> $a } @all_scores;

print "Middle score is: ".$all_scores[scalar(@all_scores)/2]."\n";

