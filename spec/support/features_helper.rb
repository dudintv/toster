module FeaturesHelper
  def sign_up(user)
    visit new_user_registration_path
    fill_in 'Email', with: user.email
    fill_in 'Пароль', with: user.password
    fill_in 'Подтверждение пароля', with: user.password
    click_on 'Регистрация'
  end

  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Пароль', with: user.password
    click_on 'Войти'
  end
end
