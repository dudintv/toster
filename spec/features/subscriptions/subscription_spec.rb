require_relative '../feature_helper'

feature 'Subscribe question', '
  In order to follow to question
  As an authenticated user
  I want to be able to leave subscribe for new answers of question
' do
  given(:user) { create(:user) }
  given(:foreign_user) { create(:user) }
  given!(:question) { create(:question, user: foreign_user) }

  scenario 'Authenticated user subscribe and unsubscribe', js: true do
    sign_in(user)
    visit question_path(question.id)

    within '#subscription' do
      click_link 'Подписаться'
      click_link 'Отписаться'
      expect(page).to have_link('Подписаться')
    end
  end

  scenario 'Not authenticated user cant subscribe', js: true do
    visit questions_path

    expect(page).to_not have_link('Подписаться')
  end
end
