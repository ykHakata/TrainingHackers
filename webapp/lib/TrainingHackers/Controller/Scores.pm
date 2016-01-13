package TrainingHackers::Controller::Scores;
use strict;
use warnings;
use parent qw(TrainingHackers::Controller::Auth);

sub index {
    my $self = shift;

    $self->stash(user => $self->session->data->{user});

    my $answers = $self->model('Answer')->search_by_user_id({
        user_id => $self->session->data->{user}->{id}
    });
    my $score = $self->score($answers);
    $self->stash(score => $score);
    $self->stash(user => $self->session->data->{user});
    $self->render('scores/index.tx');
}

sub score {
    my $self = shift;
    my $answers = shift; 
   
    my $score = 0;
    for my $answer (@$answers) {
        $score += $answer->{score};
    }
    $score;
}

1;
