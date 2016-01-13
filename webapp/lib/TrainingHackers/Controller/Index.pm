package TrainingHackers::Controller::Index;
use parent qw(TrainingHackers::Controller::Base);
use utf8;

sub index {
    my $self = shift;

    $self->stash(
        q => $self->session->data->{user},
        title => 'ユーザー登録',
        error => $self->session->data->{error},
        user => $self->session->data->{user}
    );
    $self->render('index/index.tx');
}

1;
