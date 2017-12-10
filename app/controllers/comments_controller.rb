class CommentsController < ApplicationController
  before_action :authenticate_user!
  after_action :publish_comment

  respond_to :js

  def create
    @comment = Comment.new(comment_params.merge(user: current_user))
    authorize @comment
    respond_with(@comment.save)
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :commentable_id, :commentable_type)
  end

  def publish_comment
    return if @comment.errors.any?
    case @comment.commentable_type
    when 'Question'
      @question_id = @comment.commentable_id
    when 'Answer'
      @question_id = @comment.commentable.question_id
    end

    ActionCable.server.broadcast(
      "questions/#{@question_id}/comments",
      @comment
    )
  end
end
