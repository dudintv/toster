require 'application_responder'

class ApplicationController < ActionController::Base
  include Pundit
  after_action :verify_authorized

  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :permission_denied

  before_action :gon_user

  private

  def gon_user
    gon.user_signed_in = user_signed_in?
    gon.current_user_id = current_user.id if current_user
  end

  # for OmniAuth
  def success_omniauth_sign_in(user, kind)
    flash[:notice] = "Успешно вошли на сайт через #{kind}"
    sign_in_and_redirect user, event: :authentication
  end

  def permission_denied
    flash[:alert] = 'Извините. Это действие запрещено.'
    redirect_to request.referrer || root_path
  end
end
