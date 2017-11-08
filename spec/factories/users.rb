FactoryBot.define do
  sequence(:email) { |n| "user_#{n}@email.com" }

  factory :user do
    email
    password 'qwerty'
    password_confirmation 'qwerty'
  end
end
