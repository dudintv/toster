require_relative '../feature_helper'

feature 'Edit answer', '
  In order to fix mistakes
  As an author of answer
  I want to be able to edit my answer
' do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:my_answer) { create(:answer, question: question, user: user) }
  given!(:foreign_answer) { create(:answer, question: question) }

  scenario 'Author of answer edit own answer', js: true do
    sign_in(user)
    visit question_path(question)

    within "#answer-#{my_answer.id}" do
      click_on 'Редактировать ответ'

      # Появилась форма редактирования:
      expect(page).to have_content 'Редактирование ответа'
      expect(page).to_not have_link 'Редактировать ответа'

      fill_in 'Ответ', with: 'Обновленный ответ'
      click_on 'Сохранить Ответ'

      expect(page).to_not have_content 'Редактирование ответа'
      expect(page).to have_content 'Обновленный ответ'
    end
  end

  scenario 'Non-author can not see edit-link of answer' do
    sign_in(user)
    visit question_path(question)

    within "#answer-#{foreign_answer.id}" do
      expect(page).to_not have_link 'Редактировать ответа'
    end
  end

  scenario 'Guest can not see edit-link of answer' do
    visit question_path(question)

    within "#answer-#{foreign_answer.id}" do
      expect(page).to_not have_link 'Редактировать ответа'
    end
  end
end
