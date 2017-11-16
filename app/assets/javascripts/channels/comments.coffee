App.comments = App.cable.subscriptions.create "CommentsChannel",
  connected: ->
    return unless gon.question_id
    @perform 'follow', question_id: gon.question_id

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    return if $("#comment-#{data['id']}")[0] != undefined

    console.log(data)
    commentable_type = data.commentable_type
    commentable_id = data.commentable_id

    switch commentable_type
      when "Answer"
        block = $("#answer-#{commentable_id}")
      when "Question"
        block = $("#question-block")


    console.log(block)
    console.log(block.find(".comments"))

    block.find(".comments").append App.utils.render('comment', data)
    block.find("#comment_body").val('')
    block.find(".new-comment-form").addClass("d-none")
    block.find(".add-comment").removeClass("d-none")
