class MembershipMailer < ApplicationMailer
  def invitation_email
    @membership = params[:membership]
    @inviter = params[:inviter]
    @token = @membership.generate_token
    @url = verify_membership_url(token: @token)

    mail(
      to: @membership.user.email,
      subject: "You've been invited to join #{@membership.joinable.name}"
    )
  end
end
