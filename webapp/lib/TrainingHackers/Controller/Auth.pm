package TrainingHackers::Controller::Auth;
use strict;
use warnings;
use parent qw(TrainingHackers::Controller::Base);

sub BUILD {
    my $self = shift;

    $self->on(before_action => sub {
        my $self = shift;
        return $self->authenticate;
    });
}

1;
