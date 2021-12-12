use strict;
use warnings;
use Data::Dumper;

my %paths;
while (my $line = <>) {
	chomp $line;
	my ($left, $right) = split '-', $line;
	$paths{$left} = [] unless (exists $paths{$left});
	$paths{$right} = [] unless (exists $paths{$right});
	push @{$paths{$left}}, $right if $right ne 'start';
	push @{$paths{$right}}, $left if $left ne 'start';
}

my $unique_paths_count = 0;
sub find_paths {
	my ($current, $visited, $acc, $twice) = @_;
	$acc .= "$current ";

	# every possible path going from current
	for my $possible (@{$paths{$current}}) {
		my $new_twice = $twice;
		# if visited already skip
		if (exists $visited->{$possible} && defined $twice) {
			if ($possible ne $twice || $visited->{$possible} == 2) {
				next;
			}
		}
		if ($possible eq 'end') {
			#print "${acc}end\n";
			$unique_paths_count++;
			next;
		}
		my %just_visited = %{$visited};
		# lowercase, then add to visited
		if ($possible eq lc $possible) {
			if (exists $just_visited{$possible}) {
				$just_visited{$possible} = 2;
				$new_twice = $possible;
			} else {
				$just_visited{$possible} = 1;
			}
		}

		# $twice wasn't defined already
		unless (defined $new_twice) {
			# don't go twice
			find_paths($possible, \%just_visited, $acc);
			# go twice
			#$new_twice = $possible if ($possible eq lc $possible);
			#find_paths($possible, \%just_visited, $acc, $new_twice);
		} else {
			find_paths($possible, \%just_visited, $acc, $new_twice);
		}
	}
}

#print Dumper(\%paths);
my $visited = { start => 1 };
find_paths('start', $visited);
print "nb paths found: $unique_paths_count\n";

