require_relative '../feature_helper'

feature 'Comment answer', '
  In order to express my opinion about answer
  As an authenticated user
  I want to be able to leave comment under certain answer
' do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'User leave comment unde answer', js: true do
    sign_in(user)
    visit question_path(question)

    within("#answer-#{answer.id}") do
      click_on 'добавить комментарий'
      fill_in 'Комментарий', with: 'мой комментарий'
      click_on 'Создать Комментарий'

      expect(page).to_not have_selector('Комментарий')
      within('.comments') do
        expect(page).to have_content 'мой комментарий'
      end
    end
  end

  scenario 'Guest can not comments answers' do
    visit question_path(question)

    within('#answers') do
      expect(page).to_not have_link 'добавить комментарий'
    end
  end

  context 'multiple sessions' do
    scenario 'new comment appear on another browser tab', js: true do
      Capybara.using_session('user') do
        sign_in user
        visit question_path(question)
      end
      Capybara.using_session('guest') do
        visit question_path(question)
      end
      Capybara.using_session('user') do
        within("#answer-#{answer.id}") do
          click_on 'добавить комментарий'
          fill_in 'Комментарий', with: 'мой комментарий'
          click_on 'Создать Комментарий'

          within('.comments') do
            expect(page).to have_content 'мой комментарий'
          end
        end
      end
      Capybara.using_session('guest') do
        within("#answer-#{answer.id} .comments") do
          expect(page).to have_content 'мой комментарий'
        end
      end
    end
  end
end
