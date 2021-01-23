require 'rails_helper'

RSpec.feature "HomePage", type: :system do
  scenario "home page has right title" do
    visit root_path
    expect(page).to have_title "相席app"
  end
end
