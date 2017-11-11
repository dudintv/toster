class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :set_answer, except: [:create]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
    save_attachments
  end

  def update
    @question = @answer.question
    if current_user.author_of?(@answer) && @answer.update(answer_params)
      save_attachments
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
    @question = @answer.question
    if current_user.author_of?(@question)
      @answer.set_as_best
    else
      flash.now[:alert] = 'Вы не можете устанавливать лучший ответ на чужой вопрос.'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def save_attachments
    if params[:answer][:attachments_attributes].present?
      params[:answer][:attachments_attributes]['0'][:file].each do |a|
        @answer.attachments.create!(file: a)
      end
    end
  end
end
