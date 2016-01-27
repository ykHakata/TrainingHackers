package TrainingHackers::Controller::UserAnswers;
use strict;
use warnings;
use parent qw(TrainingHackers::Controller::Auth);

sub index {
    my $self = shift;
    my $capture = shift;

    my $answers = $self->model('Answer')->search_by_user_id({
        user_id => $self->session->data->{user}->{id},
    });

    $self->stash(answers => $answers);
    return $self->render("user_answers/index.tx");
}

1;
