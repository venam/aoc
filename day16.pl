use strict;
use warnings;
#use bigint qw/hex/;
use Data::Dumper;

my $version_sum = 0;
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
	$version_sum = 0;
	my $result = parse_packet($binvalue, 0);
	print "version sum is: $version_sum\n";
	print Dumper($result);
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
		$version_sum += $version;
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
		if ($length_type_id eq '0') {
			# next 15 bits are a number that is the total length
			my $len = oct('0b'.substr($binvalue, $offset, 15));
			$offset += 15;
			my $sub_len_c = 0;
			my @sub;
			while ($sub_len_c < $len) {
				my $result = parse_packet($binvalue, $offset);
				push @sub, $result;
				$offset += $result->{length};
				$sub_len_c += $result->{length};
			}
			$version_sum += $version;
			return {
				type_id => $type_id,
				version => $version,
				value => {
					arr => \@sub,
				},
				length => ($offset - $original_offset),
			};
		} else {
			# next 11 bits are the number of sub-packets
			my $nb_subs = oct('0b'.substr($binvalue, $offset, 11));
			$offset += 11;
			my @sub;
			for (1..$nb_subs) {
				my $result = parse_packet($binvalue, $offset);
				push @sub, $result;
				$offset += $result->{length};
			}
			$version_sum += $version;
			return {
				type_id => $type_id,
				version => $version,
				value => {
					arr => \@sub,
				},
				length => ($offset - $original_offset),
			};
		}
	}

}

