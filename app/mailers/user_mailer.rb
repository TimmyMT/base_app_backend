class UserMailer < ApplicationMailer
  default from: "rt_union@group.com"

  def send_confirm_mail(user)
    @user = user
    mail(to: "#{user.email}", subject: "Confirm account")
  end
end
