require 'rails_helper'

RSpec.feature "DestroyUsers", type: :system do
  let(:user) { FactoryBot.create(:user) }

  scenario "user destroy his account" do
    sign_in user
    visit root_path
    expect {
      click_link "退会"
    }.to change(User, :count).by(-1)
    expect(page).to have_current_path(root_path)
    expect(page).to have_content "Bye! Your account has been successfully cancelled. We hope to see you again soon."
  end
end
