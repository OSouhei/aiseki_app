require "rails_helper"

RSpec.describe "Room page", type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:room) { create(:room, owner: user) }

  before do
    ActionController::Base.allow_forgery_protection = true
  end

  after do
    ActionController::Base.allow_forgery_protection = false
  end

  scenario "room page has correct title" do
    visit "/#/rooms/#{room.id}"
    expect(page).to have_title "#{room.title} | 相席アプリ"
  end

  scenario "room page has room's infomation" do
    visit "/#/rooms/#{room.id}"
    # ページがルームの情報をもっているか？
    aggregate_failures do
      expect(page).to have_content room.title
      expect(page).to have_content room.content
      expect(page).to have_link room.shop_name, href: room.shop_url
      expect(page).to have_content room.limit
      expect(page).to have_link room.owner.name
    end
  end

  scenario "access room page that does not exist" do
    visit "/#/rooms/3"
    expect(page).to have_content "ルームを見つけることができませんでした"
    expect(page).to have_title "相席アプリ"
  end

  scenario "room page has edit and destroy link" do
    visit "/#/rooms/#{room.id}"
    # ログイン中のユーザーがいない時、リンクが表示されないか？
    aggregate_failures do
      expect(page).to_not have_link "編集"
      expect(page).to_not have_button "削除"
    end
    # 他のユーザーがログインしている時、リンクが表示されないか？
    sign_in other_user
    visit "/#/rooms/#{room.id}"
    aggregate_failures do
      expect(page).to_not have_link "編集"
      expect(page).to_not have_button "削除"
    end
    # 作成者がログインしている時、リンクが表示されるか？
    sign_out other_user
    sign_in user
    visit "/#/rooms/#{room.id}"
    aggregate_failures do
      expect(page).to have_link "編集"
      expect(page).to have_button "削除"
    end
  end
end
