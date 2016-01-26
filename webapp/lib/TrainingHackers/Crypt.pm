package TrainingHackers::Crypt;
use strict;
use warnings;
use parent qw(Exporter);
our @EXPORT = qw(ceasar decrypt_ceasar);

sub ceasar {
    my $str = shift;

    $str =~ tr/a-z/defghijklmnopqrstuvwxyzabc/;
    $str =~ tr/A-Z/DEFGHIJKLMNOPQRSTUVWXYZABC/;

    $str;
}

sub decrypt_ceasar {
    my $str = shift;

    $str =~ tr/a-z/xyzabcdefghijklmnopqrstuvw/;
    $str =~ tr/A-Z/XYZABCDEFGHIJKLMNOPQRSTUVW/;

    $str;
}

1;
