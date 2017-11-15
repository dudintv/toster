class CommentsController < ApplicationController
  before_action :authenticate_user!
  after_action :publish_comment

  def create
    @comment = Comment.new(comment_params.merge(user: current_user))
    if @comment.save
      flash[:notice] = 'Комментарий добавлен'
    else
      head :unprocessable_entity
    end
  end

  # def destroy
  #   @comment = Comment.find(params[:id])
  #   if current_user.author_of?(@comment)
  #     @comment.destroy
  #   else
  #     head :forbidden
  #   end
  # end

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
