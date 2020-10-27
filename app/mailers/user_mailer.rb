class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.code_confirmation.subject
  #
  def code_confirmation
    mail(to: "cotiravanal@gmail.com", subject: "Verification Code")
  end
end
