require 'rails_helper'

RSpec.feature "Update Users", type: :system do
  let(:user) { FactoryBot.create(:user) }

  scenario "has title" do
    sign_in user
    visit edit_user_registration_path
    expect(page).to have_title "Edit User - 相席app"
  end

  scenario "user edit profile" do
    sign_in user
    visit edit_user_registration_path
    expect(page).to have_current_path(edit_user_registration_path)
    expect(user.profile_image.url).to be_nil
    fill_in "お名前", with: "New User"
    fill_in "メールアドレス", with: "new@example.com"
    fill_in "現在のパスワード", with: user.password
    attach_file "プロフィール画像", Rails.root.join("spec/files/test_image.jpg")
    click_button "更新"
    expect(page).to have_current_path(user_path(user))
    expect(page).to have_content "アカウントが更新されました。"
    # プロフィールが更新されているか
    user.reload
    expect(user.name).to eq "New User"
    expect(user.email).to eq "new@example.com"
    expect(user.profile_image.url).to eq "/uploads/test/user/profile_image/#{user.id}/test_image.jpg"
    expect(page).to have_css "img[src='/uploads/test/user/profile_image/#{user.id}/test_image.jpg']"
  end

  scenario "user edit profile with invalid params" do
    sign_in user
    visit edit_user_registration_path
    fill_in "お名前", with: "   "
    fill_in "メールアドレス", with: "   "
    fill_in "現在のパスワード", with: "   "
    click_button "更新"
    expect(page).to have_content "Nameを入力してください"
    expect(page).to have_content "Emailを入力してください"
    expect(page).to have_content "Current passwordを入力してください"
  end
end
