package TrainingHackers::Controller::API::Answer;
use strict;
use warnings;
use parent qw(TrainingHackers::Controller::Base);
use utf8;
use Encode;
use JSON;

sub deleteall {
    my $self = shift;

    my $q = $self->model('Answer');
    $q->db->query('truncate answers');
    $self->render(json => {result => []});
}

1;
