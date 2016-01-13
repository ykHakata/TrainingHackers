package Spica::EventEmitter;
use strict;
use warnings;

sub emit {
    my ($self, $name, @args) = @_;

    if (my $listeners = $self->{events}->{$name}) {
        for my $listener (@$listeners) {
            $listener->(@args);
        }
        return 1;
    }
    return 0;
}

sub listeners {
    my ($self, $name) = @_;

    return $self->{events}->{$name} || [];
}

sub on {
    my ($self, $event, $listener) = @_;

    push @{$self->{events}->{$event}}, $listener;
}

1;
