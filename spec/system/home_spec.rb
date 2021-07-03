require "rails_helper"

RSpec.describe "Home page", type: :system do
  scenario "has correct title", js: true do
    visit "/"
    expect(page).to have_title "相席アプリ"
  end
end
