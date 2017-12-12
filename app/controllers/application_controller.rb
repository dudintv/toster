require 'application_responder'

class ApplicationController < ActionController::Base
  include Pundit
  after_action :verify_authorized, except: :index # pundid checking for set Pundid for all controllers 
  skip_after_action :verify_authorized, if: :devise_controller?
  rescue_from Pundit::NotAuthorizedError, with: :pundid_permission_denied

  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception

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

  def pundid_permission_denied(exception)
    respond_to do |format|
      format.json { render json: [exception.message], status: :forbidden }
      format.js { head :forbidden }
      format.html do
        path = request.referrer || root_path
        redirect_to path, alert: exception.message, status: :forbidden
      end
    end
  end
end
