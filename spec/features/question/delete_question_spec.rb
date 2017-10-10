require 'rails_helper'

feature 'Delete question', %q{
  In order to delete question
  As an authenticated user
  I want to be able to delete own questions
} do

  given(:user) { create(:user) }

  before do
    @my_question = create(:question)
    @my_question.user = user
    @other_question = create(:question)
  end
  
  scenario 'Authenticated user deletes own question' do
    sign_in(user)
    visit question_path(@my_question)
    click_on 'Удалить вопрос'

    expect(page).to have_content 'Вопрос со всеми ответами успешно удален.'
    expect(page).to_not have_content @my_question.title
    expect(current_path).to eq questions_path
  end

  scenario 'Guest user can not delete question'
    visit question_path(@my_question)

    expect(page).to_not have_content 'Удалить вопрос'
  end

  scenario 'Authenticated user try deletes foreign question' do
    sign_in(user)
    visit question_path(@other_question)
    
    expect(page).to_not have_content 'Удалить вопрос'
  end
end
