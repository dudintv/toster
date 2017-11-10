vote_ready = ->
  $('.voting a').bind 'ajax:success', (e) ->
    response = e.detail[0]

    if response.type == 'Question'
      votable = $("#question")
    else if response.type == 'Answer'
      id = $(this).data('answerId')
      votable = $("#answer-#{response.id}")

    votable.find("#vote_count").val(response.value)

    if response.have_vote
      votable.find(".vote-up").addClass('d-none')
      votable.find(".vote-down").addClass('d-none')
      votable.find(".vote-cancel").removeClass('d-none')
      if response.positive_vote
        votable.find(".cancel-up").removeClass('d-none')
        votable.find(".cancel-down").addClass('d-none')
      else
        votable.find(".cancel-up").addClass('d-none')
        votable.find(".cancel-down").removeClass('d-none')
    else
      votable.find(".vote-up").removeClass('d-none')
      votable.find(".vote-down").removeClass('d-none')
      votable.find(".vote-cancel").addClass('d-none')

$(document).on('turbolinks:load', vote_ready)
