comment_ready = ->
  console.log 'comment load'
  $(document).on 'click', '.add-comment', (e) ->
    e.preventDefault()
    $(e.target).closest('.comments').find('.add-comment-form').removeClass('d-none')
    $(e.target).addClass('d-none')

$(document).on('turbolinks:load', comment_ready)
