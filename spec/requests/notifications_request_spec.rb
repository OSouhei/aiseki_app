# require 'rails_helper'

# RSpec.describe "Notifications", type: :request do
#   let(:user) { FactoryBot.create(:user) }
#   let(:other_user) { FactoryBot.create(:user) }
#   let(:room) { FactoryBot.create(:room, owner: user) }

#   # Notifications#index
#   describe "GET /notifications" do
#     context "when authenticated user" do
#       before do
#         sign_in user
#         get notifications_path
#       end

#       it "responds successfully" do
#         expect(response).to have_http_status 200
#       end

#       it "render template notifications/index" do
#         expect(response).to render_template :index
#       end

#       it "define @notifications correctly" do
#         other_user.join room # 部屋参加を伝える通知を作成
#         expect(assigns(:notifications)).to eq user.notifications
#       end
#     end

#     context "when guest" do
#       before do
#         get notifications_path
#       end

#       it "responds successfully" do
#         expect(response).to have_http_status 302
#       end

#       it "redirect to login page" do
#         expect(response).to redirect_to new_user_session_path
#       end
#     end
#   end
# end
