use strict;
use warnings;
use Data::Dumper;


my $img_alg_ = <>;
chomp $img_alg_;
$img_alg_ =~ s/\./0/g;
$img_alg_ =~ s/#/1/g;
my @img_alg = split '', $img_alg_;

<>;

my %grid;
my $min_x = 0;
my $max_x = 0;
my $min_y = 0;
my $max_y = 0;
my $y = 0;
while (my $l = <>) {
	chomp $l;
	$l =~ s/\./0/g;
	$l =~ s/#/1/g;
	my @n = split '', $l;
	my $x = 0;
	$max_x = scalar(@n)-1;
	# sparse matrix, only keep 1s
	for my $x (0..(scalar(@n)-1)) {
		$grid{$x,$y} = $n[$x];
	}
	$max_y = $y;
	$y++;
}

my $bits_to_read = 7;
# allow reading beyond the current square
$min_x -= $bits_to_read;
$min_y -= $bits_to_read;
$max_x += $bits_to_read;
$max_y += $bits_to_read;

#print Dumper($img_alg);
#print Dumper(\%grid);

my $swapped = 0;

sub index_to_bit {
	my ($x, $y) = @_;
	my $bin = '';
	foreach my $dy (-1..1) {
		foreach my $dx (-1..1) {
			if (exists $grid{$x+$dx, $y+$dy}) {
				$bin .= $grid{$x+$dx,$y+$dy};
			} else {
				$bin .= 0;
			}
		}
	}
	$bin =~ tr/10/01/ if $swapped;
	return oct("0b$bin");
}

my $litCount;
for (1..50) {
	my %next_ite;
	$litCount = 0;
	$min_x -= 2; $min_y -= 2; $max_x += 2; $max_y += 2;
	print "default is: $swapped now\n";

	for my $y ($min_y..$max_y) {
		for my $x ($min_x..$max_x) {
			my $bit_val = index_to_bit($x, $y);
			my $next_val = $img_alg[$bit_val];
			++$litCount if $next_val == 1;
			$next_ite{$x,$y} = 1 if ($next_val == $swapped);
		}
	}

	$swapped = $img_alg[$swapped == 0 ? 0 : 511];
	%grid = %next_ite;
}

print Dumper($litCount);

