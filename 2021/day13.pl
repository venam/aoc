use strict;
use warnings;
use Data::Dumper;


my %dots_x;
my %dots_y;
my ($max_x,$max_y) = (0,0);
while (my $line = <>) {
	chomp $line;
	last if ($line eq '');
	my @new_dot = split ',', $line;
	$max_x = ($new_dot[0] > $max_x ? $new_dot[0] : $max_x);
	$max_y = ($new_dot[1] > $max_y ? $new_dot[1] : $max_y);
	$dots_x{$new_dot[0]} = {} unless (exists $dots_x{$new_dot[0]});
	$dots_x{$new_dot[0]}->{$new_dot[1]} = 1;
	$dots_y{$new_dot[1]} = {} unless (exists $dots_y{$new_dot[1]});
	$dots_y{$new_dot[1]}->{$new_dot[0]} = 1;
}

my @instructions;
while (my $line = <>) {
	chomp $line;
	$line =~ /^fold along (\w)=(\d+)$/;
	my $direction = $1;
	my $position = $2;
	push @instructions, {
		direction => $direction,
		position => $position
	};
}

for my $ins (@instructions) {
	print "performing fold on ". $ins->{direction}." at position ".$ins->{position}."\n";

	my %new_dots_x;
	my %new_dots_y;
	if ($ins->{direction} eq 'y') {

		# fold up
		if ($ins->{position} >= ($max_y/2.0)) {

			# what is above the fold is the same as before
			for my $p (0..($ins->{position}-1)) {
				# we move on y axis
				if (exists $dots_y{$p}) {
					$new_dots_y{$p} = $dots_y{$p};
					my $xs = $dots_y{$p};
					for my $p2 (keys %{$xs}) {
						$new_dots_x{$p2} = {} unless (exists $new_dots_x{$p2});
						$new_dots_x{$p2}{$p} = 1;
					}
				}
			}

			my $up_pos = $ins->{position} - 1;
			for my $p (($ins->{position}+1)..($max_y+1)) {
				if (exists $dots_y{$p}) {
					my $xs = $dots_y{$p};
					$new_dots_y{$up_pos} = {} unless (exists $new_dots_y{$up_pos});
					for my $p2 (keys %{$xs}) {
						$new_dots_y{$up_pos}->{$p2} = 1;
						$new_dots_x{$p2} = {} unless (exists $new_dots_x{$p2});
						$new_dots_x{$p2}->{$up_pos} = 1;
					}
				}
				$up_pos--;
			}
			$max_y -= $ins->{position}+1;
		} else {
			# fold down - TODO
		}
	} else {
		# fold left
		if ($ins->{position} >= ($max_x/2.0)) {

			# what is left of the fold is the same as before
			for my $p (0..($ins->{position}-1)) {
				# we move on y axis
				if (exists $dots_x{$p}) {
					$new_dots_x{$p} = $dots_x{$p};
					my $ys = $dots_x{$p};
					for my $p2 (keys %{$ys}) {
						$new_dots_y{$p2} = {} unless (exists $new_dots_y{$p2});
						$new_dots_y{$p2}{$p} = 1;
					}
				}
			}

			my $left_pos = $ins->{position} - 1;
			for my $p (($ins->{position}+1)..($max_x+1)) {
				if (exists $dots_x{$p}) {
					my $ys = $dots_x{$p};
					$new_dots_x{$left_pos} = {} unless (exists $new_dots_x{$left_pos});
					for my $p2 (keys %{$ys}) {
						$new_dots_x{$left_pos}->{$p2} = 1;
						$new_dots_y{$p2} = {} unless (exists $new_dots_y{$p2});
						$new_dots_y{$p2}->{$left_pos} = 1;
					}
				}
				$left_pos--;
			}


			$max_x -= $ins->{position}+1;
		} else {
			# fold right - TODO
		}
	}

	%dots_x = %new_dots_x;
	%dots_y = %new_dots_y;
	# only first fold for now
	#last;
}

my $nb_dots = 0;
for my $k (keys (%dots_y)) {
	$nb_dots += scalar(keys(%{$dots_y{$k}}));
}
print "nb dots: $nb_dots\n";
#print Dumper($max_x);
#print Dumper($max_y);
#print Dumper(\%dots_x);
#print Dumper(\%dots_y);

