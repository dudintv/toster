require_relative '../feature_helper'

feature 'User sign in with Social Network tokens', '
  In order to be able sign in with Facebook/Twitter/Vkontakte account
  As an guest
  I want to be able to sign in without standart authentifacation with email
' do
  given(:user) { create(:user) }

  describe 'Sign in with Facebook' do
    given(:auth) { OmniAuth.config.mock_auth[:facebook] }

    scenario 'New user try sign in with Facebook first time' do
      visit new_user_session_path
      click_on 'Войти с помощью Facebook'
      expect(page).to have_content 'Вход в систему выполнен с учетной записью из Facebook.'
      expect(page).to have_content auth.info.email
    end

    scenario 'Existing user try sign in with Facebook first time' do
      user.update!(email: auth.info.email)
      visit new_user_session_path
      click_on 'Войти с помощью Facebook'

      expect(page).to have_content 'Вам надо подтвердить вашу учетную запись по ссылке в письме.'
    end

    scenario 'Existing and authorized user try sign in with Facebook second time' do
      user.update!(email: auth.info.email)
      create(:authorization, user: user, provider: auth.provider, uid: auth.uid)
      visit new_user_session_path
      click_on 'Войти с помощью Facebook'
      # expect(page).to have_content 'Вход в систему выполнен с учетной записью из Facebook.'
      # expect(page).to have_content user.email
    end
  end
end
