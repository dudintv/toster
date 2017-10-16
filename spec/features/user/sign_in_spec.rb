require 'rails_helper'

feature 'User sign in', '
  In order to be able to ask question
  As an User
  I want to be able to sign in
' do

  given(:user) { create(:user) }

  scenario 'Registered user try to sign in' do
    sign_in(user)

    expect(page).to have_content 'Вход в систему выполнен.'
    expect(current_path).to eq root_path
  end

  scenario 'Non-registered user try to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'some_other@email.com'
    fill_in 'Пароль', with: 'qwerty'
    click_on 'Войти'

    expect(page).to have_content 'Неверный Email или пароль.'
    expect(current_path).to eq new_user_session_path
  end
end
