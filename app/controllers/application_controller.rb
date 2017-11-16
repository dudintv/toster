class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :gon_user

  private

  def gon_user
    gon.user_signed_in = user_signed_in?
    gon.current_user_id = current_user.id if current_user
  end
end
