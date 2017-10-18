require_relative '../feature_helper'

feature 'Create answer', '
  In order to leave answer for a question
  As an authenticated user
  I want to be able to write answer directly on question page
' do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Guest user do not see create-answer-field on question page' do
    visit question_path(question)

    expect(page).to_not have_field 'Ответ'
    expect(page).to have_content 'Чтобы оставить ответ войдите на сайт.'
  end

  scenario 'Authenticated user creates answer on question page', js: true do
    sign_in(user)
    visit question_path(question)
    fill_in 'Ответ', with: 'Мой ответ'
    click_on 'Создать Ответ'

    within '#answers' do
      expect(page).to have_content 'Мой ответ'
    end
  end

  scenario 'Authenticated user can not create answer with invalid data', js: true do
    sign_in(user)
    visit question_path(question)
    click_on 'Создать Ответ'

    expect(page).to have_content 'Новый ответне может быть пустым'
  end
end
