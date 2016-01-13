package TrainingHackers::Model::Question;
use strict;
use warnings;
use parent qw(TrainingHackers::Model::Base); 
use DBIx::Sunny;

sub create {
    my ($self, $params) = @_;

    my $query = 'INSERT INTO questions (question, answer, score, level, hint1, hint2, hint3, hint4, hint5) VALUES (?,?,?,?,?,?,?,?,?)';
    $self->db->query(
        $query,
        $params->{question},
        $params->{answer},
        $params->{score},
        $params->{level},
        $params->{hint1},
        $params->{hint2},
        $params->{hint3},
        $params->{hint4},
        $params->{hint5},
    );
}

sub search {
    my ($self, $question_id) = @_;

    $self->db->select_row('SELECT * FROM questions WHERE id = ?', $question_id);
}

sub count {
    my $self = shift;

    my $result = $self->db->select_row('SELECT count(*) FROM questions');
    $result->{'count(*)'};
}

1;
