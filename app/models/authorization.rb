class Authorization < ApplicationRecord
  belongs_to :user

  after_create :generate_token

  private

  def generate_token
    update! confirmation_token: Devise.friendly_token(20)
  end
end
