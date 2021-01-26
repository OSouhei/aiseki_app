require 'rails_helper'

RSpec.describe "JoinRooms", type: :system do
  let(:user) { FactoryBot.create(:user) }

  before do
    @room = FactoryBot.create(:room)
  end

  scenario "user join room" do
    sign_in user
    visit root_path
    click_link "rooms"
    expect(page).to have_current_path(rooms_path)
    # rooms/showリンクをクリック
    find("#room#{@room.id}").click
    expect(page).to have_current_path(room_path(@room))
    expect {
      click_link "join this room!"
    }.to change(Member, :count).by(1)
    expect(user.joining).to include @room
    expect(@room.members).to include user
    # flash
    expect(page).to have_content "you joined the room."
  end

  scenario "unauthenticated user does not join room" do
    visit root_path
    click_link "rooms"
    find("#room#{@room.id}").click
    expect(page).to have_current_path(room_path(@room))
    expect {
      click_link "join this room!"
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

  scenario "room owner does not join his room" do
    owner = @room.user
    sign_in owner
    visit room_path(@room)
    expect {
      click_link "join this room!"
    }.to_not change(Member, :count)
    expect(page).to have_content "you can not join the room because you are the room owner."
    expect(page).to have_current_path(root_path)
  end
end
