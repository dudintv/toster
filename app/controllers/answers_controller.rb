class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question
  before_action :set_answer, except: [:create]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    if current_user.author_of?(@answer) && @answer.update(answer_params)
      flash.now[:notice] = 'Ваш ответ обновлен.'
    else
      flash[:alert] = 'Чтобы обновить ваш ответ надо войти в систему.'
      redirect_to new_user_session_path unless user_signed_in?
    end
  end

  def destroy
    if current_user.author_of?(@answer) && @answer.delete
      flash.now[:notice] = 'Ваш ответ удален.'
    else
      flash[:alert] = 'Чтобы удалить ваш ответ надо войти в систему.'
      redirect_to new_user_session_path unless user_signed_in?
    end
  end

  def set_as_best
    if current_user.author_of?(@answer.question)
      @answer.set_as_best
    else
      flash.now[:alert] = 'Вы не можете устанавливать лучший ответ на чужой вопрос.'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end
end
