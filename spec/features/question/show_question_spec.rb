require 'rails_helper'

feature 'Show question', '
  In order to get content of certain question
  As an guest or authenticated user
  I want to be able to see details and answers certain question
' do

  given(:user) { create(:user) }

  before do
    @question = create(:question)
    @question.answers = create_list(:answer, 2)
  end

  scenario 'Guest user can see list question' do
    visit questions_path
    click_on @question.title

    expect(page).to have_content @question.title
    expect(page).to have_content @question.body
    expect(page).to have_content @question.answers[0].body
    expect(page).to have_content @question.answers[1].body
  end

  scenario 'Authenticated user can see list question' do
    sign_in(user)

    visit questions_path
    click_on @question.title

    expect(page).to have_content @question.title
    expect(page).to have_content @question.body
    expect(page).to have_content @question.answers[0].body
    expect(page).to have_content @question.answers[1].body
  end
end
