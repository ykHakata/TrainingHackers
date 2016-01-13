package TrainingHackers::Controller::Errors;
use parent qw(TrainingHackers::Controller::Base);

sub index {
    my $self = shift;

    $self->stash(error => $self->session->data->{error});
    $self->render('errors/index.tx');
}

1;
