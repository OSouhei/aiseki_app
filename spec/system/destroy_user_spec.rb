require 'rails_helper'

RSpec.feature "DestroyUsers", type: :system do
  let(:user) { FactoryBot.create(:user) }

  scenario "user destroy his account", js: true do
    sign_in user
    visit edit_user_registration_path
    expect(page).to have_link "退会する"
    expect {
      page.accept_confirm do
        click_link "退会する"
      end
      expect(page).to have_current_path root_path
      expect(page).to have_content "アカウントが削除されました。またのご利用をお待ちしています。"
    }.to change(User, :count).by(-1)
  end
end
