require 'rails_helper'

feature 'Create question', '
  In order to get answer from other users
  As an authenticated user
  I want to be able to ask question
' do

  given(:user) { create(:user) }

  scenario 'Authenticated user creates question' do
    sign_in(user)

    visit questions_path
    click_on 'Новый вопрос'
    fill_in 'Вопрос', with: 'Сам вопрос'
    fill_in 'Подробности', with: 'Подробности'
    click_on 'Создать Вопрос'

    # save_and_open_page

    expect(page).to have_content 'Сам вопрос'
    expect(page).to have_content 'Ваш Вопрос успешно опубликован.'
  end

  scenario 'Non-authenticated user tries to create question' do
    visit questions_path
    click_on 'Новый вопрос'
    expect(page).to have_content 'Вам необходимо войти в систему или зарегистрироваться.'
  end

  scenario 'Authenticated user can not create question with invalid data' do
    sign_in(user)
    visit questions_path
    click_on 'Новый вопрос'
    click_on 'Создать Вопрос'

    expect(page).to have_content 'Тут есть проблемы:'
    expect(page).to have_content 'Вопросне может быть пустым'
    expect(page).to have_content 'Подробности не может быть пустым'
  end
end
