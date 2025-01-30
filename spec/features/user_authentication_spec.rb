require 'rails_helper'

RSpec.feature "UserAuthentication", type: :feature do
  scenario "User signs up with email and login code" do
    visit user_authentication_path
    email = Faker::Internet.email
    fill_in "Email", with: email
    click_button "Submit"

    user = User.find_by(email: email)
    login_code = user.login_code

    fill_in "Login code", with: login_code
    click_button "Verify"

    expect(page).to have_content("Welcome, #{email}")
  end
end
