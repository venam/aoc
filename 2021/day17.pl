use strict;
use warnings;
use Data::Dumper;



#
# The probe's x position increases by its x velocity.
# The probe's y position increases by its y velocity.
# Due to drag, the probe's x velocity changes by 1 toward the value 0; that is, it decreases by 1 if it is greater than 0, increases by 1 if it is less than 0, or does not change if it is already 0.
# Due to gravity, the probe's y velocity decreases by 1.
#
# should be within target area after any step
#
# Probe starts at 0,0
#

# highest y

sub simulate {
	my ($min_x, $max_x, $min_y, $max_y, $v_x, $v_y) = @_;
	# initial position
	my ($x, $y) = (0,0);
	my $high_y = -999_999_999_999;
	while (1) {
		$x += $v_x;
		$y += $v_y;
		#print "$x - $y\n";
		$high_y = ($y > $high_y ? $y : $high_y);

		if ($v_x != 0) {
			$v_x-- if ($v_x > 0);
			$v_x++ if ($v_x < 0);
		}
		$v_y--;

		# check if within boundary
		if ($y <= $max_y && $y >= $min_y &&
			$x <= $max_x && $x >= $min_x) {
			return $high_y;
		}
		last if ($y < $min_y);
	}

	# min val
	return -999_999_999_999;
}

my $in = <>;
chomp $in;
$in =~ m/target area: x=(-?\d+)\.\.(-?\d+), y=(-?\d+)\.\.(-?\d+)/;
my ($min_x, $max_x, $min_y, $max_y) = ($1,$2,$3,$4);
#print "$min_x $max_x $min_y $max_y\n";

my $high_y = 0;
for my $v_x (1..$max_x) {
	for my $v_y (0..(-$min_y)) {
		#print Dumper($min_x, $max_x, $min_y, $max_y, $v_x, $v_y);
		my $h = simulate($min_x, $max_x, $min_y, $max_y, $v_x, $v_y);
		if ($h > $high_y) {
			#print "$v_x - $v_y -> $h\n";
			$high_y = $h;
		}
		#print "\n\n";
	}
}

print "$high_y\n";

