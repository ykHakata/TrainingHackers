package TrainingHackers::Controller::Answers;
use strict;
use warnings;
use parent qw(TrainingHackers::Controller::Auth);

sub index {
    my $self = shift;
    my $capture = shift;

    my $question_id = $capture->{'*'};
    $self->session->data->{question}->{id} = $question_id;

    my $params = $self->parameters;
    $self->session->data->{answer}->{user_answer} = $params->{user_answer};

    my $question = $self->model('Question');
    my $entry = $question->search($self->session->data->{question}->{id});
    if (!$entry) {
        return $self->redirect('/sessions');
    }

    $self->session->data->{question} = $entry;
    my $score = 0;
    if ($params->{user_answer} == $entry->{answer}) {
        $score = +$entry->{score};
    }

    my $answer = $self->model('Answer')->search({
        user_id => $self->session->data->{user}->{id},
        question_id => $self->session->data->{question}->{id}
    });
    if ($answer) {
        if ($score > 0) {
            for (1..5) {
                $score -= 1 if $answer->{"hint$_"};
            }
        }
        $self->model('Answer')->update({
            user_id => $self->session->data->{user}->{id},
            user_answer => $params->{user_answer},
            question_id => $self->session->data->{question}->{id},
            score => $score
        });
    } else {
        $self->model('Answer')->create({
            user_id => $self->session->data->{user}->{id},
            user_answer => $params->{user_answer},
            question_id => $self->session->data->{question}->{id},
            score => $score
        });
    }
    my $n = $self->session->data->{question}->{id};
    $n++;
    my $count = $self->model('Question')->count;
    return $n > $count ? $self->redirect('/scores') : $self->redirect("/questions/$n");
}

1;
