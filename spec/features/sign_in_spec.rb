require 'rails_helper'

RSpec.feature "Sign In", type: :feature do
  let(:user) { FactoryBot.create(:user) }

  scenario "user sign in successfully" do
    visit root_path
    click_link "ログイン"
    expect(page).to have_current_path(new_user_session_path)
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"
    expect(page).to have_current_path(root_path)
  end

  scenario "user fail to sign in" do
    visit new_user_session_path
    fill_in "Email", with: "   "
    fill_in "Password", with: "   "
    click_button "Log in"
    expect(page).to have_current_path(user_session_path)
  end
end
