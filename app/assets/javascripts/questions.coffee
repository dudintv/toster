question_ready = ->
  $('#question-block').on 'click', '#edit-question-link', (e) ->
    e.preventDefault()
    $('#edit-question-form').removeClass 'd-none'
    $('#question').addClass 'd-none'

$(document).on('turbolinks:load', question_ready)
