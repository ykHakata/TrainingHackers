
class Question {

  constructor() {
    this.addNewQuestionBtnId = '#add-new-question-btn';
    this.addNewQuestionModalId = '#add-new-question-modal';
    this.addQuestionBtnId = '#add-question-btn';
    this.deleteAllQuestionBtnId = '#delete-all-question-btn';
    this.deleteAllAnswerBtnId = '#delete-all-answer-btn';
    this.editQuestionBtnId = '#edit-question-btn';
    this.idValId = 'input[name=id]';
    this.questionValId = 'textarea[name=question]';
    this.option1ValId = 'input[name=option1]';
    this.option2ValId = 'input[name=option2]';
    this.option3ValId = 'input[name=option3]';
    this.option4ValId = 'input[name=option4]';
    this.answerValId = 'input[name=answer]';
    this.addfileValId = 'input[name=addfile]';
    this.typeValId = 'input[name=type]:checked';
    this.scoreValId = 'input[name=score]';
    this.hint1ValId = 'input[name=hint1]';
    this.hint2ValId = 'input[name=hint2]';
    this.hint3ValId = 'input[name=hint3]';
    this.hint4ValId = 'input[name=hint4]';
    this.hint5ValId = 'input[name=hint5]';
    this.levelValId = 'input[name=level]';
    this.questionListAPI = '/api/question/list';
    this.questionCreateAPI = '/api/question/create';
    this.questionDeleteAllAPI = '/api/question/deleteall';
    this.questionItemAPI = '/api/question/item';
    this.answerDeleteAllAPI = '/api/answer/deleteall';
  }
  addListener() {
    $(this.addNewQuestionBtnId).on('click', (e) => {
      $(this.addNewQuestionModalId).modal();
    });
    $(this.addQuestionBtnId).on('click', (e) => {
      this.addQuestion(e);
    });
    $(this.deleteAllQuestionBtnId).on('click', (e) => {
      this.deleteAllQuestion(e);
    });
    $(this.deleteAllAnswerBtnId).on('click', (e) => {
      this.onClickDeleteAllAnswer(e);
    });
  }

  deleteAllQuestion(e) {
    e.preventDefault();
    if (window.confirm('削除しますか?')) {
      this.deleteAll();
    }
  }

  deleteAll() {

    $.ajax({
      url: this.questionDeleteAllAPI,
      type: 'POST',
    }).then((data) => {
      alert('削除しました');
      this.load();
    },
    (data) => {
      alert('エラーが発生しました');
    });
  }

  onClickDeleteAllAnswer(e) {
    e.preventDefault();
    if (window.confirm('削除しますか?')) {
      this.deleteAllAnswer();
    }
  }

  deleteAllAnswer() {

    $.ajax({
      url: this.answerDeleteAllAPI,
      type: 'POST',
    }).then((data) => {
      alert('削除しました');
      this.load();
    },
    (data) => {
      alert('エラーが発生しました');
    });
  }

  addQuestion(e) {
    e.preventDefault();
    let json = {
      id: $(this.idValId).val(),
      question: $(this.questionValId).val(),
      level: $(this.levelValId).val(),
      answer: $(this.answerValId).val(),
      option1: $(this.option1ValId).val(),
      option2: $(this.option2ValId).val(),
      option3: $(this.option3ValId).val(),
      option4: $(this.option4ValId).val(),
      addfile: $(this.addfileValId).val(),
      type: $(this.typeValId).val(),
      score: $(this.scoreValId).val(),
      hint1: $(this.hint1ValId).val(),
      hint2: $(this.hint2ValId).val(),
      hint3: $(this.hint3ValId).val(),
      hint4: $(this.hint4ValId).val(),
      hint5: $(this.hint5ValId).val(),
    };

    this.create(json);
  }

  create(json) {
    let jsonStr = JSON.stringify(json);

    $.ajax({
      url: this.questionCreateAPI,
      type: 'POST',
      data: jsonStr
    }).then((data) => {
      $(this.addNewQuestionModalId).modal('hide');
      this.load();
    },
    (data) => {
      $(this.addNewQuestionModalId).modal('hide');
    });
  }

  edit(e) {
      let id = $(e).data('button');
      let json = {
        id:id
      };
      $.ajax({
        url: this.questionItemAPI,
        type: 'GET',
        data: $.param(json)
      }).then((data) => {
        let d = JSON.parse(data);
        d.result.forEach((value, index, arr) => {
          $(this.idValId).val(value.id);
          $(this.questionValId).val(value.question);
          $(this.levelValId).val(value.level);
          $(this.answerValId).val(value.answer);
          $(this.option1ValId).val(value.option1);
          $(this.option2ValId).val(value.option2);
          $(this.option3ValId).val(value.option3);
          $(this.option4ValId).val(value.option4);
          $(this.addfileValId).val(value.addfile);
          $(this.typeValId).val(value.type);
          $(this.scoreValId).val(value.score);
          $(this.hint1ValId).val(value.hint1);
          $(this.hint2ValId).val(value.hint2);
          $(this.hint3ValId).val(value.hint3);
          $(this.hint4ValId).val(value.hint4);
          $(this.hint5ValId).val(value.hint5);
          $(this.addQuestionBtnId).data('id', value.id);
          $(this.addNewQuestionModalId).modal();
        });
      },
      (data) => {
      });
  }
  load() {
    $.ajax({
      url: this.questionListAPI,
      type: 'GET',
    }).then((data) => {
      let d = JSON.parse(data);
      let result = $("#questions").render({questions:d.result});
      $("#container").html(result);
    },
    (data) => {
    });
  }
}
