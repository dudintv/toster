require_relative '../feature_helper'

feature 'Voting for question', '
  In order to express my opinion about question
  As an authenticated user
  I want to be able to like or dislike any question (except my own)
' do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:good_question) { create(:question) }
  given(:bad_question) { create(:question) }

  scenario 'Guest user can`t like or unlike question', js: true do
    visit question_path(good_question)
    within('#question-block') do
      expect(page).to have_no_link('.vote-up', visible: false)
      expect(page).to have_no_link('.vote-down', visible: false)
      expect(page).to have_no_link('.vote-cancel', visible: false)
    end
  end

  scenario 'Authenticated user like and unlike question', js: true do
    sign_in(user)
    visit question_path(good_question)
    within('#question-block') do
      find('.vote-up', visible: false).click
      eventually do
        expect(find_field('vote_count').value).to eq '1'
      end
    end
    visit question_path(bad_question)
    within('#question-block') do
      find('.vote-down', visible: false).click
      eventually do
        expect(find_field('vote_count').value).to eq '-1'
      end
    end
  end

  scenario 'Authenticated user cancel own like and set unlike', js: true do
    sign_in(user)
    visit question_path(bad_question)
    within('#question-block') do
      find('.vote-up', visible: false).click
      eventually do
        expect(find_field('vote_count').value).to eq '1'
      end
      find('.vote-cancel', visible: false).click
      eventually do
        expect(find_field('vote_count').value).to eq '0'
      end
      find('.vote-down', visible: false).click
      eventually do
        expect(find_field('vote_count').value).to eq '-1'
      end
    end
  end

  scenario 'Two authenticated users sums own likes for one question', js: true do
    sign_in(user)
    visit question_path(good_question)
    within('#question-block') do
      find('.vote-up', visible: false).click
    end
    sign_out
    sign_in(user2)
    visit question_path(good_question)
    within('#question-block') do
      find('.vote-up', visible: false).click
      eventually do
        expect(find_field('vote_count').value).to eq '2'
      end
    end
  end
end
