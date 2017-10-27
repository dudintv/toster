answer_ready = ->
  $('#answers').on 'click', '.edit-answer-link', (e) ->
    $(this).closest('.answer-block').find('.edit-answer-form').removeClass 'd-none'
    $(this).closest('.answer-block').find('.answer').addClass 'd-none'
    e.preventDefault()

$(document).on('turbolinks:load', answer_ready)
