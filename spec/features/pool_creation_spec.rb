require 'rails_helper'

RSpec.feature "PoolCreation", type: :feature do
  let(:user) { create(:user) }

  scenario "User creates a new pool" do
    pool_name = Faker::Book.title

    login(user)

    visit new_pool_path

    fill_in "Name", with: pool_name
    fill_in "Price", with: 100
    check "Allow multiple entries"

    click_button "Create Pool"

    expect(page).to have_content("Pool was successfully created.")
    expect(page).to have_content(pool_name)
    expect(page).to have_content("100")
    expect(page).to have_content("Allow multiple entries: true")
  end

  scenario "User creates a new pool and a new group", js: true do
    pool_name = "#{Faker::Book.title}#{rand(100000)}"
    group_name = "#{Faker::Sports::Football.team}#{rand(100000)}"

    login(user)

    visit new_pool_path

    fill_in "Name", with: pool_name
    fill_in "Price", with: 150
    check "Allow multiple entries"

    # Select "New Group" from the dropdown
    select "New Group", from: "group-select"

    # Fill in the new group name
    fill_in "New Group Name", with: group_name

    click_button "Create Pool"

    expect(page).to have_content("Pool was successfully created.")
    expect(page).to have_content(pool_name)
    expect(page).to have_content("150")
    expect(page).to have_content("Allow multiple entries: true")

    expect(page).to have_content(group_name)
  end

  scenario "User creates a new pool and assigns an existing group" do
    pool_name = "#{Faker::Book.title}#{rand(100000)}"
    group = create(:group, user: user)

    login(user)

    visit new_pool_path

    fill_in "Name", with: pool_name
    fill_in "Price", with: 200
    check "Allow multiple entries"

    select group.name, from: "group-select"

    click_button "Create Pool"

    expect(page).to have_content("Pool was successfully created.")
    expect(page).to have_content(pool_name)
    expect(page).to have_content("200")
    expect(page).to have_content("Allow multiple entries: true")

    expect(page).to have_content(group.name)
  end
end
