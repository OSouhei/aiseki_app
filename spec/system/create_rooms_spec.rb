require 'rails_helper'

RSpec.describe "Create Rooms", type: :system do
  let(:user) { FactoryBot.create(:user) }

  scenario "page has title" do
    sign_in user
    visit new_room_path
    expect(page).to have_title "new room - 相席app"
  end

  scenario "user create rooms" do
    sign_in user
    visit new_room_path
    expect(page).to have_current_path(new_room_path)
    expect {
      fill_in "タイトル", with: "Test Room"
      fill_in "メッセージ", with: "This is test room."
      fill_in "お店の名前", with: "orion"
      # 人数を指定
      within "#room_limit" do
        find("option[value='3']").select_option
      end
      click_button "送信"
    }.to change(Room, :count).by(1)
    expect(page).to have_current_path(room_path(Room.last))
    # flash
    expect(page).to have_content "room was successfully created."
  end

  scenario "user create rooms with invlid params" do
    sign_in user
    visit new_room_path
    expect {
      fill_in "タイトル", with: ""
      fill_in "メッセージ", with: ""
      click_button "送信"
    }.to_not change(Room, :count)
    # エラーメッセージ
    expect(page).to have_content "Title can't be blank"
    expect(page).to have_content "Limit is not a number"
  end
end
