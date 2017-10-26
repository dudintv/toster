require_relative '../feature_helper'

feature 'Edit question', '
  In order to clarify my question
  As an authenticated user and author question
  I want to be able to edit question
' do

  given(:user) { create(:user) }
  given(:my_question) { create(:question, user: user) }
  given(:foreign_question) { create(:question) }

  scenario 'Author of question edit own question', js: true do
    sign_in(user)
    visit question_path(my_question)

    within '#question-block' do
      click_on 'Редактировать вопрос'

      # Появилась форма редактирования:
      expect(page).to have_content 'Редактирование вопроса'
      # Исходный вопрос был скрыт:
      expect(page).to_not have_content my_question.title
      expect(page).to_not have_content my_question.body
      expect(page).to_not have_link 'Редактировать вопрос'

      # Заполним новыми данными
      fill_in 'Вопрос', with: 'Обновленный вопрос'
      fill_in 'Подробности', with: 'Обновленные подробности'
      click_on 'Сохранить Вопрос'

      expect(page).to_not have_content 'Редактирование вопроса'
      expect(page).to have_content 'Обновленный вопрос'
      expect(page).to have_content 'Обновленные подробности'
    end
  end

  scenario 'Author of question can not update question with invalid data', js: true do
    sign_in(user)
    visit question_path(my_question)

    within '#question-block' do
      click_on 'Редактировать вопрос'
      fill_in 'Вопрос', with: ''
      fill_in 'Подробности', with: ''
      click_on 'Сохранить Вопрос'

      expect(page).to have_content 'Вопрос не может быть пустым'
      expect(page).to have_content 'Подробности вопроса не может быть пустым'
    end
  end

  scenario 'Non-author can`t edit question' do
    sign_in(user)
    visit question_path(foreign_question)

    expect(page).to_not have_link 'Редактировать вопрос'
  end

  scenario 'Guest can`t edit question' do
    visit question_path(foreign_question)

    expect(page).to_not have_link 'Редактировать вопрос'
  end
end
