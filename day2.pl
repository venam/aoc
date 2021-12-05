use strict;
use warnings;

my $horizontal = 0;
my $depth = 0;


while (<>) {
    if (/forward (\d+)/) {
        $horizontal += $1;
    } elsif (/down (\d+)/) {
        $depth += $1;
    } elsif (/up (\d+)/) {
        $depth -= $1;
    }
}

print("horizontal $horizontal, depth $depth\n");
print("out: ".($horizontal*$depth)."\n");

