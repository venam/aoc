use strict;
use warnings;


my $pos_in = <>;
chomp $pos_in;
my @pos = split /,/, $pos_in;

# bruteforce approach

my %pos_counts;

my $max = -1;
for (@pos) {
	$pos_counts{$_} = 0 unless (exists $pos_counts{$_});
	$pos_counts{$_}++;
	if ($_ > $max) {
		$max = $_;
	}
}

my $min = 99_999_999_999;
for my $pos (0..$max) {
	my $sum = 0;
	map {
		my $diff = ($_ < $pos) ? $pos-$_ : $_-$pos;
		my $val = (($diff*($diff+1) )/2.0)*$pos_counts{$_}; # (n*(n+1))/2
		$sum += $val
	} keys %pos_counts;
	if ($sum < $min) {
		$min = $sum;
	}
}

print "MIN $min\n";

