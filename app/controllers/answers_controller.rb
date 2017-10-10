class AnswersController < ApplicationController
  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params)
    @answer.user = current_user
    if @answer.save
      redirect_to question_path(@question)
    else
      render template: 'questions/show'
    end
  end

  def destroy
    @question = Question.find(params[:question_id])
    @answer = Answer.find(params[:id])
    if user_signed_in? && @answer.user == current_user && @answer.delete
      flash[:notice] = 'Ответ успешно удален.'
      redirect_to question_path(@question)
    else
      flash[:alert] = 'Не смог удалить этот ответ.'
      render template: 'questions/show'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
