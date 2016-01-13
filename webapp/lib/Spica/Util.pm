package Spica::Util;
use strict;
use warnings;
use POSIX qw(strftime);
use File::Spec ();
use Carp ();

sub load_file {
    my $file = shift;

    $file = File::Spec->rel2abs($file);
    my $config = do $file or Carp::croak("load error $file");
}

sub now {
    strftime("%Y-%m-%d %H:%M:%S", localtime(time));
    #my $t = Time::Piece::localtime;
    #my $now = $t->strftime('%Y-%m-%d %H:%M:%S');
}

sub date_format_mysql {
    my $time = shift;
    strftime("%Y-%m-%d %H:%M:%S", localtime($time));
}

sub add_method {
    my ($target, $name, $sub) = @_;
    no strict 'refs';
    *{$target."::".$name} = $sub;
}

sub load_sql {
    my $file = shift;

    my $text = slurp($file);
    my @component = split(';', $text);
    chomp @component;

    my @sqls;
    for my $c (@component) {
        next if $c eq '';
        $c =~ s/^\n//;
        $c =~ s/\n$//;
        push @sqls, $c;
    }

    \@sqls;
}

sub slurp {
    my $file = shift;
    $file = File::Spec->rel2abs($file);
    open my $fh, $file or Carp::croak("slurp error $file");
    my $text = do { local $/; <$fh>; };
    close $fh;

    if (wantarray) {

    } else {
        $text;
    }
}


1;
