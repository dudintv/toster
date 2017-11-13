class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]

  after_action :publish_question, only: [:create]

  def index
    @questions = Question.all
  end

  def show
    @question = Question.includes(:attachments, answers: [:attachments]).find(params[:id])
    gon_question
    @answer = Answer.new
    @answer.attachments.build
    gon.question_id = @question.id
    gon.question_user_id = @question.user_id
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def create
    @question = Question.create(question_params)
    gon_question
    @question.user = current_user
    if @question.save
      save_attachments
      flash[:notice] = 'Ваш Вопрос успешно опубликован.'
      redirect_to @question
    else
      render :new
    end
  end

  def update
    @question = Question.find(params[:id])
    gon_question
    if current_user.author_of?(@question) && @question.update(question_params)
      save_attachments
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

  def save_attachments
    if params[:question][:attachments_attributes].present?
      params[:question][:attachments_attributes]['0'][:file].each do |a|
        @question.attachments.create!(file: a)
      end
    end
  end

  def gon_question
    gon.question_id = @question.id
    gon.question_user_id = @question.user_id
  end

  # ACTION CABLE
  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast(
      'questions', 
      ApplicationController.render(
        partial: 'questions/question',
        locals: { question: @question }
      )
    )
  end
end
