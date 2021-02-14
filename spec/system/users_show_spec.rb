require 'rails_helper'

RSpec.feature "users/show", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:john) { create(:user) }

  scenario "has page title" do
    sign_in user
    visit root_path
    click_link href: user_path(user), match: :first
    expect(page).to have_title "#{user.name} - 相席app"
    expect(page).to have_current_path user_path(user)
  end

  scenario "has UI", js: true do
    create_list(:room, 3, owner: user)
    user.follow other_user
    user.follow john
    sign_in user
    visit user_path(user)
    rooms = user.rooms
    rooms.each do |room|
      # ユーザーのルームの情報を持っているか
      expect(page).to have_content room.title
      expect(page).to have_content room.content
      expect(page).to have_content room.shop_name
      expect(page).to have_link "見る", href: room_path(room)
      expect(page).to have_link "入室", href: join_room_path(room)
      expect(page).to have_content room.members.count
      expect(page).to have_content room.booked.count
      expect(page).to have_link "編集", href: edit_room_path(room)
    end
    click_link "following"
    following_users = user.following
    following_users.each do |following|
      # フォロー中のユーザーの情報を持っているか
      expect(page).to have_content following.name
      expect(page).to have_link href: user_path(following)
    end
  end

  scenario "does not have link to edit user page" do
    sign_in other_user
    visit user_path(user)
    expect(page).to_not have_link "編集", href: edit_user_registration_path(user)
  end
end
