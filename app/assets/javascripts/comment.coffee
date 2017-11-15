comment_ready = ->
  $(document).on 'click', '.add-comment', (e) ->
    e.preventDefault()
    $(e.target).closest('.comments-block').find('.new-comment-form').removeClass('d-none')
    $(e.target).addClass('d-none')

$(document).on('turbolinks:load', comment_ready)
