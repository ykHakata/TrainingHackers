package TrainingHackers::Controller::Initializers;
use strict;
use warnings;
use parent qw(TrainingHackers::Controller::Base);
use utf8;

sub index {
    my $self = shift;

    my $data = [
        {
            question => '以下の暗号を解読せよ<br>Vwdb Kxqjub',
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
            question => 'クラッキング用ページにあるフォームのIDとパスワードを突破せよ',
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
            question => 'とある筋からユーザーIDとパスワードのリストを手に入れた。このリストを利用してクラッキング用ページにあるフォームのIDとパスワードを突破せよ',
            answer => 'a',
            score => 10,
            level => 1,
            hint1 => 'ヒントは身近なところにあるぞ',
            hint2 => '',
            hint3 => '',
            hint4 => '',
            hint5 => '',
        },
        {
            question => '改ざん用ページのサイトを改ざんせよ。解答には改ざんに使用したプログラムや文字列を入力せよ。',
            answer => 'a',
            score => 10,
            level => 1,
            hint1 => 'ヒントは身近なところにあるぞ',
            hint2 => '',
            hint3 => '',
            hint4 => '',
            hint5 => '',
        },
        {
            question => '写真が撮られた場所を特定せよ。回答には住所を入力せよ。',
            answer => '',
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
