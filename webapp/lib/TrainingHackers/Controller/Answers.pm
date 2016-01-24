package TrainingHackers::Controller::Answers;
use strict;
use warnings;
use parent qw(TrainingHackers::Controller::Auth);
use TrainingHackers::Validator::Answer;

sub index {
    my $self = shift;
    my $capture = shift;

    my $question_id = $capture->{'*'};
    $self->session->data->{question}->{id} = $question_id;

    if ($self->method eq 'GET') {
        return $self->redirect('/questions/'.$question_id);
    }

    my $params = $self->parameters;

    my $v = TrainingHackers::Validator::Answer->new;
    if ($v->failed($params)) {
        $self->session->data->{error} = 1;
        return $self->redirect('/questions/'.$question_id);
    }

    $self->session->data->{answer}->{user_answer} = $params->{user_answer};

    my $question = $self->model('Question');
    my $entry = $question->search($self->session->data->{question}->{id});
    if (!$entry) {
        return $self->redirect('/sessions');
    }

    $self->session->data->{question} = $entry;
    my $score = 0;
    if ($params->{user_answer} eq $entry->{answer}) {
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
    my $count = $self->model('Question')->count;
    $self->stash(
        user_answer   => $params->{user_answer},
        q_number      => $n,
        next_q_number => $n + 1,
    );
    return $self->render("answers/$n.tx");
}

1;
