use strict;
use warnings;
use Data::Dumper;

# stops when score is at least 1000
#
# deterministic dice 1...1000
#

my $p1_pos = <>;
$p1_pos =~ m/Player \d starting position: (\d+)/;
$p1_pos = $1;
my $p2_pos = <>;
$p2_pos =~ m/Player \d starting position: (\d+)/;
$p2_pos = $1;

print "starting pos p1: $p1_pos\n";
print "starting pos p2: $p2_pos\n";

my @vals = (1..100);
my $v_pos = -1;

my $die_rolls = 0;
my $p1_score = 0;
my $p2_score = 0;
while ($p1_score <= 1000 && $p2_score <= 1000) {
	my $die_val = 0;
	print "p1 rolls: ";
	for (1..3) {
		$v_pos = ($v_pos+1) % (scalar @vals);
		$die_val += $vals[$v_pos];
		print "$vals[$v_pos] ";
	}
	$p1_pos = ($p1_pos+$die_val-1)%10+1;
	$p1_score += $p1_pos;
	print " -> space $p1_pos score $p1_score\n";
	$die_rolls += 3;
	last if $p1_score >= 1000;

	print "p2 rolls: ";
	$die_val = 0;
	for (1..3) {
		$v_pos = ($v_pos+1) % (scalar @vals);
		$die_val += $vals[$v_pos];
		print "$vals[$v_pos] ";
	}
	$p2_pos = ($p2_pos+$die_val-1)%10+1;
	$p2_score += $p2_pos;
	print " -> space $p2_pos score $p2_score\n";
	$die_rolls += 3;
}

print Dumper($p1_pos);
print Dumper($p1_score);
print Dumper($p2_pos);
print Dumper($p2_score);
print Dumper($die_rolls);

my $looser = ($p1_score < $p2_score) ? $p1_score : $p2_score;

print "Answer is: ". ($die_rolls*$looser)."\n";
