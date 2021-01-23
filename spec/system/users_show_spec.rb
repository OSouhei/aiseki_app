require 'rails_helper'

RSpec.feature "UsersShows", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }

  it "has page title" do
    sign_in user
    visit root_path
    click_link "プロフィール"
    expect(page).to have_title "#{user.name} - 相席app"
  end

  it "has interface" do
    sign_in user
    visit root_path
    click_link "プロフィール"
    expect(page).to have_current_path(user_path(user))
    expect(page).to have_content user.name
    expect(page).to have_content user.email
    expect(page).to have_link "edit your profile"
  end

  it "does not have link to edit user page" do
    sign_in other_user
    visit user_path(user)
    expect(page).to_not have_link "edit your profile"
  end
end
