# Preview all emails at http://localhost:3000/rails/mailers/authorization_mailer
class AuthorizationMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/authorization_mailer/confirmation
  def confirmation
    AuthorizationMailerMailer.confirmation
  end
end
