require_relative '../feature_helper'

feature 'Delete answer', '
  In order to delete answer
  As an authenticated user
  I want to be able to delete own answers
' do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:my_answer) { create(:answer, question: question, user: user) }
  given!(:foreign_answer) { create(:answer, question: question) }

  scenario 'Authenticated user deletes own answer', js: true do
    sign_in(user)
    visit question_path(question)
    click_on 'Удалить ответ'

    expect(page).to have_content 'Ваш ответ удален.'
    expect(page).to_not have_content my_answer.body
    expect(current_path).to eq question_path(my_answer.question)
  end

  scenario 'Authenticated user can not delete foreign answer' do
    sign_in(user)
    visit question_path(foreign_answer.question)

    within "#answer-#{foreign_answer.id}" do
      expect(page).to_not have_content 'Удалить ответ'
    end
  end

  scenario 'Guest user can not delete answer' do
    visit question_path(my_answer.question)

    expect(page).to_not have_content 'Удалить ответ'
  end
end
