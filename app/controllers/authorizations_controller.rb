class AuthorizationsController < ApplicationController
  def confirm
    session[:auth] = nil
    authorization = Authorization.find(params[:id])
    if params[:token] && params[:token] == authorization.confirmation_token
      authorization.update! confirmed_at: Time.zone.now
      success_sign_in(authorization.user, authorization.provider)
    else
      flash[:alert] = 'Код подтверждения не совпал. Подтверждение невозможно.'
      redirect_to root_path
    end
  end

  def create
    user = User.where(email: params[:email]).first
    unless user
      password = Devise.friendly_token(10)
      user = User.new(email: params[:email], password: password, password_confirmation: password)
      user.skip_confirmation!
      user.save!
    end
    @authorization = Authorization.create(provider: session[:auth]['provider'], uid: session[:auth]['uid'], user: user)
    send_confirmation
    render 'authorization/send_confirmation'
  end

  def resend
    @authorization = Authorization.find(params[:id])
    send_confirmation if @authorization
  end

  private

  def send_confirmation
    puts '-------------SEND CONFIRMATION -------------'
    AuthorizationMailer.with(id: @authorization.id).confirmation.deliver_now
  end
end
