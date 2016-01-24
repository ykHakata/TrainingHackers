package Spica::Validator::Rules;
use strict;
use warnings;
use Spica::Validator;
use Mouse;
use Carp ();

sub import {
    my $caller = caller;

    my @export = qw(params clean_params validate failed errors has_error);

    my $v = Spica::Validator->new;

    no strict 'refs';

    *{"$caller\::new"} = sub {
        my $class = shift;
        my %args = @_;
        my $self = {};
        $self->{validator} = $v;
        bless $self, $class; 
    };

    *{"$caller\::rule"} = sub {
        my ($name, %rules) = @_;
            
        $v->add_rule($name => \%rules);
    }; 

    *{"$caller\::validator"} = sub {
        my $self = shift; 
        $self->{validator};
    }; 

    for (@export) {
        my $m = $_;
        *{"$caller\::$m"} = sub {
            my $self = shift; 
            $self->validator->$m(@_);
        }; 
    }
}

no Mouse;
__PACKAGE__->meta->make_immutable();

1; 
