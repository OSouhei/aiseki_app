require 'rails_helper'

RSpec.feature "Sign In", type: :system do
  let(:user) { FactoryBot.create(:user) }

  scenario "sign in page have right title" do
    visit new_user_session_path
    expect(page).to have_title "Login - 相席app"
  end

  xscenario "user sign in and sign out successfully" do
    visit root_path
    click_link "サインイン"
    expect(page).to have_current_path(new_user_session_path)
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"
    expect(page).to have_current_path(root_path)
    expect(page).to have_content "Signed in successfully."
    expect(page).to_not have_content "ログイン"
    expect(page).to_not have_content "ユーザー登録"
    expect(page).to have_content "ログアウト"
    click_link "ログアウト"
    expect(page).to have_current_path(root_path)
    expect(page).to have_content "Signed out successfully."
    expect(page).to have_content "ユーザー登録"
    expect(page).to have_content "ログイン"
    expect(page).to_not have_content "ログアウト"
  end

  scenario "user fail to sign in" do
    visit new_user_session_path
    fill_in "Email", with: "   "
    fill_in "Password", with: "   "
    click_button "Log in"
    expect(page).to have_current_path(user_session_path)
  end

  scenario "user has already signed in" do
    sign_in user
    visit new_user_session_path
    expect(page).to have_current_path(root_path)
    expect(page).to have_content "You are already signed in."
  end
end
