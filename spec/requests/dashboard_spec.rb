require 'rails_helper'

RSpec.describe "Dashboards", type: :request do
  include Devise::Test::IntegrationHelpers

  describe "GET /index" do
    it "returns http success" do
      user = FactoryBot.create(:user)
      puts "User created: #{user.inspect}"
      sign_in user

      get "/dashboard/index"
      expect(response).to have_http_status(:success)
    end
  end
end
