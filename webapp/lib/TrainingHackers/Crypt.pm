package TrainingHackers::Crypt;
use strict;
use warnings;
our @EXPORT = qw(ceasar);

sub ceasar {
    my $str = shift;

    $str =~ tr/a-z/defghijklmnopqrstuvwxyzabc/;
    $str =~ tr/A-Z/DEFGHIJKLMNOPQRSTUVWXYZABC/;

    $str;
}

