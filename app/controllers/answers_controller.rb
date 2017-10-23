class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def destroy
    @answer = Answer.find(params[:id])
    if current_user.author_of?(@answer) && @answer.delete
      flash.now[:notice] = 'Ваш ответ удален.'
    else
      flash[:alert] = 'Чтобы удалить ваш ответ надо войти в систему.'
      redirect_to new_user_session_path unless user_signed_in?
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_question
    @question = Question.find(params[:question_id])
  end
end
