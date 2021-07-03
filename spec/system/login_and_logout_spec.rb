require "rails_helper"

RSpec.describe "Log in and log out", type: :system do
  let(:user) { create(:user) }

  before do
    ActionController::Base.allow_forgery_protection = true
  end

  after do
    ActionController::Base.allow_forgery_protection = false
  end

  scenario "log in page has correct title" do
    visit "/#/log_in"
    expect(page).to have_title "ログイン | 相席アプリ"
  end

  scenario "log in and log out" do
    visit "/#/log_in"
    fill_in id: "email", with: user.email
    fill_in id: "password", with: user.password
    click_button id: "submit"
    expect(page).to have_content "ログインしました"
    # ユーザーがログインしているか？
    expect(page).to have_button "アカウント情報"
    expect(page).to have_button "ログアウト"
    expect(page).to_not have_button "ログイン"
    expect(page).to_not have_button "アカウント登録"
    # ユーザーがログインしているか？（API問い合わせ）
    visit "/api/login_user"
    expect(page).to have_content user.name
    expect(page).to have_content user.email
    visit "/"
    expect(page).to have_button "ログアウト"
    click_button "ログアウト"
    expect(page).to have_content "ログアウトしました"
    # ユーザーがログアウトしたか？
    expect(page).to have_button "ログイン"
    expect(page).to have_button "新規登録"
    expect(page).to_not have_button "アカウント情報"
    expect(page).to_not have_button "ログアウト"
    # ユーザーがログアウトしているか？（API問い合わせ）
    visit "/api/login_user"
    expect(page).to_not have_content user.name
    expect(page).to_not have_content user.email
  end

  scenario "log in with invalid params" do
    visit "/#/log_in"
    fill_in id: "email", with: ""
    fill_in id: "password", with: ""
    fill_in id: "email", with: ""
    # フロントのバリデーションメッセージ
    expect(page).to have_content "メールアドレスを入力して下さい"
    expect(page).to have_content "パスワードを入力して下さい"
    click_button id: "submit"
    expect(page).to have_content "ログインに失敗しました。メールアドレス、パスワードが正しいか確認して下さい"
  end
end
