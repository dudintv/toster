require 'rails_helper'

feature 'Create question', %q{
  In order to get answer from other users
  As an authenticated user
  I want to be able to ask question
} do
  scenario 'Authenticated user creates question' do
    user = User.create!(email: 'first@user.com', password: 'qwerty')

    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Пароль', with: 'qwerty'
    click_on 'Войти'

    visit questions_path
    click_on 'Новый вопрос'
    fill_in 'Вопрос', with: 'Сам вопрос'
    fill_in 'Подробности', with: 'Подробности'
    click_on 'Создать Вопрос'

    expect(page).to have_content 'Ваш Вопрос успешно опубликован.'
  end

  scenario 'Non-authenticated user tries to create question' do
    visit questions_path
    click_on 'Новый вопрос'
    expect(page).to have_content 'Вам необходимо войти в систему или зарегистрироваться.'
  end
end
