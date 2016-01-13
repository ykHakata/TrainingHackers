package TrainingHackers::Controller::Sessions;
use strict;
use warnings;
use parent qw(TrainingHackers::Controller::Base);

sub index {
    my $self = shift;

    if ($self->method eq 'GET') {
        $self->stash(q => {});
        return $self->render('sessions/index.tx')
    } elsif ($self->method eq 'POST') {
        my $params = $self->parameters;
        $self->stash(q => $params);
        if ($self->login($params)) {
            return $self->redirect('/');
        } else {
            $self->stash(user_id_error => 1);
            $self->render('sessions/index.tx');
        }
    }
}

sub login {
    my ($self, $params) = @_;

    my $user = $self->model('User');
    my $entry = $user->search_by_user_id_and_password($params);
    if ($entry) {
        $self->session->data->{user} = $entry;
        $self->session->regenerate_id;
        return 1;
    } else {
        return 0;
    }
}

sub logout {
    my $self = shift;

    if ($self->session->exists) {
        $self->session->destroy;
    }
    return $self->redirect('/');
}

1;
