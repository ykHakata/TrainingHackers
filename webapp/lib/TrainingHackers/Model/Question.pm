package TrainingHackers::Model::Question;
use strict;
use warnings;
use parent qw(TrainingHackers::Model::Base); 
use DBIx::Sunny;

sub create {
    my ($self, $params) = @_;

    my $query = 'INSERT INTO questions (question, answer, score, level, hint1, hint2, hint3, hint4, hint5, type, addfile, option1, option2, option3, option4) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
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
        $params->{type} || '',
        $params->{addfile} || '',
        $params->{option1} || '',
        $params->{option2} || '',
        $params->{option3} || '',
        $params->{option4} || '',
    );

    $self->db->last_insert_id;
}

sub search_all {
    my $self = shift;

    $self->db->select_all('SELECT * FROM questions');
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

sub update {
    my ($self, $params) = @_;

    my $query = <<SQL;
UPDATE questions
SET question=?, answer=?, score=?, level=?, hint1=?, hint2=?, hint3=?, hint4=?, hint5=?, 
type=?, addfile=?, option1=?, option2=?, option3=?, option4=? 
WHERE id = ?
SQL
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
        $params->{type} || '',
        $params->{addfile} || '',
        $params->{option1} || '',
        $params->{option2} || '',
        $params->{option3} || '',
        $params->{option4} || '',
        $params->{id},
    );
    $params->{id};
}


1;
