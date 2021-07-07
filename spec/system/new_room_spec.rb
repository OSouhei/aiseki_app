require "rails_helper"

RSpec.describe "Create room", type: :system do
  let(:user) { create(:user) }
  let(:room) { build(:room) }

  before do
    ActionController::Base.allow_forgery_protection = true
  end

  after do
    ActionController::Base.allow_forgery_protection = false
  end

  scenario "new room page has correct title" do
    sign_in user
    visit "/#/rooms/new"
    expect(page).to have_title "ルーム作成 | 相席アプリ"
  end

  scenario "create room" do
    sign_in user
    visit "/#/rooms/new"
    expect {
      fill_in id: "title", with: room.title
      fill_in id: "content", with: room.content
      fill_in id: "shop_name", with: room.shop_name
      fill_in id: "limit", with: room.limit
      click_button "ルーム作成"
      expect(page).to have_content "ルームを作成しました"
    }.to change(Room, :count).by(1)
    expect(page).to have_title "相席アプリ"
  end

  scenario "create room with invalid params" do
    sign_in user
    visit "/#/rooms/new"
    expect {
      fill_in id: "title", with: ""
      fill_in id: "shop_name", with: ""
      fill_in id: "limit", with: ""
      fill_in "title", with: ""
      # フロントのバリデーションルール
      expect(page).to have_content "ルーム名を入力して下さい"
      expect(page).to have_content "店名を入力して下さい"
      expect(page).to have_content "人数を入力して下さい"
      click_button "ルーム作成"
      # エラーメッセージ
      expect(page).to have_content "ルーム名を入力してください"
      expect(page).to have_content "店名を入力してください"
      expect(page).to have_content "人数を入力してください"
      expect(page).to have_content "人数は数値で入力してください"
    }.to_not change(Room, :count)
  end

  scenario "guest user can't access new room page" do
    visit "/#/rooms/new"
    expect(page).to have_title "ログイン | 相席アプリ"
    fill_in id: "email", with: user.email
    fill_in id: "password", with: user.password
    click_button id: "submit"
    expect(page).to have_title "相席アプリ" # 後でフレンドリーフォワーディングに。。。
  end
end
