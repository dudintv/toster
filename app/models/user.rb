class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: [:facebook, :twitter, :vkontakte]

  def author_of?(obj)
    obj&.user_id == id
  end

  def self.generate(email)
    password = Devise.friendly_token(10)
    user = User.new(email: email, password: password, password_confirmation: password)
    user.skip_confirmation!
    user.save!
    user
  end

  def self.from_omniauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email]
    user = User.where(email: email).first
    if user
      # Если пользователь с таким email уже существует
      user.authorizations.create(provider: auth.provider, 
                                 uid: auth.uid.to_s,
                                 confirmed_at: Time.zone.now)
    else
      # Если пользователя создавать с нуля
      user = User.generate(email)
      user.authorizations.create(provider: auth.provider, 
                                 uid: auth.uid, 
                                 confirmed_at: Time.zone.now)
    end
    user
  end
end
