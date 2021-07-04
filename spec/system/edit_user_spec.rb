require "rails_helper"

RSpec.describe "Edit user", type: :system do
  let(:user) { create(:user) }
  let(:new_user) { build(:new_user) }

  before do
    ActionController::Base.allow_forgery_protection = true
  end

  after do
    ActionController::Base.allow_forgery_protection = false
  end

  scenario "page has correct title" do
    sign_in user
    visit "/#/users/edit"
    expect(page).to have_title "プロフィール編集 | 相席アプリ"
  end

  scenario "update user" do
    sign_in user
    visit "/#/users/edit"
    fill_in id: "name", with: new_user.name
    fill_in id: "email", with: new_user.email
    fill_in id: "password", with: new_user.password
    fill_in id: "password-confirmation", with: new_user.password
    fill_in id: "current-password", with: user.password
    click_button "編集"
    expect(page).to have_content "ユーザー情報を編集しました"
    # ユーザー情報が更新されているか？
    user.reload
    expect(user.name).to eq new_user.name
    expect(user.email).to eq new_user.email
    expect(user).to valid_password? new_user.password
    # 現在のページはユーザー個別ページか？
    expect(page).to have_title "#{user.name} | 相席アプリ"
  end

  scenario "update user with invalid params" do
    sign_in user
    # 古い情報を保存
    old_name = user.name
    old_email = user.email
    old_password = user.password
    visit "/#/users/edit"
    fill_in id: "name", with: ""
    fill_in id: "email", with: ""
    fill_in id: "password", with: "p"
    fill_in id: "password-confirmation", with: "p"
    fill_in id: "current-password", with: ""
    fill_in id: "name", with: " "
    # フロントのバリデーション
    expect(page).to have_content "名前を入力して下さい"
    expect(page).to have_content "メールアドレスを入力して下さい"
    expect(page).to have_content "パスワードは６文字以上にして下さい"
    expect(page).to have_content "パスワードを入力して下さい"
    click_button "編集"
    # エラーメッセージ
    expect(page).to have_content "名前が入力されていません。"
    expect(page).to have_content "メールアドレスが入力されていません。"
    expect(page).to have_content "現在のパスワードを入力してください"
    # ユーザー情報は変更されていないか？
    user.reload
    expect(user.name).to eq old_name
    expect(user.email).to eq old_email
    expect(user.password).to eq old_password
  end

  scenario "guest user access edit page" do
    visit "/#/users/edit"
    expect(page).to have_content "このページにアクセスするにはログインする必要があります"
    expect(page).to have_title "ログイン | 相席アプリ"
  end
end
