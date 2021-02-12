require 'rails_helper'

RSpec.describe "DestroyRooms", type: :system do
  let(:user) { create(:user) }
  let(:user_room) { create(:room, owner: user) }

  scenario "user destroy his room", js: true do
    sign_in user
    visit room_path(user_room)
    expect(page).to have_current_path room_path(user_room)
    expect(page).to have_link href: room_path(user_room)
    expect {
      page.accept_confirm do
        click_link href: room_path(user_room)
      end
      expect(page).to have_content "ルームは削除されました。"
    }.to change(Room, :count).by(-1)
  end

  scenario "user destroy other user's room" do
    sign_in user
    room = create(:room)
    visit room_path(room)
    # 削除リンクを持っていない
    expect(page).to_not have_link room_path(room)
  end
end
