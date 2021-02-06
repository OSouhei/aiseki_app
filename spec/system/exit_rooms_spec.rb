require 'rails_helper'

RSpec.describe "ExitRooms", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:room) { FactoryBot.create(:room) }

  before do
    driven_by(:rack_test)
  end

  scenario "user exit a joining room" do
    user.join(room)
    expect(room.members).to include user
    sign_in user
    visit room_path(room)
    expect(page).to have_link "exit this room!", href: exit_room_path(room)
    expect {
      click_link "exit this room!", href: exit_room_path(room)
    }.to change(Member, :count).by(-1)
    expect(page).to have_current_path(room_path(room))
    expect(page).to have_content "you exited the room."
    expect(room.members).to_not include user
  end

  scenario "unauthenticated user exit room" do
    user.join(room)
    sign_in other_user
    visit room_path(room)
    expect(page).to_not have_link "exit this room!", href: exit_room_path(room)
    expect {
      visit exit_room_path(room)
    }.to_not change(Member, :count)
    expect(page).to_not have_content "you exited the room."
    expect(page).to have_content "you are not member of this room."
  end
end
