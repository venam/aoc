use strict;
use warnings;
use Data::Dumper;


sub read_bingo_card {
	#read 5x5
	# values are the values and if they are marked or not
	my $values = {};
	# card rows and columns
	my @card;

	# read it
	for my $row (0..4) {
		my $line = <>;
		chomp $line;
		my @row;
		for my $column (0..4) {
			my $num = substr($line, $column*3, 2);
			$num += 0;
			$values->{$num} = {
				marked => 0,
				row => $row,
				column => $column
			};
			push @row, $num;
		}
		push @card, \@row;
	}

	return {
		values => $values,
		card => \@card
	};
}

my $ns = <>;
chomp $ns;
my @numbers = split /,/, $ns;
#print Dumper(\@numbers);

my @cards;
while (<>) {
	my $card = read_bingo_card();
	push @cards, $card;
}

my $last_num;
my $win_card;
BINGO: for my $num (@numbers) {
	for my $card (@cards) {
		if (exists $card->{values}->{$num}) {
			$card->{values}->{$num}->{marked} = 1;

			# loop through rows
			my $win_row = 0;
			for my $r (@{$card->{card}->[
				$card->{values}->{$num}->{row}
				]}){
				last if ($card->{values}->{$r}->{marked} == 0);
				$win_row += 1;
			}
			if ($win_row == 5) {
				# save winning card and last number
				#print Dumper($card->{card}->[
				#	$card->{values}->{$num}->{row}
				#]);
				$last_num = $num;
				$win_card = $card;
				last BINGO;
			}

			# loop through columns
			my $win_col = 0;
			for my $c (@{$card->{card}}){
				my $v_at_c = $c->[$card->{values}->{$num}->{column}];
				last if ($card->{values}->{$v_at_c}->{marked} == 0);
				$win_col += 1;
			}
			if ($win_col == 5) {
				# save winning card and last number
				$last_num = $num;
				$win_card = $card;
				last BINGO;
			}
		}
	}
}

print "LAST NUM: $last_num!!\n";
my $non_marked_sum = 0;
for my $c (keys %{$win_card->{values}}) {
	unless ($win_card->{values}->{$c}->{marked}) {
		$non_marked_sum += $c;
	}
}
print "NON MARKED SUM: $non_marked_sum!!\n";
print "MULTIPLIED: ". ($non_marked_sum*$last_num)."\n";

