package TrainingHackers::Controller::PasswordCracking;
use strict;
use warnings;
use parent qw(TrainingHackers::Controller::Auth);

sub index {
    my $self = shift;

    my $params = $self->parameters;
    $self->stash(q => $params, question_id => $self->session->data->{question}->{id});

    if ($self->method eq 'GET') {
        return $self->render('cracking/index.tx');
    }

    if (!$params->{id}) {
        $self->stash(error => 1);
        return $self->render('cracking/index.tx');
    }
    if (!$params->{password}) {
        $self->stash(error => 2);
        return $self->render('cracking/index.tx');
    }
    if ($params->{id} eq $self->routes->{id} && $params->{password} eq $self->routes->{password}) {
        $self->stash(success => 1, password => $params->{password});
        $self->session->data->{user_answer} = $params->{password};
        return $self->render('cracking/index.tx');
    } else {
        $self->stash(error => 3);
        return $self->render('cracking/index.tx');
    }
}

1;
