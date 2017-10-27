require_relative '../feature_helper'

feature 'Delete question', '
  In order to delete question
  As an authenticated user
  I want to be able to delete own questions
' do

  given!(:user) { create(:user) }
  given!(:my_question) do
    user.questions << create(:question)
    user.questions.last
  end
  given!(:foreign_question) { create(:question) }

  scenario 'Authenticated user deletes own question' do
    sign_in(my_question.user)
    visit question_path(my_question)
    click_on 'Удалить вопрос'

    expect(page).to have_content 'Вопрос со всеми ответами успешно удален.'
    expect(page).to_not have_content my_question.title
    expect(current_path).to eq questions_path
  end

  scenario 'Guest user can not delete question' do
    visit question_path(my_question)

    expect(page).to_not have_content 'Удалить вопрос'
  end

  scenario 'Authenticated user try deletes foreign question' do
    sign_in(user)
    visit question_path(foreign_question)

    expect(page).to_not have_content 'Удалить вопрос'
  end
end
