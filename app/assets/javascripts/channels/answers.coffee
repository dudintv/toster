App.answers = App.cable.subscriptions.create "AnswersChannel",
  connected: ->
    return unless gon.question_id
    console.log 'follow for answer of question_id = '+gon.question_id
    @perform 'follow', question_id: gon.question_id

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    return if $("#answer-#{data['id']}")[0] != undefined
    $("#answers").append App.utils.render('answer', data)

$(document).on 'turbolinks:load', -> App.answers.connected()
