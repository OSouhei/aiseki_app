require "rails_helper"

RSpec.describe "User page", type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  before do
    ActionController::Base.allow_forgery_protection = true
  end

  after do
    ActionController::Base.allow_forgery_protection = false
  end

  scenario "user page has correct title" do
    visit "/#/users/#{user.id}"
    expect(page).to have_title "#{user.name} | 相席アプリ"
    # 他のユーザーページへ遷移したときにタイトルは切り替わるか？
    visit "/#/users/#{other_user.id}"
    expect(page).to have_title "#{other_user.name} | 相席アプリ"
  end

  scenario "user page has user information" do
    visit "/#/users/#{user.id}"
    expect(page).to have_content user.name
    expect(page).to have_content user.email
    # ユーザー編集ページ・退会へのリンクがないか？
    expect(page).to_not have_link "編集"
    expect(page).to_not have_button "退会"
    # ログイン中のユーザーならば、編集ページ・退会へのリンクが表示されるか？
    sign_in user
    visit "/#/users/#{user.id}"
    expect(page).to have_link "編集"
    expect(page).to have_button "退会"
    # 他のユーザーならば、編集ページ・退会へのリンクは表示されないか？
    visit "/#/users/#{other_user.id}"
    expect(page).to_not have_link "編集"
    expect(page).to_not have_button "退会"
  end

  scenario "when user is not found" do
    visit "/#/users/3"
    expect(page).to have_content "ユーザーを見つけることができませんでした"
  end
end
