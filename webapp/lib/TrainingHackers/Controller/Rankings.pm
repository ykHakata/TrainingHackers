package TrainingHackers::Controller::Rankings;
use strict;
use warnings;
use parent qw(TrainingHackers::Controller::Auth);

sub index {
    my $self = shift;

    $self->stash(user => $self->session->data->{user});

    my $rankings = [];
    my $users = $self->model('User')->search_all;    
    for my $user (@$users) {
        my $ranking = {};
        my $answers = $self->model('Answer')->search_by_user_id({
            user_id => $user->{id}
        });
        my $score = $self->score($answers);
        $ranking->{username} = $user->{username};
        $ranking->{score} = $score;
        push @$rankings, $ranking;
    }
    my @sorted = sort(sort_func @$rankings);
    $self->stash(rankings => \@sorted);
    $self->render('rankings/index.tx');
}

sub sort_func {
    return ($b->{score} cmp $a->{score});
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
