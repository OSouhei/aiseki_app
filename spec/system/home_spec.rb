require "rails_helper"

RSpec.describe "Home page", type: :system do
  before do
    ActionController::Base.allow_forgery_protection = true
  end

  after do
    ActionController::Base.allow_forgery_protection = false
  end

  scenario "has correct title", js: true do
    visit "/"
    expect(page).to have_title "相席アプリ"
  end
end
