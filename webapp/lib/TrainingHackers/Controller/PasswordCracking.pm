package TrainingHackers::Controller::PasswordCracking;
use strict;
use warnings;
use parent qw(TrainingHackers::Controller::Auth);

sub index {
    my $self = shift;
    my $capture = shift;

    my $params = $self->parameters;
    $self->stash(q => $params);

    if ($self->method eq 'GET') {
        return $self->render('cracking/index.tx');
    }

    my $id = 'hacker';
    my $password = 'hacker';
#    my $password = 'nAHNpZNf6fMdzCghVr64RenFffo3orDi';

    if (!$params->{id}) {
        $self->stash(error => 1);
        return $self->render('cracking/index.tx');
    }
    if (!$params->{password}) {
        $self->stash(error => 2);
        return $self->render('cracking/index.tx');
    }
    if ($params->{id} eq $id && $params->{password} eq $password) {
        $self->stash(success => 1, password => $password);
        $self->session->data->{cracking_password} = $password;
        return $self->render('cracking/index.tx');
    } else {
        $self->stash(error => 3);
        return $self->render('cracking/index.tx');
    }
}

1;
