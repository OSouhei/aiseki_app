require 'rails_helper'

RSpec.describe "Rooms", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:room) { FactoryBot.create(:room, user: user) }
  let(:room_params) do
    FactoryBot.attributes_for(:room).merge!({ "date(1i)": 2021, "date(2i)": 12, "date(3i)": 11, "date(4i)": 15, "date(5i)": 45 })
  end

  describe "GET /rooms" do
    before do
      get rooms_path
    end

    it "responds successfully" do
      expect(response).to have_http_status 200
    end

    it "render template rooms/index" do
      expect(response).to render_template :index
    end
  end

  describe "GET /users/:id/rooms/:id" do
    before do
      get user_room_path(user, room)
    end

    it "responds successfully" do
      expect(response).to have_http_status 200
    end

    it "render template rooms/show" do
      expect(response).to render_template :show
    end
  end

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

  describe "POST /users/:user_id/rooms" do
    context "when authenticated user" do
      before do
        sign_in user
      end

      it "responds successfully" do
        post user_rooms_path(user), params: { room: room_params }
        expect(response).to have_http_status 302
      end

      it "redirect to home page" do
        post user_rooms_path(user), params: { room: room_params }
        expect(response).to redirect_to root_path
      end

      it "create room" do
        expect {
          post user_rooms_path(user), params: { room: room_params }
        }.to change(Room, :count).by(1)
      end
    end

    context "when unauthenticated user" do
      before do
        sign_in other_user
      end

      it "responds successfully" do
        post user_rooms_path(user), params: { room: room_params }
        expect(response).to have_http_status 302
      end

      it "redirect to home page" do
        post user_rooms_path(user), params: { room: room_params }
        expect(response).to redirect_to root_path
      end

      it "does not create room" do
        expect {
          post user_rooms_path(user), params: { room: room_params }
        }.to_not change(Room, :count)
      end
    end

    context "when guest" do
      it "responds successfully" do
        post user_rooms_path(user), params: { room: room_params }
        expect(response).to have_http_status 302
      end

      it "redirect to login page" do
        post user_rooms_path(user), params: { room: room_params }
        expect(response).to redirect_to new_user_session_path
      end

      it "does not create room" do
        expect {
          post user_rooms_path(user), params: { room: room_params }
        }.to_not change(Room, :count)
      end
    end
  end
end
