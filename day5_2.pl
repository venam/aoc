use strict;
use warnings;
use Data::Dumper;


my @arr;

for (1..1000) {
	my @sub = ();
	for (1..1000) {
		push @sub, 0;
	}
	push @arr, \@sub;
}

while (<>) {
	$_ =~ m/(\d+),(\d+) -> (\d+),(\d+)/;
	my ($x1,$y1,$x2,$y2) = ($1,$2,$3,$4);
	#print "$x1,$y1 -> $x2,$y2\n";

	# horizontal line
	if ($y1 == $y2) {
		my $min = ($x1 > $x2 ? $x2 : $x1);
		my $max = ($x1 > $x2 ? $x1 : $x2);
		for ($min..$max) {
			$arr[$y1]->[$_]++;
		}
	}
	# vertical line
	elsif ($x1 == $x2) {
		my $min = ($y1 > $y2 ? $y2 : $y1);
		my $max = ($y1 > $y2 ? $y1 : $y2);
		for ($min..$max) {
			$arr[$_]->[$x1]++;
		}
	}
	# diagonal line
	else {
		while ($y1 != $y2 and $x1 != $x2) {
			$arr[$y1]->[$x1]++;

			if ($y1 < $y2) {
				$y1++;
			} else {
				$y1--;
			}
			if ($x1 < $x2) {
				$x1++;
			} else {
				$x1--;
			}
		}
			$arr[$y1]->[$x1]++;
	}
}

#print Dumper(\@arr);

my $count = 0;
for my $i (@arr) {
	for my $y (@{$i}) {
		if ($y >= 2) {
			$count++;
		}
	}
}

print("COUNT: $count\n");

