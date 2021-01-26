require 'rails_helper'

RSpec.describe "RoomPages", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:user1) { FactoryBot.create(:user) }
  let(:user2) { FactoryBot.create(:user) }
  let!(:user3) { FactoryBot.create(:user) }
  let!(:room) { FactoryBot.create(:room, user: user) }
  let(:other_room) { FactoryBot.create(:room) }

  before do
    room.members << [user1, user2]
  end

  scenario "room page has information" do
    visit root_path
    click_link "rooms"
    expect(page).to have_current_path(rooms_path)
    find("#room#{room.id}").click
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
end
