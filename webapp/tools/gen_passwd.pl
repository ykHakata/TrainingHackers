#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/local/lib/perl5";
use lib "$FindBin::Bin/../lib";
use Digest::SHA qw(sha512_hex); 
use Time::HiRes qw(gettimeofday);
use Data::Faker;
use TrainingHackers::Crypt;

my @seed = ('a'..'z', 'A'..'Z');

open my $pass, ">", "password.txt";
open my $ans, ">", "answer.txt";
open my $dec, ">", "dec.txt";

my $faker = Data::Faker->new; 

for (1 .. 30) {
    
    my $str = '';
    while (length $str < 8) {
        $str .= @seed[int rand(scalar @seed)];
    }
    my $c = ceasar($str);
    my $decstr = decrypt_ceasar($c);
    my @a = split(/\s/,$faker->name);
    print $pass "$a[1]\t$c\n";
    print $ans "$a[1]\t$str\n";
    print $dec "$a[1]\t$decstr\n";
}

close $pass;
close $ans;
close $dec;
