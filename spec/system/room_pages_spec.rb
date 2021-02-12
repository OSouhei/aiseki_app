require 'rails_helper'

RSpec.describe "RoomPages", type: :system do
  let(:room) { create(:room) }

  scenario "page has title" do
    visit room_path(room)
    expect(page).to have_current_path room_path(room)
    expect(page).to have_title "#{room.title} - 相席app"
  end

  scenario "page has UI", js: true do
    3.times { create(:user).join room }
    3.times { create(:user).book room }
    visit room_path(room)
    expect(page).to have_content room.title
    expect(page).to have_content room.content
    expect(page).to have_content room.limit
    expect(page).to have_content room.shop_name
    expect(page).to have_link href: join_room_path(room)
    room.members.each do |member|
      expect(page).to have_link href: user_path(member)
      expect(page).to have_content member.name
    end
    click_link "ブックマーク"
    room.booked_by.each do |user|
      expect(page).to have_link href: user_path(user)
      expect(page).to have_content user.name
    end
  end
end
