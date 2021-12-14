use strict;
use warnings;
use Data::Dumper;
use Storable qw(dclone);


my $start_str = <>;
chomp $start_str;
<>;

my %substitutions;
my %char_count;
while (my $line = <>) {
	chomp $line;
	my @in = split ' -> ', $line;
	$substitutions{$in[0]} = $in[1];
}

for my $i (0..(length($start_str)-1)) {
	my $c1 = substr($start_str, $i, 1);
	$char_count{$c1} = 0 unless (exists $char_count{$c1});
	$char_count{$c1}++;
}

my %memory = (
	1 => {} # first iteration
);

for my $k (keys %substitutions) {
	$memory{1}->{$k} = {
		$substitutions{$k} => 1
	};
}

my $max_ite = 40;

sub count_recurs {
	my ($left, $right, $count) = @_;

	return {} if ($count == $max_ite);

	my $rem = $max_ite - $count;
	if (exists $memory{$rem} && exists $memory{$rem}->{$left.$right}) {
		#print "Found count for item ${left}${right} at item $rem ".Dumper($memory{$rem}->{$left.$right});
		for my $k (keys %{$memory{$rem}->{$left.$right}}) {
			$char_count{$k} = 0 unless (exists $char_count{$k});
			$char_count{$k} += $memory{$rem}->{$left.$right}->{$k};
		}
		return dclone($memory{$rem}->{$left.$right});
	}

	return {} unless (exists $substitutions{"${left}${right}"});
	my $middle = $substitutions{"${left}${right}"};
	# use memory here instead of substitutions


	# need to return the number of count per character
	my $left_vals = count_recurs($left, $middle, $count+1);
	my $right_vals = count_recurs($middle, $right, $count+1);

	$left_vals->{$middle} = 0 unless (exists $left_vals->{$middle});
	$left_vals->{$middle}++;
	$char_count{$middle} = 0 unless (exists $char_count{$middle});
	$char_count{$middle}++;

	# merge right into left
	for my $k (keys %{$right_vals}) {
		$left_vals->{$k} = 0 unless (exists $left_vals->{$k});
		$left_vals->{$k} += $right_vals->{$k};
	}

	$memory{$rem}->{$left.$right} = $left_vals;

	return dclone($left_vals);
}

for my $i (0..(length($start_str)-2)) {
	# read next 2 characters
	my $left = substr($start_str, $i, 1);
	my $right = substr($start_str, $i+1, 1);
	count_recurs($left, $right, 0);
}
print "Counts ".Dumper(\%char_count);
my ($max,$min) = (-1, 999_999_999_999_999);
for my $k (keys %char_count) {
	$max = $char_count{$k} if ($char_count{$k} > $max);
	$min = $char_count{$k} if ($char_count{$k} < $min);
}
my $diff = $max - $min;
print "Max - Min = ".$diff."\n";


