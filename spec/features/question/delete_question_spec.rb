require 'rails_helper'

feature 'Delete question', '
  In order to delete question
  As an authenticated user
  I want to be able to delete own questions
' do

  before do
    @user = create(:user)
    @my_question = create(:question)
    @user.questions << @my_question
    @other_question = create(:question)
  end

  scenario 'Authenticated user deletes own question' do
    sign_in(@my_question.user)
    visit question_path(@my_question)
    click_on 'Удалить вопрос'

    expect(page).to have_content 'Вопрос со всеми ответами успешно удален.'
    expect(page).to_not have_content @my_question.title
    expect(current_path).to eq questions_path
  end

  scenario 'Guest user can not delete question' do
    visit question_path(@my_question)

    expect(page).to_not have_content 'Удалить вопрос'
  end

  scenario 'Authenticated user try deletes foreign question' do
    sign_in(@user)
    visit question_path(@other_question)

    expect(page).to_not have_content 'Удалить вопрос'
  end
end
