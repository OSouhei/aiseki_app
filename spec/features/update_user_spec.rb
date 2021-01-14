require 'rails_helper'

RSpec.feature "Update Users", type: :feature do
  let(:user) { FactoryBot.create(:user) }

  context "when user logged in" do
    before do
      sign_in user
      visit root_path
      click_link "プロフィール編集"
    end

    it "has right title" do
      expect(page).to have_title "Edit User - 相席app"
    end

    it "user edit profile" do
      expect(page).to have_current_path(edit_user_registration_path)
      fill_in "Name", with: "New User"
      fill_in "Email", with: "new@example.com"
      fill_in "Current password", with: user.password
      click_button "Update"
      expect(page).to have_current_path(root_path)
      # プロフィールが更新されているか
      user.reload
      expect(user.name).to eq "New User"
      expect(user.email).to eq "new@example.com"
    end
  end

  context "when user does not logged in" do
    it "redirect sign in page" do
      visit edit_user_registration_path
      expect(page).to have_current_path(new_user_session_path)
      # サインインページにリダイレクト
      expect(page).to have_content "You need to sign in or sign up before continuing."
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button "Log in"
      # フレンドリーフォワーディング
      expect(page).to have_current_path(edit_user_registration_path)
    end
  end
end