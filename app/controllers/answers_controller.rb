class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question

  def create
    # @answer = @question.answers.new(answer_params)
    @answer = Answer.new(answer_params)
    @answer.question = @question
    @answer.user = current_user
    if @answer.save
      redirect_to question_path(@question)
    else
      render 'questions/show'
    end
  end

  def destroy
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

  def set_question
    @question = Question.find(params[:question_id])
  end
end
