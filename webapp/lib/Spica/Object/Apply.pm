package Spica::Object::Apply;

use strict;
use warnings;
use Carp ();
use Scalar::Util qw(blessed);

sub new{
    my $class = shift;
    my $self  = @_ ? {@_} : {};
    bless $self, $class;
}

*isa = \&UNIVERSAL::isa;

sub apply($&;@) {
    my $self = shift;
    my $code = shift;
    my $keyapp = $self->{apply_keys} ? 
    sub { $code->(shift) } : sub { shift };
    my $curry = sub {
        my @retval;
        for my $arg (@_){
            my $class = ref $arg;
            Carp::croak 'blessed reference forbidden'
            if  !$self->{apply_blessed} and blessed $arg;
            my $val =
            !$class ? 
            $code->($arg) :
            isa($arg, 'ARRAY') ? 
            [ $self->apply($code, @$arg) ] :
            isa($arg, 'HASH')  ? 
            {
                map { $keyapp->($_) => $self->apply($code, $arg->{$_}) }
                keys %$arg
            } :
            isa($arg, 'SCALAR') ? 
            \do{ $self->apply($code, $$arg) } :
            isa($arg, 'GLOB')  ? 
            *{ $self->apply($code, *$arg) } :
            isa($arg, 'CODE') && $self->{apply_code}  ?
            $code->($arg) :
            Carp::croak "I don't know how to apply to $class" ;
            bless $val, $class if blessed $arg;
            push @retval, $val;
        }
        return wantarray ? @retval : $retval[0];
    };
    @_ ? $curry->(@_) : $curry;
}

1;
