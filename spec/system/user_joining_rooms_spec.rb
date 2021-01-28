require 'rails_helper'

RSpec.describe "UserJoiningRooms", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:room1) { FactoryBot.create(:room) }
  let(:room2) { FactoryBot.create(:room) }

  before do
    driven_by(:rack_test)
  end

  scenario "pagehas title" do
    sign_in user
    visit joining_user_path(user)
    expect(page).to have_title "joining rooms - 相席app"
  end

  scenario "page has rooms information the user is joining" do
    sign_in user
    user.join(room1)
    visit root_path
    click_link "joining rooms"
    expect(page).to have_current_path(joining_user_path(user))
    # 参加した部屋のリンクのみをもつ
    expect(page).to have_link href: room_path(room1)
    expect(page).to_not have_link href: room_path(room2)
  end

  scenario "unauthenticated user access joining page" do
    sign_in other_user
    visit joining_user_path(user)
    expect(page).to have_current_path(root_path)
    expect(page).to have_content "you can not access this page."
  end

  scenario "guest user access joining page" do
    visit joining_user_path(user)
    expect(page).to have_current_path(new_user_session_path)
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"
    expect(page).to have_current_path(joining_user_path(user))
  end

  scenario "user is not found" do
    sign_in user
    visit joining_user_path(user.id + 1000)
    expect(page).to have_current_path(root_path)
    expect(page).to have_content "user is not found."
  end
end
