package TrainingHackers::Controller::Admin;
use strict;
use warnings;
use parent qw(TrainingHackers::Controller::Auth);

sub index {
    my $self = shift;
    $self->render('admin/index.tx');
}

1;
