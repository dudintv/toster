require_relative '../feature_helper'

feature 'Comment question', '
  In order to express my opinion about question
  As an authenticated user
  I want to be able to leave comment under certain question
' do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'User leave comment under question', js: true do
    sign_in(user)
    visit question_path(question)

    within('#question-block') do
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

    within('#question-block') do
      expect(page).to_not have_link 'добавить комментарий'
    end
  end
end
