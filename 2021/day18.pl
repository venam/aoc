use strict;
use warnings;
use POSIX qw/ceil floor/;
use Data::Dumper;


#
# Addition is joining in a bigger array
# Reduction, either:
#	If any pair is nested inside four pairs, the leftmost such pair explodes.
#	If any regular number is 10 or greater, the leftmost such regular number splits.
#	During reduction, at most one action applies, after which the process returns to the top of the list of actions.
#
# Explosion:
#	Pair's left value is added to the first regular number to the left of the exploding pair (if any)
#	Pair's right value is added to the first regular number to the right of the exploding pair (if any)
#	Exploding pairs will always consist of two regular numbers.
#	Then, the entire exploding pair is replaced with the regular number 0.
#	
#	Example: [[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]] becomes [[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]] (the pair [3,2] is unaffected because the pair [7,3] is further to the left; [3,2] would explode on the next action).
#
# Split:
#	Replace it with a pair
#	The left element of the pair should be the regular number divided by two and rounded down
#	The right element of the pair should be the regular number divided by two and rounded up
#	Example: 10 becomes [5,5], 11 becomes [5,6], 12 becomes [6,6], and so on.
#
#
# To check whether it's the right answer, check the magnitude of the final sum.
# The magnitude of a pair is 3 times the magnitude of its left element plus 2 times the magnitude of its right element.
# The magnitude of a regular number is just that number.
#

# consume first line as start
my $final = <>;
chomp $final;

while (my $line = <>) {
	chomp $line;
	$final = add($final, $line);
}

print "$final\n";
my $sol = magnitude($final);
print "$sol\n";

sub add {
	my ($left, $right) = @_;
	my $new = "[$left,$right]";

	# continue the reduction until no more changes
	while (1)
	{
		my $prev = $new;
		$new = r_explosion($prev);
		next if ($prev ne $new);

		$new = r_split($new);
		next if ($prev ne $new);

		return $new;
	}
}

# Explosion:
#	Pair's left value is added to the first regular number to the left of the exploding pair (if any)
#	Pair's right value is added to the first regular number to the right of the exploding pair (if any)
#	Exploding pairs will always consist of two regular numbers.
#	Then, the entire exploding pair is replaced with the regular number 0.
#	
#	Example: [[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]] becomes [[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]] (the pair [3,2] is unaffected because the pair [7,3] is further to the left; [3,2] would explode on the next action).
#
sub r_explosion {
	my ($s) = @_;
	my $nb_left_parent = 0;

	my $exploding_pos = -1;
	my $exploding_pos_right = -1;
	my $first_left_num = -1;
	my $first_right_num = -1;

	my @chars = $s =~ m/(\[|\]|,|\d+)/g;
	my $len = scalar(@chars);

	my $i = 0;
	while ($i < $len) {
		if ($chars[$i] eq ',') {
			$i++; next;
		} elsif ($chars[$i] eq '[') {
			$nb_left_parent++;
		} elsif ($chars[$i] eq ']') {
			$nb_left_parent--;
		} else {
		# if it's a number
		#if ($chars[$i] =~ /\d+/) {
			if ($exploding_pos != -1) {
				$first_right_num = $i;
				# we're done found first right pos
				last;
			}
			if ($nb_left_parent < 5 && $exploding_pos == -1) {
				$first_left_num = $i;
			}
			# in need of explosion and haven't found one yet
			if ($nb_left_parent == 5 && $exploding_pos == -1) {
				$exploding_pos = $i;
				$exploding_pos_right = $i+2;
				# skip the right num
				$i += 2;
			}
		}
		$i++;
	}
	# no explosion happened
	return $s if ($exploding_pos == -1);

	#print "pair to explode: $chars[$exploding_pos], $chars[$exploding_pos_right]\n";

	# rejoin the array with the changes
	my $output = '';
	# if there's a left position then put everything before it and add
	# the left of the exploding pair
	if ($first_left_num != -1) {
		$output .= join('', @chars[0..($first_left_num-1)]);
		$output .= int($chars[$first_left_num] + $chars[$exploding_pos]);
		$output .= join('', @chars[($first_left_num+1)..($exploding_pos-2)]);
	} else {
		$output .= join('', @chars[0..($exploding_pos-2)]);
	}
	# exploding pos become 0, without brackets
	$output .= '0';
	# the pair becomes 0
	# if there's a right pos
	if ($first_right_num != -1) {
		$output .= join('', @chars[($exploding_pos_right+2)..($first_right_num-1)]);
		$output .= int($chars[$first_right_num] + $chars[$exploding_pos_right]);
		$output .= join('', @chars[($first_right_num+1)..($len-1)]);
	} else {
		$output .= join('', @chars[($exploding_pos_right+2)..($len-1)]);
	}

	return $output;
}

sub r_split {
	my ($s) = @_;
	# split first 2 digits number
	$s =~ s|(\d\d)|'['.floor($1/2).','.ceil($1/2).']'|e;
	return $s;
}

sub magnitude {
	my ($s) = shift;
	# while there are still pair
	# swap pairs by 3 * left side + 2 * right side
	# remove parenthesis also and put the result instead
	while ($s =~ s/\[(\d+),(\d+)\]/3*$1+2*$2/eg) {};
	return $s;
}


