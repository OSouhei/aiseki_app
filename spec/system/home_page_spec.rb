require 'rails_helper'

RSpec.feature "Home", type: :system do
  scenario "Home page has correct title", js: true do
    visit "/"
    expect(page).to have_title "相席アプリ"
  end
end
