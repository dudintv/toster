class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    # @answer = @question.answers.create(answer_params)
    @answer = Answer.create(answer_params)
    @answer.question = @question
    @answer.user = current_user
    if @answer.save
      redirect_to question_path(@question)
    else
      render 'questions/show'
    end
  end

  def destroy
    @question = Question.find(params[:question_id])
    @answer = Answer.find(params[:id])
    if current_user.author_of?(@answer) && @answer.delete
      flash[:notice] = 'Ответ успешно удален.'
      redirect_to question_path(@question)
    else
      flash[:alert] = 'Не смог удалить этот ответ.'
      render 'questions/show'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
