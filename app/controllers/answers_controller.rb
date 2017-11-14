class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :set_answer, except: [:create]
  after_action :publish_answer, only: [:create]

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
      puts '-------'
      puts params[:answer][:attachments_attributes].inspect
      puts '_______'
      params[:answer][:attachments_attributes]['0'][:file].each do |a|
        puts a.inspect
        @answer.attachments.create!(file: a)
      end
      puts 'xxxxxxx'
    end
  end

  # -------
  # <ActionController::Parameters {"0"=>{"file"=>["C:\\fakepath\\2017-03-26_23-48-57.png"]}} permitted: false>
  # "C:\\fakepath\\2017-03-26_23-48-57.png"

  # -------
  # <ActionController::Parameters {"0"=>{"file"=>[#<ActionDispatch::Http::UploadedFile:0x007fcaf04c7d28 @tempfile=#<Tempfile:/var/folders/zh/xr6fw9jx5k179gmrqgf9nj380000gn/T/RackMultipart20171114-99099-d4asvj.png>, @original_filename="2017-03-26_23-41-12.png", @content_type="image/png", @headers="Content-Disposition: form-data; name=\"answer[attachments_attributes][0][file][]\"; filename=\"2017-03-26_23-41-12.png\"\r\nContent-Type: image/png\r\n">, #<ActionDispatch::Http::UploadedFile:0x007fcaf04c7c60 @tempfile=#<Tempfile:/var/folders/zh/xr6fw9jx5k179gmrqgf9nj380000gn/T/RackMultipart20171114-99099-103m1e5.png>, @original_filename="2017-03-26_23-48-25.png", @content_type="image/png", @headers="Content-Disposition: form-data; name=\"answer[attachments_attributes][0][file][]\"; filename=\"2017-03-26_23-48-25.png\"\r\nContent-Type: image/png\r\n">], "id"=>"28"}} permitted: false>
  # _______
  #<ActionDispatch::Http::UploadedFile:0x007fcaf04c7d28 @tempfile=#<Tempfile:/var/folders/zh/xr6fw9jx5k179gmrqgf9nj380000gn/T/RackMultipart20171114-99099-d4asvj.png>, @original_filename="2017-03-26_23-41-12.png", @content_type="image/png", @headers="Content-Disposition: form-data; name=\"answer[attachments_attributes][0][file][]\"; filename=\"2017-03-26_23-41-12.png\"\r\nContent-Type: image/png\r\n">


  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast(
      "questions/#{@question.id}/answers",
      @answer.to_json(include: [:attachments, :user])
    )
  end
end
