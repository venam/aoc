use strict;
use warnings;
use Data::Dumper;

my @heightmap;

while (my $line = <>) {
	chomp $line;
	my @row = split //,$line;
	push @heightmap, \@row;
}
#print Dumper(\@heightmap);

# O(N) solution, passing through all values in each row
my @low_points;

my $nb_r = scalar(@heightmap);
my $nb_c = scalar(@{$heightmap[0]});
for my $i (0..($nb_r-1)) {
	for my $j (0..($nb_c-1)) {
		my $val = $heightmap[$i]->[$j];

		my $is_valid = 1;
		$is_valid = 0 if ($i > 0 && $heightmap[$i-1]->[$j] <= $val);
		$is_valid = 0 if ($i < $nb_r-1 && $heightmap[$i+1]->[$j] <= $val);
		$is_valid = 0 if ($j > 0 && $heightmap[$i]->[$j-1] <= $val);
		$is_valid = 0 if ($j < $nb_c-1 && $heightmap[$i]->[$j+1] <= $val);
		push @low_points, $val if ($is_valid);
	}
}
#print Dumper(\@low_points);

my $sum = 0;
map { $sum += $_+1 } @low_points;
print "sum of risks is: $sum\n";

