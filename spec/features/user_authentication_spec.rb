require 'rails_helper'

RSpec.feature "UserAuthentication", type: :feature do
  scenario "User signs up with email and login code" do
    visit user_authentication_path
    fill_in "Email", with: "test@example.com"
    click_button "Submit"

    user = User.find_by(email: "test@example.com")
    login_code = user.login_code

    fill_in "Login code", with: login_code
    click_button "Verify"

    expect(page).to have_content("Welcome, test@example.com")
  end
end
