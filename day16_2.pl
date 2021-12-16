use strict;
use warnings;
use bigint qw/hex/;
use Data::Dumper;

while (my $in = <>) {
	chomp $in;

	my $binvalue = '';
	# read in chunks of 2 because otherwise perl doesn't handle this well
	my $i = 0;
	while ($i < length($in)) {
		my $curr = substr($in, $i, 2);
		my $num = hex($curr);
		$binvalue .= sprintf('%0*b', 8, $num);
		$i += 2;
	}

	#print "$binvalue\n";
	my $result = parse_packet($binvalue, 0);
	print $result->{value}->{literal}."\n";
}

sub parse_packet {
	my ($binvalue, $offset) = @_;
	my $original_offset = $offset;
	my $version = oct('0b'.substr($binvalue, $offset, 3));
	$offset += 3;
	my $type_id = oct('0b'.substr($binvalue, $offset, 3));
	$offset += 3;

	# literal value parsing
	if ($type_id == 4) {
		my $acc = '';
		while (1) {
			my $next_bits = substr($binvalue, $offset, 5);
			$offset += 5;
			# accumulate without leading bit
			$acc .= substr($next_bits, 1, length($next_bits)-1);
			last unless (substr($next_bits, 0, 1) eq '1');
		}
		my $literal_val = oct("0b$acc");
		return {
			type_id => $type_id,
			version => $version,
			value => {
				literal => $literal_val,
			},
			length => ($offset - $original_offset),
		};
	} else {
		my $length_type_id = substr($binvalue, $offset, 1);
		$offset += 1;
		my @sub;
		if ($length_type_id eq '0') {
			# next 15 bits are a number that is the total length
			my $len = oct('0b'.substr($binvalue, $offset, 15));
			$offset += 15;
			my $sub_len_c = 0;
			while ($sub_len_c < $len) {
				my $result = parse_packet($binvalue, $offset);
				push @sub, $result;
				$offset += $result->{length};
				$sub_len_c += $result->{length};
			}
		} else {
			# next 11 bits are the number of sub-packets
			my $nb_subs = oct('0b'.substr($binvalue, $offset, 11));
			$offset += 11;
			for (1..$nb_subs) {
				my $result = parse_packet($binvalue, $offset);
				push @sub, $result;
				$offset += $result->{length};
			}
		}
		my $new_literal;
		# sum packet
		if ($type_id == 0) {
			$new_literal = 0;
			for my $v (@sub) {
				$new_literal += $v->{value}->{literal};
			}
		} elsif ($type_id == 1) {
			$new_literal = 1;
			for my $v (@sub) {
				$new_literal *= $v->{value}->{literal};
			}
		} elsif ($type_id == 2) {
			$new_literal = 999_999_999_999;
			for my $v (@sub) {
				$new_literal = $v->{value}->{literal} if ($v->{value}->{literal} < $new_literal);
			}
		} elsif ($type_id == 3) {
			$new_literal = -999_999_999_999;
			for my $v (@sub) {
				$new_literal = $v->{value}->{literal} if ($v->{value}->{literal} > $new_literal);
			}
		} elsif ($type_id == 5) {
			$new_literal = ($sub[0]->{value}->{literal} > $sub[1]->{value}->{literal})?1:0;
		} elsif ($type_id == 6) {
			$new_literal = ($sub[0]->{value}->{literal} < $sub[1]->{value}->{literal})?1:0;
		} elsif ($type_id == 7) {
			$new_literal = ($sub[0]->{value}->{literal} == $sub[1]->{value}->{literal})?1:0;
		}

		return {
			type_id => $type_id,
			version => $version,
			value => {
				literal => $new_literal,
			},
			length => ($offset - $original_offset),
		};
	}
}

