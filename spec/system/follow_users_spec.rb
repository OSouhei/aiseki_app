require 'rails_helper'

RSpec.describe "FollowUsers", type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }

  scenario "user follow and unfollow other_user", js: true do
    sign_in user
    visit user_path(other_user)
    expect(page).to have_link "follow", href: follow_user_path(other_user)
    expect {
      click_link "follow"
      expect(page).to have_link "following", href: unfollow_user_path(other_user)
      expect(page).to_not have_link "follow", href: follow_user_path(other_user)
    }.to change(user.following, :count).by(1)
    expect {
      click_link "following", href: unfollow_user_path(other_user)
      expect(page).to_not have_link "following", href: unfollow_user_path(other_user)
      expect(page).to have_link "follow", href: follow_user_path(other_user)
    }.to change(user.following, :count).by(-1)
  end
end
