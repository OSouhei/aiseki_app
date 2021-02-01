require 'rails_helper'

RSpec.describe "SearchRooms", type: :system do
  let!(:room1) { FactoryBot.create(:room) }
  let!(:room2) { FactoryBot.create(:room) }
  let!(:room3) { FactoryBot.create(:room, content: "foobar") }

  xit "has title" do
    visit root_path
    find("#search_rooms").fill_in with: ""
    click_button "search"
    expect(page).to have_title "rooms-search - 相席app"
  end

  xit "search rooms" do
    visit root_path
    find("#search_rooms").fill_in with: "This"
    click_button "search"
    expect(page).to have_current_path(search_rooms_path, ignore_query: true)
    expect(page).to have_link href: room_path(room1)
    expect(page).to have_link href: room_path(room2)
    expect(page).to_not have_link href: room_path(room3)
  end
end
