class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  after_action :publish_question, only: [:create]
  
  respond_to :js, only: [:update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @question = Question.includes(:attachments, answers: [:attachments]).find(params[:id])
    authorize @question
    gon_question
    @answer = Answer.new
    @answer.attachments.build
  end

  def new
    @question = Question.new
    authorize @question
    @question.attachments.build
  end

  def create
    @question = Question.create(question_params.merge(user: current_user))
    authorize @question
    gon_question
    save_attachments
    respond_with @question
  end

  def update
    @question = Question.find(params[:id])
    authorize @question
    gon_question
    save_attachments
    respond_with(@question.update(question_params))
  end

  def destroy
    @question = Question.find(params[:id])
    authorize @question
    respond_with(@question.destroy)
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end

  def save_attachments
    if params[:question][:attachments_attributes].present?
      params[:question][:attachments_attributes]['0'][:file]&.each do |a|
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
