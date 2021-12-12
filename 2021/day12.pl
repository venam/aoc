use strict;
use warnings;
use Data::Dumper;

my %paths;
while (my $line = <>) {
	chomp $line;
	my ($left, $right) = split '-', $line;
	$paths{$left} = [] unless (exists $paths{$left});
	$paths{$right} = [] unless (exists $paths{$right});
	push @{$paths{$left}}, $right;
	push @{$paths{$right}}, $left;
}

my $unique_paths_count = 0;
sub find_paths {
	my ($current, $visited) = @_;
	#print "$current\n";

	# every possible path going from current
	for my $possible (@{$paths{$current}}) {
		# if visited already skip
		next if (exists $visited->{$possible});
		if ($possible eq 'end') {
			#print "end\n";
			$unique_paths_count++;
			next;
		}
		my %just_visited = %{$visited};
		$just_visited{$possible} = 1 if ($possible eq lc $possible);
		find_paths($possible, \%just_visited);
	}
}

#print Dumper(\%paths);
my $visited = { start => 1 };
find_paths('start', $visited);
print "nb paths found: $unique_paths_count\n";


