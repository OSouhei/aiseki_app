require 'rails_helper'

RSpec.describe "JoinRooms", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let!(:room) { FactoryBot.create(:room) }
  let(:full_room) { FactoryBot.create(:room, limit: 1) }

  xscenario "user join room" do
    sign_in user
    visit rooms_path
    expect(page).to have_current_path(rooms_path)
    # rooms/showリンクをクリック
    click_link "見る", href: room_path(room)
    expect(page).to have_current_path(room_path(room))
    expect {
      click_link "入室"
    }.to change(Member, :count).by(1)
    expect(user.joining).to include room
    expect(room.members).to include user
    # flash
    expect(page).to have_content "you joined the room."
  end

  xscenario "unauthenticated user does not join room" do
    visit root_path
    click_link "ルーム一覧"
    click_link "見る", href: room_path(room)
    expect(page).to have_current_path(room_path(room))
    expect {
      click_link "入室"
    }.to_not change(Member, :count)
    expect(page).to have_current_path(new_user_session_path)
    expect(page).to have_content "You need to sign in or sign up before continuing."
    expect {
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button "Log in"
    }.to change(Member, :count).by(1)
    expect(page).to have_content "you joined the room."
    expect(page).to have_current_path(root_path)
  end

  xscenario "room owner does not join his room" do
    owner = room.owner
    sign_in owner
    visit room_path(room)
    expect(page).to_not have_link "入室", href: join_room_path(room)
    expect {
      visit join_room_path(room)
    }.to_not change(Member, :count)
    expect(page).to have_content "you can not join the room because you are the room owner."
    expect(page).to have_current_path(root_path)
  end

  xscenario "join a packed room" do
    # full_roomを満員に
    FactoryBot.create(:user).join full_room
    sign_in user
    visit room_path(full_room)
    expect {
      click_link "入室", href: join_room_path(full_room)
    }.to_not change(Member, :count)
    expect(page).to have_current_path(root_path)
    expect(page).to have_content "this room is full."
  end
end
