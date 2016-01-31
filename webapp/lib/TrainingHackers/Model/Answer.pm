package TrainingHackers::Model::Answer;
use strict;
use warnings;
use parent qw(TrainingHackers::Model::Base);
use DBIx::Sunny;

sub create {
    my ($self, $params,$hint_type) = @_;

    my $set_hint_type;
    my $set_hint_value;
    if ($hint_type) {
        $set_hint_type = qq{, $hint_type};
        $set_hint_value = q{,'1'};
    }
    else {
        $set_hint_type = '';
        $set_hint_value = '';
    }

    my $query = "INSERT INTO answers (question_id, user_id, user_answer, score $set_hint_type) VALUES (?,?,?,?$set_hint_value)";
    my $question_id = $params->{question_id};
    my $user_answer = $params->{user_answer};
    my $user_id = $params->{user_id};
    my $score = $params->{score};
    $self->db->query($query, $question_id, $user_id, $user_answer, $score);
}

sub update {
    my ($self, $params,$hint_type) = @_;

    my $set_hint_type;
    if ($hint_type) {
        $set_hint_type = qq{, $hint_type = '1'};
    }
    else {
        $set_hint_type = '';
    }

      my $query = <<SQL;
UPDATE answers
SET question_id = ?, user_id = ?, user_answer = ?, score = ? $set_hint_type
WHERE user_id = ? and question_id = ?
SQL
    my $question_id = $params->{question_id};
    my $user_answer = $params->{user_answer};
    my $user_id = $params->{user_id};
    my $score = $params->{score} || 0;
    $self->db->query($query, $question_id, $user_id, $user_answer, $score, $user_id, $question_id);
}

sub search_by_user_id {
    my ($self, $params) = @_;

    my $entry = $self->db->select_all('SELECT * FROM answers WHERE user_id = ?', $params->{user_id});
}

sub search {
    my ($self, $params) = @_;

    my $entry = $self->db->select_row('SELECT * FROM answers WHERE user_id = ? and question_id = ?', $params->{user_id}, $params->{question_id});
}

1;
