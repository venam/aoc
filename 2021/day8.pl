use strict;
use warnings;
use Data::Dumper;

#   0:      1:      2:      3:      4:
#  aaaa    ....    aaaa    aaaa    ....
# b    c  .    c  .    c  .    c  b    c
# b    c  .    c  .    c  .    c  b    c
#  ....    ....    dddd    dddd    dddd
# e    f  .    f  e    .  .    f  .    f
# e    f  .    f  e    .  .    f  .    f
#  gggg    ....    gggg    gggg    ....
# 
#   5:      6:      7:      8:      9:
#  aaaa    aaaa    aaaa    aaaa    aaaa
# b    .  b    .  .    c  b    c  b    c
# b    .  b    .  .    c  b    c  b    c
#  dddd    dddd    ....    dddd    dddd
# .    f  e    f  .    f  e    f  .    f
# .    f  e    f  .    f  e    f  .    f
#  gggg    gggg    ....    gggg    gggg


# 1, 4, 7, and 8 each use a unique number of segments
# so counting digits in the output we can know what they are
# In the output values, how many times do digits 1, 4, 7, or 8 appear?

my $count = 0;
while (my $in = <>) {
	chomp $in;
	my @spaced_in = split / /, $in;
	#print Dumper(\@spaced_in);
	my @left_digits;
	my @right_digits;
	my $pos = 0;
	for (0.. (scalar(@spaced_in)-1)) {
		$pos = $_;
		if ($spaced_in[$pos] eq '|') {
			$pos++;
			last;
		}
		push @left_digits, $spaced_in[$pos];
	}
	#print Dumper($pos);
	push @right_digits, $spaced_in[$_] for ($pos.. (scalar(@spaced_in)-1));
	#print Dumper(\@left_digits);
	#print Dumper(\@right_digits);
	for (@right_digits) {
		# 1, 7, 4, 8
		if (length($_) == 2 or length($_) == 3 or length($_) == 4 or length($_) == 7) {
			$count++;
		}
	}
}

print "1,7,4,8 appear $count times\n";
