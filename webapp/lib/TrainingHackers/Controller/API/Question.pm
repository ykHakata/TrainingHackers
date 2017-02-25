package TrainingHackers::Controller::API::Question;
use strict;
use warnings;
use parent qw(TrainingHackers::Controller::Base);
use utf8;
use Encode;
use JSON;

sub list {
    my $self = shift;

    my $questions = $self->model('Question')->search_all;
    $self->render(json => {result => $questions});
}

sub create {
    my $self = shift;

    my $json = JSON::decode_json($self->req->raw_body);
    $json->{question} =~ s/\n/<br>/g;
    my $q = $self->model('Question');
    my $id;
    if ($json->{id}) {
        $id = $q->update($json);
    } else {
        $id = $q->create($json);
    }
    my $views_path = $self->root_dir.'/views';
    my $question_path = "$views_path/questions/$id.tx";
    my $answer_path = "$views_path/answers/$id.tx";
    open my $fh, '+>', $question_path
        or $self->render(json => {result => []});

    if ($json->{type} eq '1') {
        if ($json->{addfile}) {
            print $fh Encode::encode_utf8($self->template_file($json));
        } else {
            print $fh Encode::encode_utf8($self->template_form);
        }
    } elsif ($json->{type} eq '2') {
        print $fh Encode::encode_utf8($self->template_radio($json));
    } else {
        print $fh Encode::encode_utf8($self->template_form);
    }
    close $fh;

    open $fh, '+>', $answer_path
        or $self->render(json => {result => []});
    print $fh $self->template_answer;
    close $fh;

    $self->render(json => {result => [$json]});
}

sub item {
    my $self = shift;

    my $params = $self->parameters;
    my $question = $self->model('Question')->search($params->{id});
    $question->{question} =~ s/<br>/\n/g;
    $self->render(json => {result => [$question]});
}

sub template_form {

    my $template = <<EOF;
: cascade layout::base

: around body -> {
  : include inc::questions::issue
  : include inc::questions::form
  : include inc::questions::level
  : include inc::questions::hint
: }
EOF
    return $template;
}

sub template_file {
    my ($self, $json) = @_;
    my $template = <<EOF;
: cascade layout::base

: around body -> {
  : include inc::questions::issue

  <div class="container">
    <div class="form-horizontal well">
      <fieldset>
        <a href="/static/images/$json->{addfile}" class="btn btn-primary btn-lg btn-block">ファイルをダウンロード<br></a>
      </fieldset>
    </div>
  </div>

  : include inc::questions::form
  : include inc::questions::level
  : include inc::questions::hint
: }
EOF
    return $template;
}

sub template_radio {
    my ($self, $json) = @_;

    my $template = <<EOF;
: cascade layout::base

: around body -> {
  : include inc::questions::issue
  <div class="container">
    <form action="/answers/<: \$question_id :>" method="POST" class="form-horizontal well">
      <fieldset>
        <legend><span class="glyphicon glyphicon-pencil"></span>&emsp;解答を入力</legend>
        :if \$error == 1 {
        <p class="text-warning">解答が入力されていません。</p>
        : }
        <div class="form-group">
          <label class="col-lg-2 control-label">選択しよう！</label>
          <div class="col-lg-10">
            <div class="row">
              <div class="radio col-xs-12 col-sm-6 col-md-6 col-lg-6">
                <label>
                  <input type="radio" name="user_answer" id="optionsRadios1" value="1" checked=""> 1: $json->{option1}
                </label>
              </div>
              <div class="radio col-xs-12 col-sm-6 col-md-6 col-lg-6">
                <label>
                  <input type="radio" name="user_answer" id="optionsRadios2" value="2"> 2: $json->{option2}
                </label>
              </div>
              <div class="radio col-xs-12 col-sm-6 col-md-6 col-lg-6">
                <label>
                  <input type="radio" name="user_answer" id="optionsRadios3" value="3"> 3: $json->{option3}
                </label>
              </div>
              <div class="radio col-xs-12 col-sm-6 col-md-6 col-lg-6">
                <label>
                  <input type="radio" name="user_answer" id="optionsRadios4" value="4"> 4: $json->{option4}
                </label>
              </div>
            </div>
          </div>
        </div>
        <div class="form-group">
          <div class="col-lg-10 col-lg-offset-2">
            <button type="submit" class="btn btn-primary" name="send" value="ボタン">送信</button>
          </div>
        </div>
      </fieldset>
    </form>
  </div>
  : include inc::questions::level
  : include inc::questions::hint
: }
EOF
    return $template;
}

sub template_answer {

    my $template = <<EOF;
: cascade layout::base

: around body -> {
  : include inc::answers::answer
: }
EOF
    return $template;
}

sub deleteall {
    my $self = shift;

    my $q = $self->model('Question');
    $q->db->query('truncate questions');
    $self->render(json => {result => []});
}

1;
