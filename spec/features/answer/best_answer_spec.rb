require_relative '../feature_helper'

feature 'Best answer', '
  In order to mark the best answer
  As an authenticated user and author of question
  I want to be able to choose best answer
' do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'Author of question can choose best answer' do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_content 'Выбрать ответ как лучший'
  end
end
