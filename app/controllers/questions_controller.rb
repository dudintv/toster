class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @questions = Question.all
  end

  def show
    @question = Question.includes(:answers).find(params[:id])
    @answer = Answer.new
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.create(question_params)
    @question.user = current_user
    if @question.save
      flash[:notice] = 'Ваш Вопрос успешно опубликован.'
      redirect_to @question
    else
      render :new
    end
  end

  def destroy
    @question = Question.find(params[:id])
    if @question.delete
      flash[:notice] = 'Вопрос со всеми ответами успешно удален.'
      redirect_to questions_path
    else
      flash[:alert] = 'Не смог удалить этот вопрос.'
      render :show
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
