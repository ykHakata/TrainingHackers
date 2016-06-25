### バイナリファイルのフォーマット

* fileコマンド
* Unix系OSでは標準で使える
* Windowsだと自作するかツールを使う

---

### fileコマンド

* ファイルの種類を調査するコマンド
* 実行ファイル、アーキテクチャ、OSなどの情報がわかる

---

### 出力結果

* PE32 executable (GUI) Intel 80386, for MS Windows
* PE32 - PE(Portable Executable)フォーマットWindowsで利用される
* GUIを利用
* Intel 80386, for MS Windows - CPUアーキテクチャ、OS
* ELF 32-bit LSB executable - Linuxの実行ファイル
* dynamically linked - 動的リンク
* stripped - 関数のシンボル情報が削除されている

---

### ハノイの塔

* Aの一番下の円版以外をCへ移動
* Aの一番下の円版をBへ移動
* Cの円板をBへ移動
* なぜこれでいけるか
* 一番下の円板が確定すればその円板のことは忘れても良い
* 今度はCからBへの移動を考える
* これはAからBへの移動と同じなので解けることが確定
* つまりAから一番下の円板以外をなんとかCへ移動することができれば解ける

---

## SQLインジェクション

```
my $dbh = DBI->connect(...);
my $query = "SELECT * FROM user WHERE uid = '$uid' AND password = '$password'";
my $sth = $dbh->prepare($query);
$sth->execute();
```
---

## SQLインジェクション

* 想定していないSQLが実行されてしまう
* その結果、個人情報が漏洩したり、データが改変されたりする
* uid = 'ksusakabe'が完成
* --はコメント扱いとなる

```
my $uid = $req->param('uid');
my password = $req->param('password');
my $dbh = DBI->connect(...);
my $query = "SELECT * FROM user WHERE uid = 'kusakabe'--' AND password = '$password'";
my $sth = $dbh->prepare($query);
$sth->execute();
```
---

## SQLインジェクション

* 対策はprepared statementを使うだけ

```
my $uid = $req->param('uid');
my password = $req->param('password');
my $dbh = DBI->connect(...);
my $query = "SELECT * FROM user WHERE uid = ? AND password = ?";
my $sth = $dbh->prepare($query);
$sth->execute($uid, $password);
```
---

## OSコマンドインジェクション

* OSのコマンドがサーバーで実行されてしまう
* その結果、サーバー内の情報やデータベースのデータが漏洩したり、データが改変されたりする

---

## OSコマンドインジェクション

* ユーザー入力値をそのままOSのコマンド実行処理に渡してしまった場合おきる

```
# $req->param()はユーザーからの入力値を取得するものとする
my $cmd = $req->param('cmd');
print system($cmd);
```
---

## OSコマンドインジェクション

* 対策としてはそういう処理をしない
* 入力値をコマンドそのものにせず引数のみにする
* 入力チェックを行う
* シェルのエスケープを行う(各言語でそういう処理を行う書き方がある)

```
print system("ls", "-ltr");
```
