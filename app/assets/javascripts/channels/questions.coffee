App.questions = App.cable.subscriptions.create "QuestionsChannel",
  connected: ->
    @perform 'follow'

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    $('#questions').append data
