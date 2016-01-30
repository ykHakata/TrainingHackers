package TrainingHackers::Controller::Initializers;
use strict;
use warnings;
use parent qw(TrainingHackers::Controller::Base);
use utf8;

sub index {
    my $self = shift;

    my $data = [
        {
            question => '以下の暗号を解読し、元の文字列を解読せよ。この暗号はシーザー暗号という暗号化方式を利用して暗号化されている。<br>Vwdb Kxqjub',
            answer => 'Stay Hungry',
            score => 10,
            level => 1,
            hint1 => 'Webでシーザー暗号を調べよう',
            hint2 => 'シーザー暗号は元のアルファベットをある規則に従って別のアルファベットに変換する暗号だ',
            hint3 => 'シーザー暗号は元のアルファベットを3文字後ろのアルファベットに置き換えるんだ',
            hint4 => 'aならd、bならe、cならfというように3文字後ろのアルファベットに変換する',
            hint5 => 'Vwdb Kxqjubという文字列はシーザー暗号化されたものだから、アルファベットを3文字前にずらせば元の文字列がわかる。例えばVの3文字前はS、wの3文字前はtというように変換しよう。',
        },
        {
            question => 'クラッキング用ページのIDとパスワードをクラックせよ。クラックに成功したらパスワードの方を解答に入力してくれ。正解のIDとパスワードはクラッキング用ページのどこかにかかれているらしい。よく調べてくれ。',
            answer => 'wATFyXV66LYHsCsoMDCeQLMfmGzU3A4C',
            score => 10,
            level => 1,
            hint1 => 'まずはブラウザの機能でHTMLのソースを表示してみよう',
            hint2 => '右クリックでソースの表示を選択しよう',
            hint3 => 'ソースの中をくまなく調べてみよう',
            hint4 => 'ソースの中で他のファイルを読み込んでいるJavaScriptを調べよう',
            hint5 => 'ソースからリンクされているid.jsとpassword.jsの中を見てみよう',
        },
        {
            question => 'とある筋からユーザーIDとパスワードのリストを手に入れた。IDとパスワードはタブで区切られており、パスワードは暗号化されている。おそらくこのリストの中の誰かのアカウントがクラッキング用ページのIDとパスワードに一致するはずだ。リストを元にIDとパスワードをクラックせよ。',
            answer => 'nRoyhQNv',
            score => 10,
            level => 2,
            hint1 => 'パスワードはシーザー暗号化されているのでまずは暗号化される前の文字列にもどそう',
            hint2 => 'シーザー暗号がわからない人は問1のヒントを見よう',
            hint3 => 'リストの先頭から順番にIDとパスワードを入力してみよう',
            hint4 => '正解のIDはサイトのどこかに隠されている',
            hint5 => 'サイトからリンクされているid.jsを見てみよう',
        },
        {
            question => '改ざん用ページのサイトを改ざんせよ。テキストボックスに文字列やプログラムを入力してサイトを改ざんするんだ。解答には改ざんに使用したプログラムや文字列を入力せよ。',
            answer => 'a',
            score => 10,
            level => 4,
            hint1 => 'サイトを改ざんするにはWebページのHTMLを改ざんする必要がある',
            hint2 => 'テキストボックスに入力された文字を送信するとそのまま現在のWebページに表示される',
            hint3 => 'テキストボックスのHTMLを入力すればどうなるなろう',
            hint4 => 'HTMLとは<h1>タイトル</h1>みたいなタグで囲まれた構文を持つ',
            hint5 => 'テキストボックスにHTMLを入力してみよう',
        },
        {
            question => '下の写真が撮られたモスバーガーの店舗を特定せよ。解答には店名を入力せよ。(例えば天神北店)。写真には位置情報が埋め込まれているのでまずはそれを調べよう。',
            answer => '神楽坂下店',
            score => 10,
            level => 3,
            hint1 => '写真に埋め込まれた位置情報をExifというんだ',
            hint2 => 'Exifの情報を調べるサイトがあるぞ',
            hint3 => 'モスバーガーの写真をそのサイトで調べてみよう',
            hint4 => '位置情報がわかったらその場所をGoogle Mapsで調べてみよう',
            hint5 => 'http:://exif-check.orgで位置情報を調べられるぞ',
        },
        {
            question => '以下の実行ファイルを起動してパスワードをクラックせよ。',
            answer => 'hacker',
            score => 10,
            level => 1,
            hint1 => '実行ファイルの中身を見てみよう',
            hint2 => 'バイナリエディタを使えばバイナリファイルの中身を見ることができる',
            hint3 => 'バイナリデータの中のASCII文字列を表示できるツールを使おう',
            hint4 => 'ASCII文字列の中にパスワードらしきものが確認できるかもしれない',
            hint5 => '',
        },
        {
            question => 'ソフトバンクグループ株式会社の代表取締役社長は誰でしょう？',
            answer => '1',
            score => 10,
            level => 1,
            hint1 => '高校生の頃に中退をして渡米を行っています',
            hint2 => '若い頃、慢性肝炎で生死をさまよった経験があります',
            hint3 => '坂本龍馬の大ファン',
            hint4 => '東日本大震災復興において多額の寄付を行っています',
            hint5 => '頭が薄いことをよくネタにします',
        },
        {
            question => 'プログラミング言語、Perl の開発者は誰でしょう？',
            answer => '2',
            score => 10,
            level => 1,
            hint1 => '言語学者でもあります',
            hint2 => 'プログラマの三大美徳というものを唱え始めました',
            hint3 => 'プログラミング Perl の共同著者です',
            hint4 => 'まつもとゆきひろ氏が尊敬をしている人物です',
            hint5 => 'とっても愛妻家',
        },
        {
            question => 'Facebook の創業者は誰でしょう？',
            answer => '3',
            score => 10,
            level => 1,
            hint1 => '高校時代は友達が非常に少なかったらしいです',
            hint2 => '大学時代に「Coursematch」というサービスを開発しています',
            hint3 => '画像格付けサイト「Facemash.com」は女子学生の容姿を格付けする内容で大学から保護観察処分',
            hint4 => 'いつも同じ服装である理由は仕事以外の意思決定を少なくしたいとのこと',
            hint5 => '名言「リスクを取らないことが一番のリスクだ」',
        },
        {
            question => 'この問題の答えはなんでしょう？',
            answer => 'おつかれさまでした',
            score => 10,
            level => 100,
            hint1 => '次のヒントをみるしかない！',
            hint2 => '見当もつかないだろ？',
            hint3 => '告知HPの問題が解けた君ならできるはずだけどなぁ？',
            hint4 => 'ソースコードを直接見るにはどうしたらいいんだっけ？',
            hint5 => 'この辺を右クリックしたら、ソースコードがみれるだろ？',
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
