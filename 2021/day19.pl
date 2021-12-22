use strict;
use warnings;
use Data::Dumper;
use Algorithm::Combinatorics qw(combinations permutations variations variations_with_repetition);
use Clone qw/clone/;

#
# at least 12 beacons
#
# Dont know location
# Don't know rotation/direction
#

my @scanner_inputs;
my $c = 0;
while (my $l = <>) {
	next if $l =~ m/^\s$/; #skip empty lines
	chomp $l;
	if ($l =~ m/scanner (\d+)/) {
		$c = $1;
		push @scanner_inputs, [];
	} else {
		my @v = split ',', $l;
		push @{$scanner_inputs[$c]}, {
			x => $v[0],
			y => $v[1],
			z => $v[2],
			# distances to other points in the same scan
			distances => {},
		};
	}
}


sub distance {
	my ($p1, $p2) = @_;
	return   (($p1->{x} - $p2->{x})**2
		+ ($p1->{y} - $p2->{y})**2
		+ ($p1->{z} - $p2->{z})**2);
}

# for all scanners
for my $k (0..(scalar(@scanner_inputs)-1)) {
	# fill the distance from every beacon to every
	# other beacon in the same scanner
	for my $b1 (@{$scanner_inputs[$k]}) {
		for my $b2 (@{$scanner_inputs[$k]}) {
			$b1->{distances}->{distance($b1, $b2)} = 1;
		}
	}
}


my %pairs_beacons;


# now find the pairs of beacons that have 12 in commons
# they should have at least 12 distances in common
for my $k1 (0..(scalar(@scanner_inputs)-1)) {
	for my $k2 (($k1+1)..(scalar(@scanner_inputs)-1)) {
		for my $b1 (@{$scanner_inputs[$k1]}) {
			for my $b2 (@{$scanner_inputs[$k2]}) {
				my $isect = 0;
				foreach (keys %{$b1->{distances}}) {
					$isect++ if exists $b2->{distances}->{$_};
				}
				if ($isect >= 12) {
					$pairs_beacons{$k1}{$k2} = [] unless (exists $pairs_beacons{$k1}{$k2});
					push @{$pairs_beacons{$k1}{$k2}}, [
						{
							x => $b1->{x},
							y => $b1->{y},
							z => $b1->{z}
						},
						{
							x => $b2->{x},
							y => $b2->{y},
							z => $b2->{z}
						},
					];
				}
			}
		}
	}
}


my @xform;
my $itv = variations_with_repetition([-1,1], 3);
while (my $v = $itv->next) {
    my $itp = permutations(['x','y','z']);
    while (my $p = $itp->next) {
        push(@xform, [@$p,@$v]);
    }
}


