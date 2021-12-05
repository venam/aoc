use strict;
use warnings;
use Data::Dumper;

my $increases = 0;
my @values;
push @values, $_ while(<>);

my $curr = 0;
for (0..2) {
	$curr += $values[$_];
}

for my $i (3.. (scalar(@values)-1)) {
	#print($values[$i-3]."\n");
	#print($values[$i]."\n");


	my $next = $curr - $values[$i-3] + $values[$i];
	if ($next > $curr) {
		$increases++;
	}
	$curr = $next;
}

print $increases."\n";
