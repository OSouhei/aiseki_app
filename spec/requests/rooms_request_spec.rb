require 'rails_helper'

RSpec.describe "Rooms", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }

  describe "GET /users/:user_id/rooms/new" do
    context "when authenticated user" do
      before do
        sign_in user
        get new_user_room_path(user)
      end

      it "responds successfully" do
        expect(response).to have_http_status 200
      end

      it "render templete rooms/new" do
        expect(response).to render_template :new
      end
    end

    context "when unauthenticated user" do
      before do
        sign_in user
        get new_user_room_path(other_user)
      end

      it "responds successfully" do
        expect(response).to have_http_status 302
      end

      it "render redirect to home-page" do
        expect(response).to redirect_to root_path
      end
    end

    context "when guest" do
      before do
        get new_user_room_path(other_user)
      end

      it "responds successfully" do
        expect(response).to have_http_status 302
      end

      it "redirect to login page" do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
