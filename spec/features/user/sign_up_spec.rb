require 'rails_helper'

feature 'User sign up', '
  In order to be able to ask question
  As an User
  I want to be able to sign in
' do

  given(:user) { User.new(email: 'uniq@email.com', password: 'qwerty') }
  given(:user_short_password) { User.new(email: 'uniq@email.com', password: 'qwert') }
  given(:user_wrong_email) { User.new(email: 'blabla', password: 'qwerty') }

  scenario 'User sign up' do
    sign_up(user)

    expect(page).to have_content 'Добро пожаловать! Вы зарегистрировались.'
    expect(current_path).to eq root_path
  end

  scenario 'User sign up with non-unique email' do
    user.save
    sign_up(user)
    expect(page).to have_content 'Emailуже существует'
  end

  scenario 'User sign up with short password' do
    sign_up(user_short_password)
    expect(page).to have_content 'Парольнедостаточной длины'
  end

  scenario 'User sign up with short password' do
    sign_up(user_wrong_email)
    expect(page).to have_content 'Emailимеет неверное значение'
  end
end
