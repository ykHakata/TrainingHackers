package TrainingHackers::Controller::Users;
use strict;
use warnings;
use parent qw(TrainingHackers::Controller::Base);
use TrainingHackers::Validator::User;

sub index {
    my $self = shift;

    if ($self->method eq 'GET') {
        my $e = $self->session->data->{error};
        $self->session->data->{error} = 0;
        $self->stash(q => $self->session->data->{user}||{}, error => $e);
        return $self->render('users/index.tx');
    } elsif ($self->method eq 'POST') {
        my $params = $self->parameters->as_hashref;
        $self->stash(q => $params);
        my $v = TrainingHackers::Validator::User->new;
        if ($v->failed($params)) {
            $self->stash(error => 1);
            return $self->render('users/index.tx');
        }
        if ($self->register($params)) {
            return $self->redirect('/');
        }
        $self->stash(error => 2);
        return $self->render('users/index.tx')
    }
}

sub register {
    my ($self, $params) = @_;

    my $user = $self->model('User');
    my $entry = $user->search_by_user_id_and_password($params);
    if ($entry) {
        $self->session->data->{error} = 1;
        $self->session->data->{user} = $entry;
        return 0;
    } else {
        my $id = $user->create($params);
        my $entry = $user->search_by_user_id_and_password($params);
        $self->session->data->{user} = $entry;
        $self->session->regenerate_id;
        return 1;
    }
}

1;
