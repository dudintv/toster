require_relative '../feature_helper'

feature 'Edit question', '
  In order to clarify my question
  As an authenticated user and author question
  I want to be able to edit question
' do

  given(:user) { create(:user) }
  given(:my_question) { create(:question, user: user) }

  scenario 'Author of question edit own question', js: true do
    sign_in(user)

    visit question_path(my_question)
    click_on 'Редактировать вопрос'

    expect(page).to have_content 'Редактирование вопроса'
    expect(page).to_not have_content my_question.title
    expect(page).to_not have_content my_question.body
    expect(page).to_not have_link 'Редактировать вопрос'

    fill_in 'Вопрос', with: 'Обновленный вопрос'
    fill_in 'Подробности', with: 'Обновленные подробности'
    click_on 'Сохранить Вопрос'

    expect(page).to_not have_content 'Редактирование вопроса'
    expect(page).to have_content 'Обновленный вопрос'
    expect(page).to have_content 'Обновленные подробности'
  end
end