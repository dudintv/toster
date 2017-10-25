question_ready = ->
  $('#question-block').on 'click', '#edit-question-link', (e) ->
    $('#edit-question-form').removeClass 'd-none'
    $('#question').addClass 'd-none'
    e.preventDefault()

$(document).on('turbolinks:load', question_ready)
