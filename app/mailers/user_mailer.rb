class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.code_confirmation.subject
  #
  def code_confirmation(current_user, new_confirmation_code)
    @current_user = current_user
    @verification_code = new_confirmation_code
    mail(to: current_user.email, subject: "Verification Code")
  end
end
