require 'rails_helper'

RSpec.feature "EntryCreation", type: :feature do
  let(:user) { create(:user) }
  let(:pool) { create(:pool) }
  let!(:question) { create(:question, pool: pool) }
  let!(:options) { create_list(:option, 4, question: question) }

  before do
    login(user)
  end

  scenario "User creates an entry for a pool" do
    visit pool_path(pool)

    expect(page).to have_content(pool.name)
    expect(page).to have_content(question.text)

    click_link "Create Entry"

    expect(page).to have_content("Create Entry for #{pool.name}")

    if pool.price > 0
      expect(page).to have_content("Entry fee: $#{pool.price}")
    end

    click_button "Create Entry"

    expect(page).to have_content("Entry was successfully created.")
    expect(current_path).to eq(pool_path(pool))
  end

  scenario "User cannot create an entry for a locked pool" do
    pool.update!(locked_at: 1.day.ago)

    visit pool_path(pool)

    expect(page).not_to have_link("Create Entry")
  end

  scenario "User cannot create an entry for a completed pool" do
    pool.update!(completed_at: 1.day.ago)

    visit pool_path(pool)

    expect(page).not_to have_link("Create Entry")
  end

  scenario "User cannot create an entry for a pool without questions" do
    empty_pool = create(:pool)

    visit pool_path(empty_pool)

    expect(page).not_to have_link("Create Entry")
  end

  scenario "User cannot create multiple entries unless allowed" do
    pool.update!(allow_multiple_entries: false)
    create(:entry, user: user, pool: pool)

    visit pool_path(pool)
    click_link "Create Entry"

    click_button "Create Entry"

    expect(page).to have_content("User can only have one entry per pool")
    expect(current_path).to eq(pool_entries_path(pool))
  end

  scenario "User can create multiple entries when allowed" do
    pool.update!(allow_multiple_entries: true)
    create(:entry, user: user, pool: pool)

    visit pool_path(pool)
    click_link "Create Entry"

    click_button "Create Entry"

    expect(page).to have_content("Entry was successfully created.")
    expect(current_path).to eq(pool_path(pool))
  end
end
