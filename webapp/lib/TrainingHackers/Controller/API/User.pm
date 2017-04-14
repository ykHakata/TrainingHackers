package TrainingHackers::Controller::API::User;
use strict;
use warnings;
use parent qw(TrainingHackers::Controller::Base);
use utf8;
use Encode;
use JSON;

sub deleteall {
    my $self = shift;

    my $q = $self->model('User');
    $q->db->query('truncate users');
    $q->db->query('truncate sessions');
    $self->render(json => {result => []});
}

1;
