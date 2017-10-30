require_relative '../feature_helper'

feature 'Attach files to Question', '
  In order to clarify my question
  As an authenticated user and author question
  I want to be able to attach file to my question
' do

  given(:user) { create(:user) }

  scenario 'Authenticated user creates question with attach file', js: true do
    sign_in(user)

    visit questions_path
    click_on 'Новый вопрос'
    fill_in 'Вопрос', with: 'Сам вопрос'
    fill_in 'Подробности', with: 'Подробности'
    attach_file 'question[attachments_attributes][0][file]', "#{Rails.root}/spec/rails_helper.rb"
    click_on 'Создать Вопрос'

    expect(page).to have_link('rails_helper.rb', href: '/uploads/attachment/file/1/rails_helper.rb')
  end
end
