class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :authorize, except: [:failure]

  def facebook; end

  def twitter; end

  def vkontakte; end

  def failure
    redirect_to root_path
  end

  private

  def authorize
    @auth = request.env['omniauth.auth']
    @authorization = Authorization.where(provider: @auth.provider, uid: @auth.uid.to_s).first

    if @authorization
      if @authorization.confirmed_at.present?
        success_sign_in(@authorization.user, @authorization.provider)
      else
        @email = @authorization.user.email
        render 'authorization/unconfirmed'
      end
    else
      create_new_authorization
    end
  end

  def create_new_authorization
    # pry
    if @auth.info && @auth.info[:email]
      @user = User.from_omniauth(@auth)
      if @user&.persisted?
        success_sign_in(@user, @auth.provider)
      else
        session["#{@auth.provider}.omniauth_data"] = request.env['omniauth.auth']
        redirect_to new_user_registration_url
      end
    else
      flash.now[:notice] = "Успешная авторизация через #{@auth.provider}"
      session[:auth] = { uid: @auth.uid, provider: @auth.provider }
      @authorization = Authorization.new(provider: @auth.provider, uid: @auth.uid.to_s)
      render 'authorization/new'
    end
  end
end
