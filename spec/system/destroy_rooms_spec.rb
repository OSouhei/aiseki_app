require 'rails_helper'

RSpec.describe "DestroyRooms", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let!(:room) { FactoryBot.create(:room, user: user) }

  scenario "user destroy his room" do
    sign_in user
    visit user_path(user)
    expect(page).to have_current_path user_path(user)
    click_link "go this room", href: room_path(room)
    expect(page).to have_current_path room_path(room)
    expect(page).to have_content room.conditions
    expect(page).to have_content room.date
    expect(page).to have_content room.people_limit
    expect(page).to have_link "edit this room"
    expect(page).to have_link "destroy this room"
    expect {
      click_link "destroy this room"
    }.to change(Room, :count).by(-1)
  end

  scenario "unauthenticated user can not destroy his room" do
    sign_in other_user
    visit user_path(user)
    click_link "go this room", href: room_path(room)
    expect(page).to have_current_path room_path(room)
    expect(page).to_not have_link "edit this room"
    expect(page).to_not have_link "destroy this room"
  end
end
