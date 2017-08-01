class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: I18n.t("users.account.email_subject")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: I18n.t("users.password.email_subject")
  end
end
