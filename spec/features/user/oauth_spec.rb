require_relative '../feature_helper'

feature 'User sign in with Social Network tokens', '
  In order to be able sign in with Facebook/Twitter/Vkontakte account
  As an guest
  I want to be able to sign in without standart authentifacation with email
' do
  let(:user) { create(:user) }

  describe 'User sign in with Facebook' do
    scenario 'New user try sign in by Facebook first time' do
      visit new_user_session_path
      expect(page).to have_link 'Войти с помощью: Facebook'
    end
  end
end
