use strict;
use warnings;
use Data::Dumper;

my $fish_str = <>;
chomp $fish_str;
my @timers = split /,/,$fish_str;
@timers = map { $_+0 } @timers;

# after 80 days cycles
for (1..80) {
	my @to_add_timers;
	#print Dumper(\@timers);
	for my $i (0..scalar(@timers)-1) {
		if ($timers[$i] == 0) {
			$timers[$i] = 6;
			push @to_add_timers, 8;
		} else {
			$timers[$i]--;
		}
	}
	if (scalar(@to_add_timers) > 0) {
		for (@to_add_timers) {
			push @timers, $_;
		}
	}
}

print scalar(@timers)."\n";

