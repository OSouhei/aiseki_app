require 'rails_helper'

RSpec.feature "Sign In", type: :system do
  let(:user) { FactoryBot.create(:user) }

  scenario "sign in page have right title" do
    visit new_user_session_path
    expect(page).to have_title "Login - 相席app"
    expect(page).to have_current_path new_user_session_path
  end

  scenario "user sign in and sign out" do
    visit new_user_session_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログイン"
    expect(page).to have_current_path root_path
    expect(page).to have_content "ログインしました。"
    # ログアウト
    expect(page).to have_link "ログアウト"
    click_link "ログアウト"
    expect(page).to have_current_path root_path
    expect(page).to have_content "ログアウトしました。"
    expect(page).to have_link "サインアップ"
    expect(page).to have_link "サインイン"
  end

  scenario "user fill in form wrong params" do
    visit new_user_session_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: "foo"
    click_button "ログイン"
    expect(page).to have_current_path new_user_session_path
    expect(page).to have_content "メールアドレスまたはパスワードが違います。"
  end

  scenario "authenticated user sign in" do
    sign_in user
    visit new_user_session_path
    expect(page).to have_current_path root_path
    expect(page).to have_content "ログイン済みです。"
  end
end
