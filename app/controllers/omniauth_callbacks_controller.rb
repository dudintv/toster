class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @auth = request.env['omniauth.auth']
    @authorization = Authorization.where(provider: @auth.provider, uid: @auth.uid.to_s).first

    if @authorization
      if @authorization.confirmed_at.present?
        success_sign_in(@authorization.user, @authorization.provider)
      else
        render 'authorization/unconfirmed'
      end
    else
      create_authorization
    end
  end

  def failure
    redirect_to root_path
  end

  private

  def create_authorization
    if @auth.info[:email]
      @user = User.from_omniauth(@auth)
      if @user&.persisted?
        success_sign_in(@user, @auth.provider)
      else
        session['devise.omniauth_data'] = request.env['omniauth.auth']
        redirect_to new_user_registration_url
      end
    else
      render 'authorization/new'
    end
  end
end
