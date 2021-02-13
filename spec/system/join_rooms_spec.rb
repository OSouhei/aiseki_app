require 'rails_helper'

RSpec.describe "JoinRooms", type: :system do
  let(:user) { create(:user) }
  let(:room) { create(:room) }
  let(:user_room) { create(:room, owner: user) }

  scenario "user join and exit room" do
    sign_in user
    visit room_path(room)
    expect(page).to have_link href: join_room_path(room)
    expect {
      click_link href: join_room_path(room)
    }.to change(Member, :count).by(1)
    expect(page).to have_current_path joining_user_path(user)
    expect(page).to have_content "ルームに参加しました！"
    click_link "見る", href: room_path(room)
    expect(page).to_not have_link href: join_room_path(room)
    expect(page).to have_link href: exit_room_path(room)
    expect {
      click_link href: exit_room_path(room)
    }.to change(Member, :count).by(-1)
    expect(page).to have_current_path room_path(room)
    expect(page).to have_content "ルームを退出しました。"
  end

  scenario "user join full room" do
    room.update(limit: 0) # 部屋を満員に
    sign_in user
    visit room_path(room)
    expect {
      click_link href: join_room_path(room)
    }.to_not change(Member, :count)
    expect(page).to have_current_path root_path
    expect(page).to have_content "この部屋は満員です。"
  end

  scenario "user join his room" do
    sign_in user
    visit room_path(user_room)
    expect(page).to have_current_path room_path(user_room)
    expect(page).to_not have_link href: join_room_path(user_room)
  end
end
