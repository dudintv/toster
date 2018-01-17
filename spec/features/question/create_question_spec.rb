require_relative '../feature_helper'

feature 'Create question', '
  In order to get answer from other users
  As an authenticated user
  I want to be able to ask question
' do

  given(:user) { create(:user) }

  scenario 'Authenticated user creates question', js: true do
    sign_in(user)

    visit questions_path
    click_on 'Новый вопрос'
    fill_in 'Вопрос', with: 'Сам вопрос'
    fill_in 'Подробности', with: 'Подробности'
    click_on 'Создать Вопрос'

    expect(page).to have_content 'Сам вопрос'
    expect(page).to have_content 'Ваш Вопрос успешно опубликован.'
  end

  scenario 'Non-authenticated user tries to create question', js: true do
    visit questions_path
    click_on 'Новый вопрос'
    expect(page).to have_content 'Вам необходимо войти в систему или зарегистрироваться.'
  end

  scenario 'Authenticated user can not create question with invalid data', js: true do
    sign_in(user)
    visit questions_path
    click_on 'Новый вопрос'
    click_on 'Создать Вопрос'

    expect(page).to have_content 'Есть проблемы с сохранением.'
    expect(page).to have_content 'Вопросне может быть пустым'
    expect(page).to have_content 'Подробности не может быть пустым'
  end

  context 'multiple sessions' do
    scenario 'new question appear on another browser tab', js: true do
      Capybara.using_session('user') do
        sign_in user
        visit questions_path
      end
      Capybara.using_session('guest') do
        visit questions_path
      end
      Capybara.using_session('user') do
        click_on 'Новый вопрос'
        fill_in 'Вопрос', with: 'Сам вопрос'
        fill_in 'Подробности', with: 'Подробности'
        click_on 'Создать Вопрос'
        expect(page).to have_content 'Сам вопрос'
      end
      Capybara.using_session('guest') do
        expect(page).to have_content 'Сам вопрос'
      end
    end
  end
end
