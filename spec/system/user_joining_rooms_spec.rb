require 'rails_helper'

RSpec.describe "UserJoiningRooms", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:room) { create(:room) }

  before do
    driven_by(:rack_test)
  end

  scenario "has title" do
    sign_in user
    visit joining_user_path(user)
    expect(page).to have_title "joining rooms - 相席app"
  end

  scenario "page has UI", js: true do
    user.join room
    sign_in user
    visit root_path
    click_button id: "dropdownMenuButton"
    click_link "参加中のルーム"
    expect(page).to have_current_path joining_user_path(user)
    expect(page).to have_link "見る", href: room_path(room)
    expect(page).to have_content room.title
    expect(page).to have_content room.shop_name
  end
end
