require 'rails_helper'

RSpec.describe "RoomPages", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:user1) { FactoryBot.create(:user) }
  let(:user2) { FactoryBot.create(:user) }
  let!(:user3) { FactoryBot.create(:user) }
  let!(:room) { FactoryBot.create(:room, owner: user) }
  let(:other_room) { FactoryBot.create(:room) }

  before do
    room.members << [user1, user2]
  end

  scenario "room page has information" do
    visit root_path
    click_link "rooms"
    expect(page).to have_current_path(rooms_path)
    click_link "go this room", href: room_path(room)
    expect(page).to have_current_path(room_path(room))
    expect(page).to have_link href: user_path(user1)
    expect(page).to have_link href: user_path(user2)
    expect(page).to_not have_link href: user_path(user3)
    expect(page).to_not have_content "No members."
  end

  scenario "room has no members" do
    visit room_path(other_room)
    expect(page).to have_content "No members."
  end

  scenario "room is not found by parameters" do
    # 存在しない部屋にアクセス
    visit room_path(room.id + 1000)
    expect(page).to have_current_path root_path
    expect(page).to have_content "room was not found."
  end

  scenario "room page does not have join link when room's owner is current_user" do
    sign_in user
    visit room_path(room)
    expect(page).to have_current_path(room_path(room))
    expect(page).to_not have_link "join this room!", href: join_room_path(room)
  end
end
