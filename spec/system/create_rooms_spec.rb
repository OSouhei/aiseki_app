require 'rails_helper'

RSpec.describe "CreateRooms", type: :system do
  let(:user) { FactoryBot.create(:user) }

  scenario "user create rooms" do
    sign_in user
    visit root_path
    click_link "Create your Room"
    expect(page).to have_current_path(new_room_path)
    expect {
      fill_in "Title", with: "Test Room"
      fill_in "Content", with: "This is test room."
      fill_in "Shop name", with: "orion"
      # 人数を指定
      within "#room_limit" do
        find("option[value='3']").select_option
      end
      click_button "Submit"
    }.to change(Room, :count).by(1)
    expect(page).to have_current_path(room_path(Room.last))
    # flash
    expect(page).to have_content "room was successfully created."
  end

  scenario "unauthenticated user create room" do
    visit root_path
    expect(page).to_not have_link "Create your Room"
    visit new_room_path
    expect(page).to have_current_path(new_user_session_path)
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"
    expect(page).to have_current_path(new_room_path)
  end
end
