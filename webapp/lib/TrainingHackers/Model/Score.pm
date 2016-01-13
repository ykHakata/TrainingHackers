package TrainingHackers::Model::Score;
use strict;
use warnings;
use TrainingHackers::Model::Answer;
use parent qw(TrainingHackers::Model::Base); 
use DBIx::Sunny;

sub create {
    my ($self, $params) = @_;

    my $query = 'INSERT INTO scores (user_id, score) VALUES (?,?)';
    my $user_id = $params->{user_id};
    my $score = $params->{score};
    $self->db->query($query, $user_id, $score);
}

sub search {
    my ($self, $id) = @_;

    $self->db->select_all('SELECT * FROM scores WHERE id = ?', $id);
}

sub score {
    my ($self, $params) = @_;
    
    my $answer = TrainingHackers::Model::Answer->new(db => $self->db);
    $answer->search({ user_id => $params->{user_id} });

    my $total = 0;
    for my $score (@$scores) {
        $total += $score->{score}; 
    }
    $total;
}

1;
