use strict;
use warnings;


my @values = ();
while (<>) {
	chomp $_;
	push @values, $_;
}
my $length = length($values[0]);

my @copied_values = @values;
my $cur_length = 0;
while ($cur_length < $length) {
	my $counts1 = 0;
	for my $i (@copied_values) {
		if (substr($i, $cur_length, 1) eq '1') {
			$counts1++;
		}
	}

	my $choice = ($counts1 >= (scalar(@copied_values)/2) ? '1' : '0');

	my @c_values = grep {
		substr($_, $cur_length, 1) eq $choice;
	} @copied_values;
	@copied_values = @c_values;

	$cur_length++;
	if (scalar(@copied_values) == 1) {
		last;
	}
}

my $oxygen_generator_rating = $copied_values[0];
print"$oxygen_generator_rating\n";

@copied_values = @values;
$cur_length = 0;
while ($cur_length < $length) {
	my $counts1 = 0;
	for my $i (@copied_values) {
		if (substr($i, $cur_length, 1) eq '1') {
			$counts1++;
		}
	}

	my $choice = ($counts1 < (scalar(@copied_values)/2) ? '1' : '0');

	my @c_values = grep {
		substr($_, $cur_length, 1) eq $choice;
	} @copied_values;
	@copied_values = @c_values;

	$cur_length++;
	if (scalar(@copied_values) == 1) {
		last;
	}
}

my $co2_scrubber_rating = $copied_values[0];
print"$co2_scrubber_rating\n";

my $decimal_ox = eval("0b$oxygen_generator_rating");
my $decimal_co = eval("0b$co2_scrubber_rating");

print( ($decimal_co*$decimal_ox)."\n");

