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

    # hint パラメーターから得点を計算後レコード更新するので
    # answer テーブルの hint カラムは使用していない
    if ($score) {
        $score = $self->_calcu_score( $score, $answer, );
    }

    my $update_params = +{
        user_id     => $self->session->data->{user}->{id},
        user_answer => $params->{user_answer},
        question_id => $self->session->data->{question}->{id},
        score       => $score,
    };

    if ($answer) {
        $self->model('Answer')->update($update_params);
    }
    else {
        $self->model('Answer')->create($update_params);
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

sub hint {
    my $self      = shift;
    my $params    = $self->parameters;
    my $hint_type = $params->{value};
    my $session   = $self->session->data;

    # 存在確認
    my $answer = $self->model('Answer')->search(
        +{  user_id     => $self->session->data->{user}->{id},
            question_id => $self->session->data->{question}->{id}
        },
    );

    my $update_params = +{
        user_id     => $self->session->data->{user}->{id},
        question_id => $self->session->data->{question}->{id},
        $hint_type  => 1,
    };

    if ($answer) {
        $self->model('Answer')->update($update_params,$hint_type);
    }
    else {
        $self->model('Answer')->create($update_params,$hint_type);
    }
    return $self->finalize;
}

=head2 _calcu_score

    ヒントの回覧状況から得点を計算

=cut

sub _calcu_score {
    my $self   = shift;
    my $score  = shift;
    my $params = shift;

    for ( 1 .. 5 ) {
        last if $score < 2;
        $score -= 2 if $params->{"hint$_"};
    }

    return $score;
}

1;
