require 'rails_helper'

feature 'User sign in', %q{
  In order to be able to ask question
  As an User
  I want to be able to sign in
} do

  scenario 'Registered user try to sign in' do
    user = User.create!(email: 'first@user.com', password: 'qwerty')

    visit new_user_session_path
    fill_in 'email', with: user.email
    fill_in 'пароль', with: 'qwerty'
    click_in 'Войти'

    expect(page).to have_content 'Вход в систему выполнен.'
    expect(current_path).to eq root_path
  end

  scenario 'Non-registered user try to sign in' do
    visit new_user_session_path
    fill_in 'email', with: user.email
    fill_in 'пароль', with: 'qwerty'
    click_in 'Войти'

    expect(page).to have_content 'Email и пароль не совпали.'
    expect(current_path).to eq root_path
  end
end
