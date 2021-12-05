use strict;
use warnings;


my @values = ();
while (<>) {
	chomp $_;
	push @values, $_;
}

my $length = scalar @values;

my @counts;
my $inverter = "0b";
for (1..length($values[0])) {
	push @counts, 0;
	$inverter .= "1";
}

for my $i (@values) {
	for my $v (0..length($i)) {
		if (substr($i, $v, 1) eq '1') {
			$counts[$v]++;
		}
	}
}

my $gamma_rate = '';

for my $i (@counts) {
	if ($i >= (scalar(@values)/2)) {
		$gamma_rate .= '1';
	} else {
		$gamma_rate .= '0';
	}
}

print $length."\n";
print "$gamma_rate\n";


my $decimal_gamma_rate = eval("0b$gamma_rate");
$inverter = eval("$inverter");
my $decimal_epsilon_rate = $decimal_gamma_rate ^ $inverter;
print "$decimal_gamma_rate\n";
print "$decimal_epsilon_rate\n";
print( ($decimal_epsilon_rate*$decimal_gamma_rate)."\n");

