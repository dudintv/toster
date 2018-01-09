require_relative '../feature_helper'

feature 'Search', '
  In order to search something in site
  As an any user
  I want to be able to get list resources contain searching string
' do
  given!(:user) { create(:user, email: 'ask@email.com') }
  given(:foreign_user) { create(:user) }
  given!(:question) { create(:question, title: 'ask') }
  given!(:answer) { create(:answer, body: 'ask') }
  given!(:comment) { create(:comment, user: foreign_user, commentable: question, body: 'ask') }

  before do
    ThinkingSphinx::Test.index
    visit root_path
  end

  { Answer: 'Ответ', Comment: 'Комментарий', Question: 'Вопрос', User: 'Пользователь' }.each do |k, v|
    scenario "User can search in #{k}", js: true, sphinx: true do
      ThinkingSphinx::Test.run do
        select(k, from: 'search_object')
        fill_in 'search_string', with: 'ask'
        click_on 'Поиск'
        # save_and_open_page
        within '#search-result' do
          expect(page).to have_content v.singularize
        end
      end
    end
  end

  scenario 'User search everything', js: true, sphinx: true do
    ThinkingSphinx::Test.run do
      select('Everywhere', from: 'search_object')
      fill_in 'search_string', with: 'ask'
      click_on 'Поиск'
      within '#search-result' do
        expect(page).to have_content 'Вопрос'
        expect(page).to have_content 'Ответ'
        expect(page).to have_content 'Комментарий'
        expect(page).to have_content 'Пользователь'
        expect(page).to have_content 'Найдено элементов: 4'
      end
    end
  end
end
