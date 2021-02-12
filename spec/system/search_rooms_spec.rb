require 'rails_helper'

RSpec.describe "SearchRooms", type: :system do
  let!(:room1) { FactoryBot.create(:room) }
  let!(:room2) { FactoryBot.create(:room) }
  let!(:room3) { FactoryBot.create(:room, content: "foobar") }

  scenario "user search rooms with term" do
    visit rooms_path
    fill_in "ルーム検索", with: "foobar"
    click_button "検索"
    expect(page).to_not have_link "見る", href: room_path(room1)
    expect(page).to_not have_link "見る", href: room_path(room2)
    expect(page).to have_link "見る", href: room_path(room3)
  end

  scenario "user search rooms with blank term" do
    visit rooms_path
    fill_in "ルーム検索", with: "   "
    click_button "検索"
    # 何も入力せずに検索した場合は全ルームが表示される
    expect(page).to have_link "見る", href: room_path(room1)
    expect(page).to have_link "見る", href: room_path(room2)
    expect(page).to have_link "見る", href: room_path(room3)
  end
end
