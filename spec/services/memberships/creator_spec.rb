require 'rails_helper'

RSpec.describe Memberships::Creator do
  let!(:pool) { create(:pool) }
  let(:email) { "user_#{SecureRandom.hex(8)}@example.com" }

  subject(:service) { described_class.new(email: email, memberable: pool) }

  describe "#call" do
    context "with valid parameters" do
      it "creates a new membership" do
        expect { service.call }.to change(Membership, :count).by(1)
      end

      it "creates a new user if they don't exist" do
        expect { service.call }.to change(User, :count).by(1)
      end

      it "returns a successful result" do
        result = service.call
        expect(result).to be_success
        expect(result.errors).to be_empty
      end

      it "sets the correct role" do
        result = service.call
        expect(result.membership.role).to eq("participant")
      end

      context "when user already exists" do
        let!(:existing_user) { create(:user, email: email) }

        it "doesn't create a new user" do
          expect { service.call }.not_to change(User, :count)
        end

        it "creates a membership with the existing user" do
          result = service.call
          expect(result.membership.user).to eq(existing_user)
        end
      end
    end

    context "with invalid parameters" do
      context "with blank email" do
        let(:email) { "" }

        it "doesn't create a membership" do
          expect { service.call }.not_to change(Membership, :count)
        end

        it "returns an unsuccessful result with errors" do
          result = service.call
          expect(result).not_to be_success
          expect(result).to be_failure
          expect(result.errors).to include("Email can't be blank")
        end
      end

      context "with invalid email format" do
        let(:email) { "not-an-email" }

        it "returns an unsuccessful result with errors" do
          result = service.call
          expect(result).not_to be_success
          expect(result.errors).to include("Invalid email format")
        end
      end

      context "when membership is invalid" do
        before do
          allow_any_instance_of(Membership).to receive(:save).and_return(false)
          allow_any_instance_of(Membership).to receive(:errors).and_return(
            double(any?: true, full_messages: [ "Some membership error" ])
          )
        end

        it "returns an unsuccessful result with errors" do
          result = service.call
          expect(result).not_to be_success
          expect(result.errors).to include("Some membership error")
        end
      end
    end

    context "with custom role" do
      subject(:service) { described_class.new(email: email, memberable: pool, role: :admin) }

      it "creates a membership with the specified role" do
        result = service.call
        expect(result.membership.role).to eq("admin")
      end
    end
  end
end
