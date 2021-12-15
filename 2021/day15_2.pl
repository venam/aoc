use strict;
use warnings;
use Data::Dumper;
use Storable qw(dclone);

my @vals;
while (my $line = <>) {
	chomp $line;
	my @cols = split //, $line;
	push @vals, \@cols;
}

my $max_row = scalar(@vals)-1;
my $max_col = scalar(@{$vals[0]})-1;

my @bigger_vals;
for (0..($max_row*5)) {
	my @dum;
	for (0..($max_col*5)) {
		push @dum, -1;
	}
	push @bigger_vals, \@dum;
}

for my $y (0..$max_row) {
	my @cols = @{$vals[$y]};
	for my $x (0..$max_col) {
		for my $inc_x (1..5) {
			for my $inc_y(1..5) {
				my $new_val = ($cols[$x]+$inc_x-1+$inc_y-1-1)%9 +1;
				my $new_x = $x+(($inc_x-1)*($max_col+1));
				my $new_y = $y+(($inc_y-1)*($max_row+1));
				$bigger_vals[$new_y]->[$new_x] = $new_val;
			}
		}
	}
}

@vals = @bigger_vals;
$max_row = scalar(@vals)-1;
$max_col = scalar(@{$vals[0]})-1;

# represent it in a graph
my %graph;
# {
#  "x-y: {
#      value: something,
#      neighbors: {
#         "x-y": 1, "x-y": 1
#      }
#  },
# }
for my $y (0..$max_row) {
	my @cols = @{$vals[$y]};
	for my $x (0..$max_col) {
		$graph{$x.'-'.$y} = {
			value => $cols[$x],
			neighbors => [],
			dist => 999_999_999_999,
		};
		push(@{$graph{"$x-$y"}->{neighbors}}, ($x-1)."-$y") if ($x-1 >= 0);
		push(@{$graph{"$x-$y"}->{neighbors}}, ($x+1)."-$y") if ($x+1 <= $max_col);
		push(@{$graph{"$x-$y"}->{neighbors}}, "$x-".($y-1)) if ($y-1 >= 0);
		push(@{$graph{"$x-$y"}->{neighbors}}, "$x-".($y+1)) if ($y+1 <= $max_row);
	}
}


my %sptSet;

my %mins;
sub min_dist {
	my $node;
	my $min = 999_999_999_999;
	for my $k (keys %mins) {
		if ($mins{$k} < $min) {
			$min = $mins{$k};
			$node = $k
		}
	}
	#print "found min node: $node\n";
	return $node;
}


my $end = "$max_col-$max_row";
my $start = "0-0";
$mins{$start} = 0;
$graph{$start}->{dist} = 0;

#print Dumper(\%graph);

for my $k (keys %graph) {
	my $x = min_dist();
	delete $mins{$x};
	# put in the shortest path tree
	$sptSet{$x} = 1;
	last if ($x eq "$end");

	# update dist value of adjacent vertices of the picked vertex
	my @adjacent = @{$graph{$x}->{neighbors}};
	for my $n (@adjacent) {
		next if (exists $sptSet{$n});
		if ($graph{$n}->{dist} > $graph{$x}->{dist}+$graph{$n}->{value}) {
			$graph{$n}->{dist} = $graph{$x}->{dist}+$graph{$n}->{value};
			$mins{$n} = $graph{$n}->{dist};
		}
	}
}

print Dumper($graph{"$end"}->{dist});

