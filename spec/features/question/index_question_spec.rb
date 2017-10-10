require 'rails_helper'

feature 'Index question', %q{
  In order to get list of questions
  As an guest or authenticated user
  I want to be able to see all questions
} do

  given(:user) { create(:user) }

  before do
    @questions = create_list(:question, 2)
  end

  scenario 'Guest user can see list question' do
    visit questions_path

    expect(page).to have_content @questions[0].title
    expect(page).to have_content @questions[1].title
  end

  scenario 'Authenticated user can see list question' do
    sign_in(user)
    visit questions_path

    expect(page).to have_content @questions[0].title
    expect(page).to have_content @questions[1].title
  end
end
