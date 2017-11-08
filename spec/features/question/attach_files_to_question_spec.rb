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
    attach_file 'question[attachments_attributes][0][file][]', "#{Rails.root}/README.md"
    click_on 'Создать Вопрос'

    expect(page).to have_link('README.md', href: /\/uploads\/attachment\/file\/\d*\/README\.md/)
  end

  scenario 'Authenticated user creates question with multiply attach files', js: true do
    sign_in(user)

    visit questions_path
    click_on 'Новый вопрос'
    fill_in 'Вопрос', with: 'Сам вопрос'
    fill_in 'Подробности', with: 'Подробности'
    attach_file 'question[attachments_attributes][0][file][]', ["#{Rails.root}/README.md", "#{Rails.root}/config.ru"]
    click_on 'Создать Вопрос'

    expect(page).to have_link('README.md', href: /\/uploads\/attachment\/file\/\d*\/README\.md/)
    expect(page).to have_link('config.ru', href: /\/uploads\/attachment\/file\/\d*\/config.ru/)
  end

  scenario 'Author of question edit question and attach one more file', js: true do
    sign_in(user)
    visit question_path(question)

    within('#question-block') do
      click_on 'Редактировать вопрос'
      attach_file 'question[attachments_attributes][0][file][]', "#{Rails.root}/README.md"
      click_on 'Сохранить Вопрос'

      # Старый файл остался, и добавился новый
      expect(page).to have_link(attachment.file.filename, href: /\/uploads\/attachment\/file\/\d*\/#{attachment.file.filename}/)
      expect(page).to have_link('README.md', href: /\/uploads\/attachment\/file\/\d*\/README\.md/)
    end
  end

  scenario 'Author of question deletes own attached file', js: true do
    sign_in(user)
    visit question_path(question)

    within("#attachment-#{attachment.id}") do
      click_on 'Удалить файл'
    end
    within('#question-block') do
      expect(page).to have_no_link(attachment.file.filename, href: /\/uploads\/attachment\/file\/\d*\/#{attachment.file.filename}/)
    end
  end
end
