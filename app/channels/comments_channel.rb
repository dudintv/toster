class CommentsChannel < ApplicationCable::Channel
  def follow(params)
    stop_all_streams
    stream_from "questions/#{params['question_id']}/comments"
  end
end
