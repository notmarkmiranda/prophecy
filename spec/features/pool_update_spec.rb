require 'rails_helper'

RSpec.feature "PoolUpdate", type: :feature do
  let(:user) { create(:user) }

  scenario "User updates an existing pool" do
    pool = create(:pool, user: user)
    new_name = "#{Faker::Book.title}#{rand(10000)}"

    login(user)

    visit edit_pool_path(pool)

    fill_in "Name", with: new_name
    fill_in "Price", with: 150
    check "Allow multiple entries"

    click_button "Update Pool"

    expect(page).to have_content("Pool was successfully updated.")
    expect(page).to have_content(new_name)
    expect(page).to have_content("150")
    expect(page).to have_content("Allow multiple entries: true")
  end

  scenario "User updates a pool to a new group", js: true do
    pool = create(:pool, user: user)
    new_group_name = "#{Faker::Team.name}#{rand(10000)}"

    login(user)

    visit edit_pool_path(pool)

    select "New Group", from: "group-select"

    fill_in "New Group Name", with: new_group_name

    click_button "Update Pool"

    expect(page).to have_content("Pool was successfully updated.")
    expect(page).to have_content(new_group_name)
  end

  scenario "User updates a pool to an existing group" do
    pool = create(:pool, user: user)
    existing_group = create(:group, user: user)

    login(user)

    visit edit_pool_path(pool)

    select existing_group.name, from: "group-select"

    click_button "Update Pool"

    expect(page).to have_content("Pool was successfully updated.")
    expect(page).to have_content(existing_group.name)
  end
end
