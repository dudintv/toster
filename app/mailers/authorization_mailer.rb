class AuthorizationMailer < ApplicationMailer
  def confirmation
    @auth = Authorization.find(params[:id])

    mail to: params[:email]
  end
end
