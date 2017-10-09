FactoryGirl.define do
  sequence :email do |n|
    "user_#{n}@email.com"
  end

  factory :user do
    email
    password 'qwerty'
    password_confirmation 'qwerty'
  end
end
