class UserMailer < ApplicationMailer
  def login_code_email(user)
    @user = user
    mail(
      to: @user.email,
      subject: "Your Login Code",
      from: "login-code@superduper.bet"
    )
  end
end
