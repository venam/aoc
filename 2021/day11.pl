use strict;
use warnings;
use Data::Dumper;
use Storable qw(dclone);

# every step energy level increase by 1
# if energy > 9 then flash
# adjacent also increase by 1
# after flashing -> energy level goes to zero
#
# find O(1) positions of energy level
# find O(1) positions of adjacent

my %energy_level;
$energy_level{$_} = [] for (0..9);
my %positions;

my $y = 0;
while (my $line = <>) {
	chomp $line;
	my @cols = split(//, $line);
	my $x = 0;
	for my $c (@cols) {
		push @{$energy_level{$c}}, "$x-$y";
		$positions{"$x-$y"} = $c;
		$x++;
	}
	$y++;
}

my $flashes = 0;
# how many total flashes are there after 100 steps
for my $round (1..100) {
	my %next_cycle_energy;
	$next_cycle_energy{$_} = [] for (0..9);
	my %next_cycle_positions;

	# first shift every element by 1 and keep track of what goes above 9
	my @above_9;
	for my $e (0..9) {
		if ($e == 9) {
			$next_cycle_energy{0} = $energy_level{$e};
			for my $p (@{$energy_level{$e}}) {
				$next_cycle_positions{$p} = 0;
				push @above_9, $p;
			}
		} else {
			$next_cycle_energy{$e+1} = $energy_level{$e};
			for my $p (@{$energy_level{$e}}) {
				$next_cycle_positions{$p} = $positions{$p}+1;
			}
		}
	}


	%energy_level = %next_cycle_energy;
	%positions = %next_cycle_positions;

	while (1) {
		my @new_above_9;

		# for all above 9, increment neighbor by 1 if not already in
		# positions 0
		for my $p (@above_9) {
			my ($x,$y) = split '-',$p;
			my @neighbors = (
				($x-1).'-'.($y-1),
				( $x ).'-'.($y-1),
				($x+1).'-'.($y-1),

				($x-1).'-'.$y,
				($x+1).'-'.$y,

				($x-1).'-'.($y+1),
				( $x ).'-'.($y+1),
				($x+1).'-'.($y+1)
			);
			for my $n (@neighbors) {
				if (exists $positions{$n} && $positions{$n} != 0) {
					if ($positions{$n} == 9) {
						$positions{$n} = 0;
						push @new_above_9, $n;
					} else {
						$positions{$n} += 1;
					}
				}
			}
		}

		last if (scalar(@new_above_9) == 0);
		@above_9 = @new_above_9;
	}

	# update the energy levels with new values
	$energy_level{$_} = [] for (0..9);
	for my $k (keys %positions) {
		push @{$energy_level{$positions{$k}}}, $k;
	}

	#print "ROUND: $round\n";
	#print Dumper(\%energy_level);
	#print Dumper(\%positions);

	# add all zeros/flashes
	$flashes += scalar(@{$energy_level{0}});
	#print "flashes $flashes\n";
	#exit if ($round == 10);
}

print "flashes: $flashes\n";
