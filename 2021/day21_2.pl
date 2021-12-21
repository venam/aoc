use strict;
use warnings;
use Data::Dumper;
use bigint;
use Memoize;

# stops when score is at least 1000
#

my $p1_pos = <>;
$p1_pos =~ m/Player \d starting position: (\d+)/;
$p1_pos = $1;
my $p2_pos = <>;
$p2_pos =~ m/Player \d starting position: (\d+)/;
$p2_pos = $1;

memoize('play');
sub play {
	my ($current_roll, $p1_pos, $p2_pos, $p1_score, $p2_score) = @_;

	my ($p1_new_score, $p2_new_score);
	if ($current_roll == 3) {
		# rolled 3 times for player on left
		# add up where we are now
		$p1_score += $p1_pos;
		if ($p1_score >= 21) {
			# we reached the end of a universe
			return (1, 0);
		}
		# otherwise, turn is over,
		# swap players and play turns with other player
		($p2_new_score, $p1_new_score) = play(0, $p2_pos, $p1_pos, $p2_score, $p1_score);
		return ($p1_new_score, $p2_new_score);
	}

	# for every 3 possibility in the die we
	# try all possibilities in the next turn
	for my $die (1..3) {
		my $p1_next = ($p1_pos+$die-1)%10+1;
		my ($p1_univ, $p2_univ) = play($current_roll+1, $p1_next, $p2_pos, $p1_score, $p2_score);
		$p1_new_score += $p1_univ;
		$p2_new_score += $p2_univ;
	}
	return ($p1_new_score, $p2_new_score);
}


my ($g1,$g2) = play(0, $p1_pos, $p2_pos, 0, 0);
print "$g1\n";
print "$g2\n";
