require_relative '../feature_helper'

feature 'Voting for question', '
  In order to express my opinion about question
  As an authenticated user
  I want to be able to like or dislike any question (except my own)
' do

  given(:user) { create(:user) }
  given(:good_question) { create(:question) }
  given(:bad_question) { create(:question) }

  scenario 'Guest user can`t like or unlike question', js: true do
    visit question_path(good_question)
    within('#question-block') do
      click_on '.like'
    end
  end

  scenario 'Authenticated user like and unlike question', js: true do

  end

  scenario 'Authenticated user cancel own like and set unlike', js: true do

  end
end