my %done;
$done{0} = 1;
while (1) {
	for my $k1 (keys %pairs_beacons) {
		TRANS: for my $k2 (keys %{$pairs_beacons{$k1}}) {
			# skip if both are done already
			next if (exists $done{$k1} && exists $done{$k2});
			# skip if none are done already
			next if (!exists $done{$k1} && !exists $done{$k2});

			my $from;
			my $from_val;
			my $to;
			my $to_val;
			# only compare 2 pairs
			my $first_p  = clone($pairs_beacons{$k1}{$k2}->[0]);
			my $second_p = clone($pairs_beacons{$k1}{$k2}->[1]);
			if (exists $done{$k1}) {
				$from       = $k2;
				$from_val   = 1;
				$to         = $k1;
				$to_val     = 0;
			} else {
				$from       = $k1;
				$from_val   = 0;
				$to         = $k2;
				$to_val     = 1;
			}
			print "transforming $from into $to space\n";

			my $fp_c = clone($first_p);
			my $sp_c = clone($second_p);
			for my $trans (@xform) {
				$first_p = clone($fp_c);
				$second_p = clone($sp_c);
				# transform from point in pair 1
				$first_p->[$from_val]->{$trans->[0]} *= $trans->[3];
				$first_p->[$from_val]->{$trans->[1]} *= $trans->[4];
				$first_p->[$from_val]->{$trans->[2]} *= $trans->[5];

				# transform from point in pair 2
				$second_p->[$from_val]->{$trans->[0]} *= $trans->[3];
				$second_p->[$from_val]->{$trans->[1]} *= $trans->[4];
				$second_p->[$from_val]->{$trans->[2]} *= $trans->[5];

				# verify that the distance is the same to first point in the pair
				if (
					$first_p->[$to_val]->{x} - $first_p->[$from_val]->{$trans->[0]} == $second_p->[$to_val]->{x} - $second_p->[$from_val]->{$trans->[0]}
					&&
					$first_p->[$to_val]->{y} - $first_p->[$from_val]->{$trans->[1]} == $second_p->[$to_val]->{y} - $second_p->[$from_val]->{$trans->[1]}
					&&
					$first_p->[$to_val]->{z} - $first_p->[$from_val]->{$trans->[2]} == $second_p->[$to_val]->{z} - $second_p->[$from_val]->{$trans->[2]}) {
					my @moves = (
						$first_p->[$to_val]->{x} - $first_p->[$from_val]->{$trans->[0]},
						$first_p->[$to_val]->{y} - $first_p->[$from_val]->{$trans->[1]},
						$first_p->[$to_val]->{z} - $first_p->[$from_val]->{$trans->[2]}
					);

					print "found transformation for $from -> $to\n";
					#print Dumper($trans);
					#print Dumper(\@moves);

					for my $s (@{$scanner_inputs[$to]}) {
						delete $s->{distances};
					}
					# translate the points of from in the scanner
					# and in the pairs of beacons
					for my $s (@{$scanner_inputs[$from]}) {
						delete $s->{distances};
						$s->{$trans->[0]} *= $trans->[3];
						$s->{$trans->[1]} *= $trans->[4];
						$s->{$trans->[2]} *= $trans->[5];
						$s->{$trans->[0]} += $moves[0];
						$s->{$trans->[1]} += $moves[1];
						$s->{$trans->[2]} += $moves[2];
						my $s_x = $s->{$trans->[0]};
						my $s_y = $s->{$trans->[1]};
						my $s_z = $s->{$trans->[2]};
						$s->{x} = $s_x;
						$s->{y} = $s_y;
						$s->{z} = $s_z;
					}

					# Translate points of from in the pairs of beacons
					for my $t1 (keys %pairs_beacons) {
						for my $t2 (keys %{$pairs_beacons{$t1}}) {
							if ($t1 == $from || $t2 == $from){
								my $ind = ($t1 == $from) ? 0 : 1;
								# loop through the pairs
								for my $t3 (@{$pairs_beacons{$t1}{$t2}}) {
									$t3->[$ind]->{$trans->[0]} *= $trans->[3];
									$t3->[$ind]->{$trans->[1]} *= $trans->[4];
									$t3->[$ind]->{$trans->[2]} *= $trans->[5];
									$t3->[$ind]->{$trans->[0]} += $moves[0];
									$t3->[$ind]->{$trans->[1]} += $moves[1];
									$t3->[$ind]->{$trans->[2]} += $moves[2];
									my $s_x = $t3->[$ind]->{$trans->[0]};
									my $s_y = $t3->[$ind]->{$trans->[1]};
									my $s_z = $t3->[$ind]->{$trans->[2]};
									$t3->[$ind]->{x} = $s_x;
									$t3->[$ind]->{y} = $s_y;
									$t3->[$ind]->{z} = $s_z;
								}
							}
						}
					}

					$done{$from} = 1;
					next TRANS;
				}
			}
		}
	}
	last if scalar(keys %done) == scalar(@scanner_inputs);
}


my %final_map;
for my $k (0..(scalar(@scanner_inputs)-1)) {
	for my $b1 (@{$scanner_inputs[$k]}) {
		$final_map{$b1->{x},$b1->{y},$b1->{z}} = 1;
	}
}

print "Number of points: ".scalar(keys %final_map)."\n";
#print Dumper(\@scanner_inputs);

