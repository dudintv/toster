require_relative '../feature_helper'

feature 'Attach files to Question', '
  In order to clarify my question
  As an authenticated user and author question
  I want to be able to attach file to my question
' do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:attachment) { create(:attachment, attachable: question) }

  scenario 'Authenticated user creates question with one attach file', js: true do
    sign_in(user)

    visit questions_path
    click_on 'Новый вопрос'
    fill_in 'Вопрос', with: 'Сам вопрос'
    fill_in 'Подробности', with: 'Подробности'
    attach_file 'question[attachments_attributes][0][file][]', "#{Rails.root}/spec/rails_helper.rb"
    click_on 'Создать Вопрос'

    expect(page).to have_link('rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb')
  end

  scenario 'Authenticated user creates question with multiply attach files', js: true do
    sign_in(user)

    visit questions_path
    click_on 'Новый вопрос'
    fill_in 'Вопрос', with: 'Сам вопрос'
    fill_in 'Подробности', with: 'Подробности'
    attach_file 'question[attachments_attributes][0][file][]', ["#{Rails.root}/README.md", "#{Rails.root}/config.ru"]
    click_on 'Создать Вопрос'

    expect(page).to have_link('README.md', href: '/uploads/attachment/file/2/README.md')
    expect(page).to have_link('config.ru', href: '/uploads/attachment/file/3/config.ru')
  end

  scenario 'Author of question deletes own attached file', js: true do
    sign_in(user)
    visit question_path(question)

    within("#attachment-#{attachment.id}") do
      click_on 'Удалить файл'
    end
    within('#question-block') do
      expect(page).to have_no_link(attachment.file.filename, href: "/uploads/attachment/file/1/#{attachment.file.filename}")
    end
  end
end
