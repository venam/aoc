use strict;
use warnings;


my $start_str = <>;
chomp $start_str;
<>;

my %substitutions;
my %chars_h;
while (my $line = <>) {
	chomp $line;
	my @in = split ' -> ', $line;
	$substitutions{$in[0]} = $in[1];
	$chars_h{$in[1]} = 1;
	$chars_h{substr($in[0], 0, 1)} = 1;
	$chars_h{substr($in[0], 1, 1)} = 1;
}
my @char = keys %chars_h;

for (1..10) {
	my $i = 0;
	while (1) {
		# read next 2 characters
		my $curr = substr($start_str, $i, 2);
		#print "Curr = $curr\n";
		if (exists $substitutions{$curr}) {
			$start_str = substr($start_str, 0, $i+1). $substitutions{$curr}. substr($start_str, $i+1, length($start_str));
			$i++;
			#print "$start_str\n";
		}

		$i++;
		last if ($i >= length($start_str));
	}
}
#print "END TURN: $start_str\n";
my $min = 999999999;
my $max = -1;
for (@char) {
	my $count = () = $start_str =~ /\Q$_/g;
	$max = $count if ($count > $max);
	$min = $count if ($count < $min);
}
my $diff = $max - $min;
print "$max - $min = $diff\n";


