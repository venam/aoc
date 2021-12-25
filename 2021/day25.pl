use strict;
use warnings;
use Data::Dumper;

# during step, east moves first then south
# right edge of map appear left
# bottom edge of map appear top

# find step when no sea cucumber move

my %map_east;
my %map_south;
my $max_x = 0;
my $max_y = 0;
my $y = 0;
while (my $line = <>) {
	chomp $line;
	my @l = split '', $line;
	$max_x = scalar @l -1;
	for my $x (0..(scalar @l -1)) {
		if ($l[$x] eq '>') {
			$map_east{"|$x|$y|"} = 1;
		} elsif ($l[$x] eq 'v') {
			$map_south{"|$x|$y|"} = 1;
		}
	}
	$y++;
}
$max_y = $y-1;

sub dump_map {
	for my $j (0..$max_y) {
		for my $i (0..$max_x) {
			if (exists $map_east{"|$i|$j|"}) {
				print ">";
			} elsif (exists $map_south{"|$i|$j|"}) {
				print "v";
			} else {
				print ".";
			}
		}
		print "\n";
	}
}

my $nb_step = 0;
while (1) {
	my %next_map_east;
	my %next_map_south;
	#print "$nb_step\n";
	#if ($nb_step == 58) {
	#	dump_map();
	#	exit;
	#}

	my $k_east_before  = join '', sort keys %map_east;
	my $k_south_before = join '', sort keys %map_south;
	# move east
	for my $k (keys %map_east) {
		my ($n, $x,$y) = split '\|', $k;
		my $next_x = ($x+1) % ($max_x+1);
		# can't move
		if (exists $map_east{"|$next_x|$y|"} ||
			exists $map_south{"|$next_x|$y|"}) {
			$next_map_east{"|$x|$y|"} = 1;
		} else {
			$next_map_east{"|$next_x|$y|"} = 1;
		}
	}
	# move south
	for my $k (keys %map_south) {
		my ($n, $x,$y) = split '\|', $k;
		my $next_y = ($y+1) % ($max_y+1);
		# can't move
		if (exists $next_map_east{"|$x|$next_y|"} ||
			exists $map_south{"|$x|$next_y|"}) {
			$next_map_south{"|$x|$y|"} = 1;
		} else {
			$next_map_south{"|$x|$next_y|"} = 1;
		}
	}
	$nb_step++;
	my $k_east_after  = join '', sort keys %next_map_east;
	my $k_south_after = join '', sort keys %next_map_south;
	if ($k_east_after eq $k_east_before &&
		$k_south_after eq $k_south_before) {
		last;
	}
	%map_east = %next_map_east;
	%map_south = %next_map_south;
}

print "Steps needed: $nb_step\n";


