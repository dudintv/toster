require 'rails_helper'

feature 'Delete answer', %q{
  In order to delete answer
  As an authenticated user
  I want to be able to delete own answers
} do

  before do
    @user = create(:user)
    @question = create(:question)
    @my_answer = create(:answer)
    @user.answers << @my_answer
    @question.answers << @my_answer
    @foreign_answer = create(:answer)
    @question.answers << @foreign_answer
  end
  
  scenario 'Authenticated user deletes own answer' do
    sign_in(@my_answer.user)
    visit question_path(@my_answer.question)
    click_on 'Удалить ответ'

    expect(page).to have_content 'Ответ успешно удален.'
    expect(page).to_not have_content @my_answer.title
    expect(current_path).to eq answers_path
  end

  scenario 'Guest user can not delete answer' do
    visit question_path(@my_answer.question)

    expect(page).to_not have_content 'Удалить ответ'
  end

  scenario 'Authenticated user try deletes foreign answer' do
    sign_in(@user)
    visit question_path(@foreign_answer.question)
    
    expect(page).to_not have_content 'Удалить ответ'
  end
end
