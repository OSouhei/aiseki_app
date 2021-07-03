require "rails_helper"

RSpec.describe "Home page", type: :system do
  it "has correct title", js: true do
    visit "/"
    expect(page).to have_title "相席アプリ"
  end
end
