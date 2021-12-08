use strict;
use warnings;
use Data::Dumper;

#   0:      1:      2:      3:      4:
#  aaaa    ....    aaaa    aaaa    ....
# b    c  .    c  .    c  .    c  b    c
# b    c  .    c  .    c  .    c  b    c
#  ....    ....    dddd    dddd    dddd
# e    f  .    f  e    .  .    f  .    f
# e    f  .    f  e    .  .    f  .    f
#  gggg    ....    gggg    gggg    ....
# 
#   5:      6:      7:      8:      9:
#  aaaa    aaaa    aaaa    aaaa    aaaa
# b    .  b    .  .    c  b    c  b    c
# b    .  b    .  .    c  b    c  b    c
#  dddd    dddd    ....    dddd    dddd
# .    f  e    f  .    f  e    f  .    f
# .    f  e    f  .    f  e    f  .    f
#  gggg    gggg    ....    gggg    gggg


my $count = 0;
while (my $in = <>) {
	chomp $in;
	my @spaced_in = split / /, $in;
	#print Dumper(\@spaced_in);

	my %vals = (
		0 => {},
		1 => {},
		2 => {},
		3 => {},
		4 => {},
		5 => {},
		6 => {},
		7 => {},
		8 => {},
		9 => {},
	);
	my %letters = (
		a => '',
		b => '',
		c => '',
		d => '',
		e => '',
		f => '',
		g => '',
	);
	my %rev_letters = (
		a => '',
		b => '',
		c => '',
		d => '',
		e => '',
		f => '',
		g => '',
	);

	my @len_5_digits;
	my @len_6_digits;
	my $pos = 0;
	for (0.. (scalar(@spaced_in)-1)) {
		$pos = $_;
		if ($spaced_in[$pos] eq '|') {
			$pos++;
			last;
		}
		#length == 2    1
		if (length($spaced_in[$pos]) == 2) {
			for my $char (split('',$spaced_in[$pos])) {
				$vals{1}->{$char} = 1;
			}
		#length == 3    7
		} elsif (length($spaced_in[$pos]) == 3) {
			for my $char (split('',$spaced_in[$pos])) {
				$vals{7}->{$char} = 1;
			}
		#length == 4    4
		} elsif (length($spaced_in[$pos]) == 4) {
			for my $char (split('',$spaced_in[$pos])) {
				$vals{4}->{$char} = 1;
			}
		#length == 7    8
		} elsif (length($spaced_in[$pos]) == 7) {
			for my $char (split('',$spaced_in[$pos])) {
				$vals{8}->{$char} = 1;
			}
		#length == 5,   2, 3, 5
		} elsif (length($spaced_in[$pos]) == 5) {
			my %new_unknown;
			for my $char (split('',$spaced_in[$pos])) {
				$new_unknown{$char} = 1;
			}
			push @len_5_digits, \%new_unknown;
		#length == 6,   0,6,9
		} elsif (length($spaced_in[$pos]) == 6) {
			my %new_unknown;
			for my $char (split('',$spaced_in[$pos])) {
				$new_unknown{$char} = 1;
			}
			push @len_6_digits, \%new_unknown;
		}
	}

	# 1 and 7 gives you a, leaves c,f
	for my $k (keys %{$vals{7}}) {
		unless (exists $vals{1}->{$k}) {
			$letters{$k} = 'a';
			$rev_letters{'a'} = $k;
			last;
		}
	}

	my %diff_1_4;
	# 1 and 4              leaves b,d
	for my $k (keys %{$vals{4}}) {
		unless (exists $vals{1}->{$k}) {
			$diff_1_4{$k} = 1;
		}
	}

	my %diff_4_8;
	# 4 and 8              leaves e,g
	for my $k (keys %{$vals{8}}) {
		if (!exists $vals{4}->{$k} and $letters{$k} eq '') {
			unless (exists $diff_1_4{$k}) {
				$diff_4_8{$k} = 1;
			}
		}
	}

	# common in 2,3,5
	# gives d,g  d should be in 1-4, g should be in 4-8
	for my $k (%{$len_5_digits[0]}) {
		if (exists $len_5_digits[1]->{$k} and
			exists $len_5_digits[2]->{$k} and
			$letters{$k} eq '') {
			if (exists $diff_1_4{$k}) {
				$letters{$k} = 'd';
				$rev_letters{'d'} = $k;
			} else {
				$letters{$k} = 'g';
				$rev_letters{'g'} = $k;
			}
		}
	}
	# so far: a,d,g

	# we can find 0 in length(6) only one without d
	my $to_remove_from_6;
	for my $v (0..(scalar(@len_6_digits)-1)) {
		unless (exists $len_6_digits[$v]->{$rev_letters{'d'}}) {
			$vals{0} = $len_6_digits[$v];
			$to_remove_from_6 = $v;
			last;
		}
	}

	splice @len_6_digits, $to_remove_from_6, 1;

	# 6 and 9  gives c and e, e in diff 4-8
	my @diff_6_9;
	for my $i (keys %{$len_6_digits[0]}) {
		unless (exists $len_6_digits[1]->{$i}) {
			if (exists $diff_4_8{$i}) {
				$letters{$i} = 'e';
				$rev_letters{'e'} = $i;
				$vals{6} = $len_6_digits[0];
			} else {
				$letters{$i} = 'c';
				$rev_letters{'c'} = $i;
				$vals{9} = $len_6_digits[0];
			}
		}
	}
	for my $i (keys %{$len_6_digits[1]}) {
		unless (exists $len_6_digits[0]->{$i}) {
			if (exists $diff_4_8{$i}) {
				$letters{$i} = 'e';
				$rev_letters{'e'} = $i;
				$vals{6} = $len_6_digits[1];
			} else {
				$letters{$i} = 'c';
				$rev_letters{'c'} = $i;
				$vals{9} = $len_6_digits[0];
				$vals{9} = $len_6_digits[1];
			}
		}
	}
	# we have 6 and 9 at this point
	# so far: a,c,d,e,g

	# we find 2, only one with e in len(5)
	my $to_remove_from_5;
	for my $v (0..(scalar(@len_5_digits)-1)) {
		if (exists $len_5_digits[$v]->{$rev_letters{'e'}}) {
			$vals{2} = $len_5_digits[$v];
			$to_remove_from_5 = $v;
			last;
		}
	}
	splice @len_5_digits, $to_remove_from_5, 1;

	# we find 3, has c between 3 and 5
	# 5 is the only one left
	for my $v (@len_5_digits) {
		if (exists $v->{$rev_letters{'c'}}) {
			$vals{3} = $v;
		} else {
			$vals{5} = $v;
		}
	}

	my %num_map;
	for (keys %vals) {
		$num_map{join('',sort(keys %{$vals{$_}}))} = $_;
	}

	my $digit = '';
	my @right_digits;
	for ($pos.. (scalar(@spaced_in)-1)) {
		my $chars = join('', sort(split('', $spaced_in[$_])));
		$digit .= $num_map{$chars};
	}
	$count += $digit;

	#print Dumper($digit);
}

print "final count: $count\n";

