require 'rails_helper'

RSpec.feature "UsersShows", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }

  scenario "has page title" do
    sign_in user
    visit root_path
    click_link "プロフィール"
    expect(page).to have_title "#{user.name} - 相席app"
  end

  scenario "has interface" do
    sign_in user
    visit root_path
    click_link "プロフィール"
    expect(page).to have_current_path(user_path(user))
    expect(page).to have_content user.name
    expect(page).to have_content user.email
    expect(page).to have_link "edit your profile"
  end

  scenario "does not have link to edit user page" do
    sign_in other_user
    visit user_path(user)
    expect(page).to_not have_link "edit your profile"
  end

  scenario "has user's rooms content" do
    10.times do |n|
      FactoryBot.create(:room, content: "this is user's room#{n}", user: user)
      FactoryBot.create(:room, content: "this is other_user's room#{n}", user: other_user)
    end
    sign_in user
    visit root_path
    click_link "プロフィール"
    # ユーザーの部屋の情報を持っている
    user.rooms.each do |room|
      expect(page).to have_content room.content
    end
    # 他ユーザーの部屋の情報は持たない
    other_user.rooms.each do |room|
      expect(page).to_not have_content room.content
    end
  end

  scenario "user is not found" do
    sign_in user
    visit user_path(user.id + 1000)
    expect(page).to have_current_path(root_path)
    expect(page).to have_content "user is not found."
  end
end
