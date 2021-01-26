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

  describe "GET /rooms/:id" do
    it "responds successfully" do
      get room_path(room)
      expect(response).to have_http_status 200
    end

    it "render template rooms/show" do
      get room_path(room)
      expect(response).to render_template :show
    end

    context "when user is not found" do
      it "responds successfully" do
        get room_path(1000)
        expect(response).to have_http_status 302
      end

      it "redirect to home page" do
        get room_path(1000)
        expect(response).to redirect_to root_path
      end
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

    context "when user is not found" do
      before do
        sign_in user
        get new_user_room_path(user.id + 1000)
      end

      it "responds successfully" do
        expect(response).to have_http_status 302
      end

      it "redirect to home page" do
        expect(response).to redirect_to root_path
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
        expect(response).to redirect_to room_path(Room.last)
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

    context "when user is not found" do
      before do
        sign_in user
        post user_rooms_path(user.id + 1000), params: { room: room_params }
      end

      it "responds successfully" do
        expect(response).to have_http_status 302
      end

      it "redirect to home page" do
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "GET /rooms/:id/edit" do
    context "when authenticated user" do
      before do
        sign_in user
        get edit_room_path(room)
      end

      it "responds successfully" do
        expect(response).to have_http_status 200
      end

      it "render template rooms/edit" do
        expect(response).to render_template :edit
      end
    end

    context "when unauthenticated user" do
      before do
        sign_in other_user
        get edit_room_path(room)
      end

      it "responds successfully" do
        expect(response).to have_http_status 302
      end

      it "redirect to home page" do
        expect(response).to redirect_to root_path
      end
    end

    context "when guest" do
      before do
        get edit_room_path(room)
      end

      it "responds successfully" do
        expect(response).to have_http_status 302
      end

      it "redirect to login page" do
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "when room is not found" do
      before do
        sign_in user
        get edit_room_path(room.id + 1000)
      end

      it "responds successfully" do
        expect(response).to have_http_status 302
      end

      it "redirect to home page" do
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "PATCH /rooms/:id" do
    context "when authenticated user" do
      before do
        sign_in user
        patch room_path(room), params: { room: { conditions: "new conditions!" } }
      end

      it "responds successfully" do
        expect(response).to have_http_status 302
      end

      it "redirect to rooms/show" do
        expect(response).to redirect_to room_path(room)
      end

      it "update room attributes" do
        room.reload
        expect(room.conditions).to eq "new conditions!"
      end
    end

    context "when unauthenticated user" do
      before do
        sign_in other_user
        patch room_path(room), params: { room: { conditions: "new conditions!" } }
      end

      it "responds successfully" do
        expect(response).to have_http_status 302
      end

      it "redirect to home page" do
        expect(response).to redirect_to root_path
      end

      it "does not update room attributes" do
        room.reload
        expect(room.conditions).to eq "engineer only!"
      end
    end

    context "when guest" do
      before do
        patch room_path(room), params: { room: { conditions: "new conditions!" } }
      end

      it "responds successfully" do
        expect(response).to have_http_status 302
      end

      it "redirect to login page" do
        expect(response).to redirect_to new_user_session_path
      end

      it "does not update room attributes" do
        room.reload
        expect(room.conditions).to eq "engineer only!"
      end
    end

    context "when room is not found" do
      before do
        sign_in user
        patch room_path(room.id + 1000), params: { room: { conditions: "new conditions!" } }
      end

      it "responds successfully" do
        expect(response).to have_http_status 302
      end

      it "redirect to home page" do
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "DELETE /rooms/:id" do
    context "when authenticated user" do
      before do
        sign_in user
      end

      it "responds successfully" do
        delete room_path(room)
        expect(response).to have_http_status 302
      end

      it "redirect to home page" do
        delete room_path(room)
        expect(response).to redirect_to root_path
      end

      it "destroy room" do
        room
        expect {
          delete room_path(room)
        }.to change(Room, :count).by(-1)
      end
    end

    context "when unauthenticated user" do
      before do
        sign_in other_user
      end

      it "responds successfully" do
        delete room_path(room)
        expect(response).to have_http_status 302
      end

      it "redirect to home page" do
        delete room_path(room)
        expect(response).to redirect_to root_path
      end

      it "does not destroy room" do
        room
        expect {
          delete room_path(room)
        }.to_not change(Room, :count)
      end
    end

    context "when guest" do
      it "responds successfully" do
        delete room_path(room)
        expect(response).to have_http_status 302
      end

      it "redirect to login page" do
        delete room_path(room)
        expect(response).to redirect_to new_user_session_path
      end

      it "does not destroy room" do
        room
        expect {
          delete room_path(room)
        }.to_not change(Room, :count)
      end
    end

    context "when room is not found" do
      before do
        sign_in user
        delete room_path(room.id + 1000)
      end

      it "responds successfully" do
        expect(response).to have_http_status 302
      end

      it "redirect to home page" do
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "GET /rooms/:room_id/join" do
    context "when authenticated user" do
      before do
        sign_in other_user
      end

      it "responds successfully" do
        get room_join_path(room)
        expect(response).to have_http_status 302
      end

      it "redirect to home page" do
        get room_join_path(room)
        expect(response).to redirect_to root_path
      end

      it "create member" do
        expect {
          get room_join_path(room)
        }.to change(Member, :count).by(1)
      end

      it "room has members" do
        get room_join_path(room)
        expect(room.members).to include other_user
      end

      it "user join the room" do
        get room_join_path(room)
        expect(other_user.joining).to include room
      end
    end

    context "when room's owner" do
      before do
        sign_in user
      end

      it "responds successfully" do
        get room_join_path(room)
        expect(response).to have_http_status 302
      end

      it "redirect to home page" do
        get room_join_path(room)
        expect(response).to redirect_to root_path
      end

      it "does not create member" do
        expect {
          get room_join_path(room)
        }.to_not change(Member, :count)
      end

      it "room does not have members" do
        get room_join_path(room)
        expect(room.members).to_not include user
      end

      it "user does not join the room" do
        get room_join_path(room)
        expect(user.joining).to_not include room
      end
    end

    context "when guest" do
      it "responds successfully" do
        get room_join_path(room)
        expect(response).to have_http_status 302
      end

      it "redirect to log in page" do
        get room_join_path(room)
        expect(response).to redirect_to new_user_session_path
      end

      it "does not create member" do
        expect {
          get room_join_path(room)
        }.to_not change(Member, :count)
      end
    end

    context "when room is not found" do
      before do
        sign_in user
        get room_join_path(room.id + 1000)
      end

      it "responds successfully" do
        expect(response).to have_http_status 302
      end

      it "redirect to home page" do
        expect(response).to redirect_to root_path
      end
    end
  end
end
