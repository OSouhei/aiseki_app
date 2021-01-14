require 'rails_helper'

RSpec.feature "Sign Up", type: :feature do
  let(:user) { FactoryBot.build(:user) }

  scenario "sign up page have right title" do
    visit new_user_registration_path
    expect(page).to have_title "sign up - 相席app"
  end

  scenario "user sign up successfully" do
    visit root_path
    expect(page).to have_content "ユーザー登録"
    click_link "ユーザー登録"
    expect(page).to have_current_path(new_user_registration_path)
    expect {
      fill_in "Name", with: user.name
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      fill_in "Password confirmation", with: user.password
      click_button "Sign up"
      expect(page).to have_current_path(root_path)
    }.to change(User, :count).by(1)
    expect(page).to have_content "ログアウト"
    expect(page).to_not have_content "ログイン"
    expect(page).to_not have_content "ユーザー登録"
  end

  scenario "user fail to sign up" do
    visit new_user_registration_path
    expect {
      fill_in "Name", with: "  "
      fill_in "Email", with: "  "
      fill_in "Password", with: "   "
      fill_in "Password confirmation", with: "   "
      click_button "Sign up"
      expect(page).to have_current_path "/users"
      # エラーメッセージ
      expect(page).to have_content "Email can't be blank"
      expect(page).to have_content "Password can't be blank"
      expect(page).to have_content "Name can't be blank"
    }.to_not change(User, :count)
  end

  scenario "user has already signed in" do
    sign_in user
    visit new_user_registration_path
    expect(page).to have_content "You are already signed in."
    expect(page).to have_current_path(root_path)
  end
end
