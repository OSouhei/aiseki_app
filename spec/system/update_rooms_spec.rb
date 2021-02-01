require 'rails_helper'

RSpec.describe "UpdateRooms", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let!(:room) { FactoryBot.create(:room, owner: user) }

  it "update room" do
    sign_in user
    visit root_path
    click_link "プロフィール"
    click_link "見る", href: room_path(room)
    expect(page).to have_current_path(room_path(room))
    click_link "edit this room"
    expect(page).to have_current_path(edit_room_path(room))
    # フォームには元の値が入力されている
    expect(page).to have_css("input#room_shop_name[value=#{room.shop_name}]")
    fill_in "Content", with: "Anyone!"
    click_button "Submit"
    expect(page).to have_current_path(room_path(room))
    expect(page).to have_content "Anyone!"
    expect(room.reload.content).to eq "Anyone!"
  end
end
