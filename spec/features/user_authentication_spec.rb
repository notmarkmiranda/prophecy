require 'rails_helper'

RSpec.feature "UserAuthentication", type: :feature do
  scenario "User signs up or logs in with email and login code" do
    # Visit the authentication page
    visit user_authentication_path

    # Fill in the form with email
    fill_in "Email", with: "test@example.com"
    click_button "Submit"

    # Simulate the backend process of generating a login code
    user = User.find_by(email: "test@example.com")
    login_code = user.login_code

    # The user is automatically redirected to the login code verification page
    # Fill in the login code
    fill_in "Login code", with: login_code
    click_button "Verify"

    # Expect the user to be logged in successfully
    expect(page).to have_content("Welcome, test@example.com")
  end
end
