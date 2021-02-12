require 'rails_helper'

RSpec.describe "Update Room", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:room) { FactoryBot.create(:room, owner: user) }

  scenario "page have title" do
    sign_in user
    visit edit_room_path(room)
    expect(page).to have_current_path edit_room_path(room)
    expect(page).to have_title "edit room - 相席app"
  end

  scenario "user update room" do
    sign_in user
    visit edit_room_path(room)
    fill_in "タイトル", with: "テストルーム"
    fill_in "メッセージ", with: "メッセージを編集しました。"
    fill_in "お店の名前", with: "餃子の王将"
    within "#room_limit" do
      find("option[value='2']").select_option
    end
    click_button "送信"
    room.reload
    expect(room.title).to eq "テストルーム"
    expect(room.content).to eq "メッセージを編集しました。"
    expect(room.shop_name).to eq "餃子の王将"
    expect(room.limit).to eq 2
  end

  scenario "user update room with invalid params" do
    sign_in user
    visit edit_room_path(room)
    # タイトルを空にして送信
    fill_in "タイトル", with: "   "
    click_button "送信"
    expect(page).to have_content "Title can't be blank"
    old_title = room.title
    room.reload
    expect(room.title).to eq old_title
  end
end
