class Api::V1::QuestionsController < Api::V1::BaseController
  def index
    @questions = Question.all
    authorize @questions
    respond_with @questions, each_serializer: QuestionOnlySerializer
  end

  def show
    @question = Question.find(params[:id])
    authorize @question
    respond_with @question
  end

  def create
    authorize Question
    @question = Question.create(question_params.merge(user: current_resource_owner))
    respond_with @question
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
