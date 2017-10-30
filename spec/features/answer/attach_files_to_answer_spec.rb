require_relative '../feature_helper'

feature 'Attach files to Answer', '
  In order to clarify my answer
  As an authenticated user
  I want to be able to attach file to my answer
' do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user creates question with attach file', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Ответ', with: 'Мой ответ с файлом'
    attach_file 'answer[attachments_attributes][0][file]', "#{Rails.root}/spec/rails_helper.rb"
    click_on 'Создать Ответ'

    eventually do
      expect(page.find('#new-answer-form').find_field('answer[attachments_attributes][0][file]').value).to eq ''
    end

    within('#answers') do
      expect(page).to have_link('rails_helper.rb', href: '/uploads/attachment/file/1/rails_helper.rb')
    end
  end
end
