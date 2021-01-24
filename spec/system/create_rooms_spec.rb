require 'rails_helper'

RSpec.describe "CreateRooms", type: :system do
  let(:user) { FactoryBot.create(:user) }

  scenario "user create rooms" do
    sign_in user
    visit root_path
    click_link "Create your Room"
    expect(page).to have_current_path(new_user_room_path(user))
    expect {
      fill_in "Shop name", with: "orion"
      fill_in "Conditions", with: "engineer only!"
      # 期日を指定
      within "#room_date_1i" do
        find("option[value='2021']").select_option
      end
      within "#room_date_2i" do
        find("option[value='12']").select_option
      end
      within "#room_date_3i" do
        find("option[value='31']").select_option
      end
      within "#room_date_4i" do
        find("option[value='23']").select_option
      end
      within "#room_date_5i" do
        find("option[value='30']").select_option
      end
      # 人数を指定
      within "#room_people_limit" do
        find("option[value='7']").select_option
      end
      click_button "Create Room"
    }.to change(Room, :count).by(1)
    expect(page).to have_current_path(user_room_path(user, Room.last))
    # flash
    expect(page).to have_content "room was successfully created."
  end

  scenario "unauthenticated user create room" do
    visit root_path
    expect(page).to_not have_link "Create your Room"
    visit new_user_room_path(user)
    expect(page).to have_current_path(new_user_session_path)
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"
    expect(page).to have_current_path(new_user_room_path(user))
  end
end
