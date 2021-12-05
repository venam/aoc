use strict;
use warnings;

my $increases = 0;
my $first = <>;
while (<>) {
	#print("$_ - $first");
	if ($_ > $first) {
		$increases++;
	}
	$first = $_;
}
print $increases."\n";
