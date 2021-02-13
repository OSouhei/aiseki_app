require 'rails_helper'

RSpec.feature "Sign Up", type: :system do
  let(:user) { FactoryBot.build(:user) }

  scenario "sign up page have right title" do
    visit new_user_registration_path
    expect(page).to have_title "sign up - 相席app"
  end

  scenario "user sign up" do
    visit new_user_registration_path
    expect(page).to have_current_path new_user_registration_path
    expect {
      fill_in id: "user_name", with: user.name
      fill_in id: "user_email", with: user.email
      fill_in id: "user_password", with: user.password
      fill_in id: "user_password_confirmation", with: user.password
      click_button "Sign up"
      expect(page).to have_current_path root_path
    }.to change(User, :count).by(1)
    # ログイン後のトップページのUI
    expect(page).to have_content "ログアウト"
    expect(page).to have_link href: notifications_path
    expect(page).to have_link href: bookmarks_path
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
      expect(page).to have_content "Emailを入力してください"
      expect(page).to have_content "Passwordを入力してください"
      expect(page).to have_content "Nameを入力してください"
    }.to_not change(User, :count)
  end

  scenario "user has already signed in" do
    sign_in user
    visit new_user_registration_path
    expect(page).to have_content "ログイン済みです。"
    expect(page).to have_current_path(root_path)
  end
end
