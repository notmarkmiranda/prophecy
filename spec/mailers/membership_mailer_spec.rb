require "rails_helper"

RSpec.describe MembershipMailer, type: :mailer do
  describe "#invitation_email" do
    let(:membership) { create(:membership) }
    let(:inviter) { create(:user) }
    let(:mail) { described_class.with(membership: membership, inviter: inviter).invitation_email }
    let(:token) { membership.generate_token }

    before do
      allow_any_instance_of(Membership).to receive(:generate_token).and_return(token)
    end

    it "renders the headers" do
      expect(mail.subject).to eq("You've been invited to join #{membership.joinable.name}")
      expect(mail.to).to eq([ membership.user.email ])
    end

    it "includes the inviter's email in the body" do
      expect(mail.body.encoded).to include(inviter.email)
    end

    it "includes the verification link with the token in the path" do
      expect(mail.body.encoded).to include("/verify-membership/#{token}")
    end
  end
end
