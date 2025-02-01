require 'rails_helper'

RSpec.describe "Memberships", type: :request do
  let(:user) { create(:user) }
  let(:pool) { create(:pool, user: user) }

  describe "GET /pools/:id/memberships/new" do
    context "when logged in" do
      before { login(user) }

      it "returns a successful response" do
        get new_membership_path(pool)
        expect(response).to be_successful
      end
    end

    context "when not logged in" do
      it "redirects to login" do
        get new_membership_path(pool)
        expect(response).to redirect_to(user_authentication_path)
      end
    end
  end

  describe "POST /pools/:id/memberships" do
    context "when logged in" do
      before { login(user) }

      context "with valid parameters" do
        let(:valid_params) do
          {
            membership: {
              email: email
            }
          }
        end
        let(:email) { "new_member@example.com" }

        it "creates a new membership" do
          expect {
            post memberships_path(pool), params: valid_params
          }.to change(Membership, :count).by(1)
        end

        context do
          let(:email) { "new_member#{rand(1000)}@example.com" }
          it "creates a new user if they don't exist" do
            expect {
              post memberships_path(pool), params: valid_params
            }.to change(User, :count).by(1)
          end
        end

        context do
          let!(:new_user) { create(:user) }
          let(:email) { new_user.email }

          it "doesn't create a new user if they already exist" do
            expect {
              post memberships_path(pool), params: valid_params
            }.not_to change(User, :count)
          end
        end

        it "sets the correct role for the membership" do
          post memberships_path(pool), params: valid_params
          expect(Membership.last.role).to eq("participant")
        end
      end

      context "with invalid parameters" do
        let(:invalid_params) do
          {
            membership: {
              email: ""
            }
          }
        end

        it "returns unprocessable entity status" do
          post memberships_path(pool), params: invalid_params
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "doesn't create a membership" do
          expect {
            post memberships_path(pool), params: invalid_params
          }.not_to change(Membership, :count)
        end
      end
    end

    context "when not logged in" do
      it "redirects to login" do
        post memberships_path(pool), params: { membership: { email: "test@example.com" } }
        expect(response).to redirect_to(user_authentication_path)
      end
    end
  end

  describe "GET /verify-membership/:token" do
    let(:membership) { create(:membership, status: :inactive) }
    let(:token) { membership.generate_token }

    context "with a valid token" do
      it "activates the membership" do
        get verify_membership_path(token: token)
        expect(membership.reload.status).to eq("active")
      end

      it "redirects to dashboard with success message" do
        get verify_membership_path(token: token)
        expect(response).to redirect_to(dashboard_path)
        expect(flash[:notice]).to eq("Membership successfully verified!")
      end
    end

    context "with an invalid token" do
      it "redirects to root with error message" do
        get verify_membership_path(token: "invalid_token")
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Invalid or expired verification link.")
      end
    end

    context "with an expired token" do
      let(:token) { membership.generate_token(1.minute.ago) }

      it "redirects to root with error message" do
        get verify_membership_path(token: token)
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Invalid or expired verification link.")
      end
    end
  end
end
