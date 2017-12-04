class AuthorizationsController < ApplicationController
  def confirm
    authorization = Authorization.find(params[:id])
    if params[:token] && params[:token] == authorization.confirmation_token
      authorization.confirmed_at = Time.zone.now
      success_sign_in(authorization.user, authorization.provider)
    else
      flash[:alert] = 'Код подтверждения не совпал. Подтверждение невозможно.'
    end
    redirect_to root_path
  end

  def create
    Authorization.create(authorization_params.merge(user: current_user))
    # TODO: send confirmation email
    redirect_to root_path
  end

  def change_email; end

  private

  def authorization_params
    params.require(:authorization).permit(:provider, :uid)
  end
end
