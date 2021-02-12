require 'rails_helper'

RSpec.describe "notifications/index", type: :system do
  let(:user) { create(:user) }
  let(:user_room) { create(:room, owner: user) }

  scenario "has title" do
    sign_in user
    visit notifications_path
    expect(page).to have_current_path notifications_path
    expect(page).to have_title "Notifications - 相席app"
  end

  scenario "has UI" do
    notification = create(:notification, to: user.id, room_id: user_room.id)
    sign_in user
    visit notifications_path
    expect(page).to have_content "#{notification.notifyed_by.name}があなたの部屋に参加しました。"
    expect(notification.reload.checked).to be_truthy
  end
end
