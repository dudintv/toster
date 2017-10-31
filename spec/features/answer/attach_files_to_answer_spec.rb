require_relative '../feature_helper'

feature 'Attach files to Answer', '
  In order to clarify my answer
  As an authenticated user
  I want to be able to attach file to my answer
' do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:attachment) { create(:attachment, attachable: answer) }

  scenario 'Authenticated user creates answer with attach one file', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Ответ', with: 'Мой ответ с файлом'
    attach_file 'answer[attachments_attributes][0][file][]', "#{Rails.root}/README.md"
    click_on 'Создать Ответ'

    # очищается поле ввода файлов
    eventually do
      expect(page.find('#new-answer-form').find_field('answer[attachments_attributes][0][file][]').value).to eq ''
    end

    within('#answers') do
      expect(page).to have_link('README.md', href: '/uploads/attachment/file/2/README.md')
    end
  end

  scenario 'Authenticated user creates answer with attach mulyiple files', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Ответ', with: 'Мой ответ с файлом'
    attach_file 'answer[attachments_attributes][0][file][]', ["#{Rails.root}/README.md", "#{Rails.root}/config.ru"]
    click_on 'Создать Ответ'

    # очищается поле ввода файлов
    eventually do
      expect(page.find('#new-answer-form').find_field('answer[attachments_attributes][0][file][]').value).to eq ''
    end

    within('#answers') do
      expect(page).to have_link('README.md', href: '/uploads/attachment/file/2/README.md')
      expect(page).to have_link('config.ru', href: '/uploads/attachment/file/3/config.ru')
    end
  end

  scenario 'Author of answer deletes own attached file', js: true do
    sign_in(user)
    visit question_path(question)

    within("#attachment-#{attachment.id}") do
      click_on 'Удалить файл'
    end
    within("#answer-#{answer.id}") do
      expect(page).to have_no_link(attachment.file.filename, href: "/uploads/attachment/file/1/#{attachment.file.filename}")
    end
  end
end
