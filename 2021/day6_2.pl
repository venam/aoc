use strict;
use warnings;
use Data::Dumper;

my $fish_str = <>;
chomp $fish_str;
my @timers = split /,/,$fish_str;

# instead of linear array, use a hash
my %fish = (
	0 => 0,
	1 => 0,
	2 => 0,
	3 => 0,
	4 => 0,
	5 => 0,
	6 => 0,
	7 => 0,
	8 => 0
);

for (@timers) {
	$fish{$_}++;
}

# after 256 days cycles
for (1..256) {
	#print Dumper(\%fish);

	my %next_round = (
		0 => 0,
		1 => 0,
		2 => 0,
		3 => 0,
		4 => 0,
		5 => 0,
		6 => 0,
		7 => 0,
		8 => 0
	);
	for (0..8) {
		if ($_-1 == -1) {
			$next_round{8}+= $fish{0};
			$next_round{6}+= $fish{0};
		} else {
			$next_round{$_-1} += $fish{$_}
		}
	}
	%fish = %next_round;
}


my $count;
$count += $fish{$_} for (keys %fish);
print "$count\n";

