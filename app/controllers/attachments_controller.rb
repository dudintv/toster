class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @attachment = Attachment.find(params[:id])

    if current_user.author_of?(@attachment.attachable)
      @attachment.destroy
      flash.now[:notice] = 'Ваш файл удален'
    else
      flash.now[:notice] = 'Нельзя удалить чужой файл'
    end
  end
end
