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
      
      expect(page).to have_content 'Успешно вошли на сайт через facebook'
      expect(page).to have_content auth.info.email
    end

    scenario 'Existing user try sign in with Facebook first time' do
      visit new_user_session_path
      click_on 'Войти с помощью Facebook'

      expect(page).to have_content 'Успешно вошли на сайт через facebook'
    end

    scenario 'Existing and confirmed authorized user try sign in with Facebook second time' do
      create(:authorization, user: user_auth, provider: auth.provider, uid: auth.uid, confirmed_at: Time.zone.now)

      puts User.all.inspect
      visit new_user_session_path
      click_on 'Войти с помощью Facebook'

      expect(page).to have_content 'Успешно вошли на сайт через facebook'
      expect(page).to have_content user_auth.email
    end
  end

  describe 'Sign in with Twitter (without email)' do
    given!(:auth) { OmniAuth.config.mock_auth[:twitter] }
    given(:email) { 'twitter@user.ru' }

    scenario 'New user try sign in with Twitter first time' do
      # pry
      visit new_user_session_path
      click_on 'Войти с помощью Twitter'
      
      expect(page).to have_content 'Успешная авторизация через twitter'
      expect(page).to have_content 'Чтобы авторизоваться через twitter укажите email'

      fill_in 'email', with: email
      click_on 'Сохранить'

      open_email(email)
      current_email.click_link 'Подтвердить мой аккаунт'

      expect(page).to have_content 'Успешно вошли на сайт через twitter'
      expect(page).to have_content email
    end
  end
end
