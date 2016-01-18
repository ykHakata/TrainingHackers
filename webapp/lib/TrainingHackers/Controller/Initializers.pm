package TrainingHackers::Controller::Initializers;
use strict;
use warnings;
use parent qw(TrainingHackers::Controller::Base);
use utf8;

sub index {
    my $self = shift;
 
    my $data = [
        {
            question => '',
            answer => 'Stay Hungry',
            score => 10,
            level => 1,
            hint1 => 'シーザー暗号を知っているかい?',
            hint2 => 'Webでシーザー暗号を調べよう',
            hint3 => 'シーザー暗号はアルファベットを特定の文字数ずらすんだ',
            hint4 => '問題の暗号文をアルファベット順に後ろに3文字ずらしてみよう',
            hint5 => 'aならd、bならe、cならfに変換してみよう',
        }, 
        {
            question => '',
            answer => 'hacker',
            score => 10,
            level => 1,
            hint1 => 'ヒントは身近なところにあるぞ',
            hint2 => '',
            hint3 => '',
            hint4 => '',
            hint5 => '',
        },
        {
            question => '',
            answer => '1',
            score => 10,
            level => 1,
            hint1 => 'ヒントは身近なところにあるぞ',
            hint2 => '',
            hint3 => '',
            hint4 => '',
            hint5 => '',
        },
    ];
    my $q = $self->model('Question');
    $q->db->query('truncate questions');

    for my $d (@$data) {
        $q->create($d);
    }
    $self->render(text => 'initialize OK');
}

1;
