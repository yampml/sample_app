class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t(".acc_active_email_subject")
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: t(".pwd_reset_email_subject")
  end
end
