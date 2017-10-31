class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @questions = Question.all
  end

  def show
    @question = Question.includes(:attachments, answers: [:attachments]).find(params[:id])
    @answer = Answer.new
    @answer.attachments.build
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def create
    @question = Question.create(question_params)
    @question.user = current_user
    if @question.save
      if params[:question][:attachments_attributes].present?
        params[:question][:attachments_attributes]['0'][:file].each do |a|
          @question.attachments.create!(file: a)
        end
      end
      flash[:notice] = 'Ваш Вопрос успешно опубликован.'
      redirect_to @question
    else
      render :new
    end
  end

  def update
    @question = Question.find(params[:id])
    if current_user.author_of?(@question) && @question.update(question_params)
      flash.now[:notice] = 'Ваш ответ обновлен.'
    else
      flash.now[:alert] = 'Невозможно обновить этот вопрос.'
    end
  end

  def destroy
    @question = Question.find(params[:id])
    if current_user.author_of?(@question) && @question.destroy
      flash[:notice] = 'Вопрос со всеми ответами успешно удален.'
      redirect_to questions_path
    else
      flash[:alert] = 'Не смог удалить этот вопрос.'
      render :show
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end
end
