class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: I18n.t("users.account.email_subject")
  end

  def password_reset
    # Will be fill up in chapter 12
  end
end
