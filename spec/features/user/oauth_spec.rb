require_relative '../feature_helper'

feature 'User sign in with Social Network tokens', '
  In order to be able sign in with Facebook/Twitter/Vkontakte account
  As an guest
  I want to be able to sign in without standart authentifacation with email
' do
  given(:user) { create(:user) }

  describe 'Sign in with Facebook' do
    given(:auth) { OmniAuth.config.mock_auth[:facebook] }
    given(:user_auth) { create(:user, email: auth.info.email) }

    scenario 'New user try sign in with Facebook first time' do
      visit new_user_session_path
      click_on 'Войти с помощью Facebook'
      
      expect(page).to have_content 'Вход в систему выполнен с учетной записью из facebook.'
      expect(page).to have_content auth.info.email
    end

    scenario 'Existing user try sign in with Facebook first time' do
      visit new_user_session_path
      click_on 'Войти с помощью Facebook'

      expect(page).to have_content 'Вход в систему выполнен с учетной записью из facebook.'
    end

    scenario 'Existing and confirmed authorized user try sign in with Facebook second time' do
      create(:authorization, user: user_auth, provider: auth.provider, uid: auth.uid, confirmed_at: Time.zone.now)

      puts User.all.inspect
      visit new_user_session_path
      click_on 'Войти с помощью Facebook'

      expect(page).to have_content 'Вход в систему выполнен с учетной записью из facebook.'
      expect(page).to have_content user_auth.email
    end
  end
end
