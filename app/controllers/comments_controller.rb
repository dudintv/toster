class CommentsController < ApplicationController
  before_action :authenticate_user!

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
end
