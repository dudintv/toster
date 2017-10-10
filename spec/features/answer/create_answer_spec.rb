require 'rails_helper'

feature 'Create answer', '
  In order to leave answer for a question
  As an authenticated user
  I want to be able to write answer directly on question page
' do

  given(:user) { create(:user) }

  before do
    @question = create(:question)
  end

  scenario 'Guest user do not see create-answer-field on question page' do
    visit question_path(@question)

    expect(page).to_not have_field 'Ответ'
    expect(page).to have_content 'Чтобы оставить ответ войдите на сайт.'
  end

  scenario 'Authenticated user see create-answer-field on question page' do
    sign_in(user)
    visit question_path(@question)

    expect(page).to have_field 'Ответ'
  end

  scenario 'Authenticated user creates answer on question page' do
    sign_in(user)
    visit question_path(@question)
    fill_in 'Ответ', with: 'Мой ответ'
    click_on 'Создать Ответ'

    expect(page).to have_content 'Мой ответ'
    expect(@question.answers.count).to eq 1
    expect(current_path).to eq question_path(@question)
  end
end
