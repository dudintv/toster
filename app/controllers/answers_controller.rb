class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :load_and_authorize_answer, except: [:create]
  before_action :load_question, except: [:create]
  after_action :publish_answer, only: [:create]

  respond_to :js, only: [:create, :update, :destroy, :set_as_best]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params.merge(user: current_user))
    authorize @answer
    save_attachments
    respond_with @answer
  end

  def update
    save_attachments
    respond_with(@answer.update(answer_params)) if current_user.author_of?(@answer)
  end

  def destroy
    respond_with(@answer.delete) if current_user.author_of?(@answer)
  end

  def set_as_best
    respond_with(@answer.set_as_best) if current_user.author_of?(@question)
  end

  private

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
  end

  def load_and_authorize_answer
    @answer = Answer.find(params[:id])
    authorize @answer
  end

  def load_question
    @question = @answer.question
  end

  def save_attachments
    if params[:answer][:attachments_attributes].present?
      params[:answer][:attachments_attributes]['0'][:file].each do |a|
        @answer.attachments.create!(file: a)
      end
    end
  end
  
  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast(
      "questions/#{@question.id}/answers",
      @answer.to_json(include: [:attachments, :user])
    )
  end
end
