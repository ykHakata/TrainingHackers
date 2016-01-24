package TrainingHackers::Controller::Questions;
use strict;
use warnings;
use parent qw(TrainingHackers::Controller::Auth);

sub index {
    my $self = shift;

    $self->stash(user => $self->session->data->{user});
    $self->render('questions/index.tx');
}

sub show {
    my $self = shift;
    my $capture = shift;

    my $n = $capture->{'*'};
    my $entry = $self->model('User')->search($self->session->data->{user}->{id});
    if (!$entry) {
        $self->session->data->{error} = 1;
        return $self->redirect('/errors');
    }
    my $question = $self->model('Question')->search($n);
    if (!$question) {
        $self->session->data->{error} = 2;
        return $self->redirect('/scores');
    }
    $self->stash(
        q => {question_id => $n},
        error => $self->session->data->{error},
        question_id => $n,
        question => $question->{question},
        level => $question->{level},
        score => $question->{score},
        hint1 => $question->{hint1},
        hint2 => $question->{hint2},
        hint3 => $question->{hint3},
        hint4 => $question->{hint4},
        hint5 => $question->{hint5},
    );
    $self->session->data->{error} = 0;

    if ($self->session->data->{user_answer}) {
        $self->stash(q => {user_answer => $self->session->data->{user_answer}}); 
        $self->session->data->{user_answer} = undef; 
    }
    $self->session->data->{question} = $question;
    $self->render("questions/$n.tx");
}

1;
