require_relative '../feature_helper'

feature 'Best answer', '
  In order to mark the best answer
  As an authenticated user and author of question
  I want to be able to choose best answer
' do

  given!(:user) { create(:user) }
  given!(:foreign_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  before do
    @answers = create_list(:answer, 2, question: question)
  end

  scenario 'Author of question choose best answer', js: true do
    sign_in(user)
    visit question_path(question)

    expect(page).to_not have_content 'Лучший ответ'

    within "#answer-#{@answers[1].id}" do
      click_on 'Выбрать ответ как лучший'
      expect(page).to have_content 'Лучший ответ'
    end

    within "#answer-#{@answers[0].id}" do
      expect(page).to_not have_content 'Лучший ответ'
    end
  end

  scenario 'Author of question re-choose another best answer', js: true do
    sign_in(user)
    visit question_path(question)
    within "#answer-#{@answers[1].id}" do
      click_on 'Выбрать ответ как лучший'
      expect(page).to have_content 'Лучший ответ'
    end

    within "#answer-#{@answers[0].id}" do
      expect(page).to_not have_content 'Лучший ответ'
      click_on 'Выбрать ответ как лучший'
      expect(page).to have_content 'Лучший ответ'
    end

    within "#answer-#{@answers[1].id}" do
      expect(page).to_not have_content 'Лучший ответ'
    end
  end

  scenario 'Best answer is always on top', js: true do
    sign_in(user)
    visit question_path(question)

    # Вначале, верхний — это первый ответ
    within '#answers' do
      expect(page.first('div')[:id]).to eq "answer-#{@answers[0].id}"
    end

    within "#answer-#{@answers[1].id}" do
      click_on 'Выбрать ответ как лучший'
      wait_for_ajax
    end

    # Теперь сверху должен оказаться второй ответ, потому что Лучший
    within '#answers' do
      expect(page.first('div')[:id]).to eq "answer-#{@answers[1].id}"
    end

    within "#answer-#{@answers[0].id}" do
      click_on 'Выбрать ответ как лучший'
      wait_for_ajax
    end

    within '#answers' do
      expect(page.first('div')[:id]).to eq "answer-#{@answers[0].id}"
    end

    # Добавим новый ответ и проверим порядок
    fill_in 'Ответ', with: 'Мой ответ'
    click_on 'Создать Ответ'
    visit question_path(question)
    wait_for_ajax

    within '#answers' do
      expect(page.first('div')[:id]).to eq "answer-#{@answers[0].id}"
    end
  end

  scenario 'Authenticating user as non-author can not see link' do
    sign_in(foreign_user)
    visit question_path(question)

    expect(page).to_not have_link 'Выбрать ответ как лучший'
  end

  scenario 'Guest can not see link' do
    visit question_path(question)

    expect(page).to_not have_link 'Выбрать ответ как лучший'
  end
end
