use Data::Dumper;
use strict;
use warnings;

my $A = {rod => [], name => 'A'};
my $B = {rod => [], name => 'B'};
my $C = {rod => [], name => 'C'};
my $CTX = [$A, $B, $C];
my $COUNT = 0;

# $Aを$Bへ移動
sub hanoi {
	my ($n, $A, $B, $C) = @_;
	if ($n > 0) {
		hanoi($n-1, $A, $C, $B);
		print "$A->{name}から$B->{name}へ$n番の円盤を移動\n";
		$COUNT++;
		my $x = pop @{$A->{rod}};
		push @{$B->{rod}}, $x;
		print "$CTX->[0]->{name} : @{$CTX->[0]->{rod}}\n";
		print "$CTX->[1]->{name} : @{$CTX->[1]->{rod}}\n";
		print "$CTX->[2]->{name} : @{$CTX->[2]->{rod}}\n";
		hanoi($n-1, $C, $B, $A);
	}
}

# 2^n-1
my $n;
if (scalar @ARGV == 1) {
	$n = shift @ARGV;
	die("$n must be a number") if $n !~ /\d+/;
} else {
	$n = 3 
}

for (1..$n) {
	push @{$A->{rod}}, $_;
}

print "$CTX->[0]->{name} : @{$CTX->[0]->{rod}}\n";
print "$CTX->[1]->{name} : @{$CTX->[1]->{rod}}\n";
print "$CTX->[2]->{name} : @{$CTX->[2]->{rod}}\n";

hanoi($n, $A, $B, $C);
print $COUNT,"\n";


