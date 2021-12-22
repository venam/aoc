use strict;
use warnings;
use Data::Dumper;
use Algorithm::Combinatorics qw(combinations permutations variations variations_with_repetition);
use Clone qw/clone/;


my $min_range = -50;
my $max_range =  50;


my %cubes;
while (my $line = <>) {
	chomp $line;
	$line =~ m/(\w+) x=(-?\d+)..(-?\d+),y=(-?\d+)..(-?\d+),z=(-?\d+)..(-?\d+)/;
	my ($action, $min_x,$max_x,$min_y,$max_y,$min_z,$max_z) = ($1,$2,$3,$4,$5,$6,$7);
	next if ($min_x < $min_range || $min_y < $min_range || $min_x < $min_range);
	next if ($max_x > $max_range || $max_y > $max_range || $max_x > $max_range);
	for my $x ($min_x..$max_x) {
		for my $y ($min_y..$max_y) {
			for my $z ($min_z..$max_z) {
				if ($action eq 'on') {
					$cubes{$x,$y,$z} = 1;
				} else {
					delete $cubes{$x,$y,$z};
				}
			}
		}
	}
}
print "total on cubes: ".scalar(keys %cubes)."\n";

