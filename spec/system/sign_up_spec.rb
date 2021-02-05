require 'rails_helper'

RSpec.feature "Sign Up", type: :system do
  let(:user) { FactoryBot.build(:user) }

  scenario "sign up page have right title" do
    visit new_user_registration_path
    expect(page).to have_title "sign up - 相席app"
  end

  scenario "user sign up successfully" do
    visit root_path
    expect(page).to have_content "サインアップ"
    click_link "サインアップ"
    expect(page).to have_current_path(new_user_registration_path)
    expect {
      fill_in id: "user_name", with: user.name
      fill_in id: "user_email", with: user.email
      fill_in id: "user_password", with: user.password
      fill_in id: "user_password_confirmation", with: user.password
      click_button "Sign up"
      expect(page).to have_current_path(root_path)
    }.to change(User, :count).by(1)
    expect(page).to have_content "ログアウト"
    # expect(page).to_not have_content "サインアップ"
    # expect(page).to_not have_content "サインイン"
  end

  scenario "user fail to sign up" do
    visit new_user_registration_path
    expect {
      fill_in id: "user_name", with: "  "
      fill_in id: "user_email", with: "  "
      fill_in id: "user_password", with: "   "
      fill_in id: "user_password_confirmation", with: "   "
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
