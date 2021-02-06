require 'rails_helper'

RSpec.describe "Notifications", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:user1) { FactoryBot.create(:user) }
  let!(:user2) { FactoryBot.create(:user) }
  let(:room) { FactoryBot.create(:room, owner: user) }

  before do
    driven_by(:rack_test)
  end

  scenario "the page has notifications" do
    user1.join room
    sign_in user
    visit notifications_path
    expect(page).to have_current_path notifications_path
    expect(page).to have_link(user1.name, href: user_path(user1))
    expect(page).to_not have_link href: user_path(user2)
  end

  scenario "guest access notificatons page" do
    visit notifications_path
    expect(page).to have_current_path(new_user_session_path)
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"
    expect(page).to have_current_path(notifications_path)
  end
end
