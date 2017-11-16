class AnswersChannel < ApplicationCable::Channel
  def follow(params)
    stop_all_streams
    stream_from "questions/#{params['question_id']}/answers"
  end
end
