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

my %zones;

sub find_parent {
	my ($v) = @_;
	unless (exists $zones{$v}) {
		$zones{$v} = {
			parent => $v,
			count  => 1
		};
	}
	my $node = $zones{$v};
	while ($v ne $node->{parent}) {
		$v = $node->{parent};
		$node = $zones{$v};
	}
	return $node;
}


# find the 3 largest basins and multiply their sizes together
my $nb_r = scalar(@heightmap);
my $nb_c = scalar(@{$heightmap[0]});
for my $i (0..($nb_r-1)) {
	for my $j (0..($nb_c-1)) {
		my $val = $heightmap[$i]->[$j];
		next if ($val == 9); # skip 9

		my $parent = find_parent("$i-$j");

		# merge with upper zone if present
		my $adjacent1 = ($i-1)."-$j";
		if (exists $zones{$adjacent1}) {
			my $parent_ad1 = find_parent($adjacent1);
			$parent_ad1->{count}++;
			$parent->{parent} = $parent_ad1->{parent};
			$parent = $parent_ad1;
		}

		# merge with left zone if present
		my $adjacent2 = "$i-".($j-1);
		if (exists $zones{$adjacent2}) {
			my $parent_ad2 = find_parent($adjacent2);
			if ($parent_ad2->{parent} ne $parent->{parent}) {
				if ($parent->{count} > $parent_ad2->{count}) {
					$parent->{count} += $parent_ad2->{count};
					$parent_ad2->{parent} = $parent->{parent};
				} else {
					$parent_ad2->{count} += $parent->{count};
					$parent->{parent} = $parent_ad2->{parent};
				}
			}
		}
	}
}

#print Dumper(\%zones);
my @count;
for my $k (keys %zones) {
	push @count, $zones{$k}->{count};
}
@count = sort { $b <=> $a } @count;
#print Dumper(\@count);
print "max zones are: $count[0], $count[1], $count[2]\n";
print "multiply: ".($count[0]*$count[1]*$count[2])."\n";

