use strict;
use warnings;
use Data::Dumper;


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
	#print "POS: $pos\n";
	my $sum = 0;
	map {
		if ($_ < $pos) { $sum += ($pos - $_)*$pos_counts{$_} }
		else { $sum += ($_-$pos)*$pos_counts{$_} }
	} keys %pos_counts;
	if ($sum < $min) {
		$min = $sum;
	}
}


print "MIN $min\n";


