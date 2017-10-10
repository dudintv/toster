require 'rails_helper'

feature 'User sign out', %q{
  In order to be able close session
  As an authenticated User
  I want to be able to sign out
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user sign out' do
    sign_in(user)

    click_on 'Выйти'

    expect(page).to have_content 'Выход из системы выполнен.'
  end
end