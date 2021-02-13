require 'rails_helper'

RSpec.describe "Rooms", type: :request do
  let(:user) { create(:user) }
  let(:room) { create(:room, owner: user) }

  # Rooms#index
  describe "GET /rooms" do
    let!(:room1) { create(:room) }
    let!(:room2) { create(:room) }

    before do
      get rooms_path
    end

    it "responds successfully" do
      expect(response).to have_http_status 200
    end

    it "render template rooms/index" do
      expect(response).to render_template :index
    end

    it "define @rooms" do
      aggregate_failures do
        variable = controller.instance_variable_get("@rooms")
        expect(variable).to include room1
        expect(variable).to include room2
      end
    end

    it "@rooms length is at most 9" do
      create_list(:room, 10)
      get rooms_path
      variable = controller.instance_variable_get("@rooms")
      expect(variable.length).to eq 9
    end
  end

  # Rooms#show
  describe "GET /rooms/:id" do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let(:room) { create(:room) }

    it "responds successfully" do
      get room_path(room)
      expect(response).to have_http_status 200
    end

    it "render template rooms/show" do
      get room_path(room)
      expect(response).to render_template :show
    end

    it "define @room" do
      get room_path(room)
      variable = controller.instance_variable_get("@room")
      expect(variable).to eq room
    end

    it "define @members" do
      user1.join room
      user2
      get room_path(room)
      variable = controller.instance_variable_get("@members")
      aggregate_failures do
        expect(variable).to include user1
        expect(variable).to_not include user2
      end
    end

    context "when room is not found" do
      before do
        get room_path(1000)
      end

      it "responds successfully" do
        expect(response).to have_http_status 302
      end

      it "redirect to home page" do
        expect(response).to redirect_to root_path
      end

      it "define @room as nil" do
        variable = controller.instance_variable_get("@room")
        expect(variable).to be_nil
      end

      it "define flash" do
        expect(flash[:alert]).to eq "ルームを見つけることができませんでした。"
      end
    end
  end

  # Rooms#new
  describe "GET /rooms/new" do
    context "when authenticated user" do
      before do
        sign_in user
        get new_room_path
      end

      it "responds successfully" do
        expect(response).to have_http_status 200
      end

      it "render templete rooms/new" do
        expect(response).to render_template :new
      end
    end

    context "when guest" do
      before do
        get new_room_path
      end

      it "responds successfully" do
        expect(response).to have_http_status 302
      end

      it "redirect to login page" do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  # Rooms#create
  describe "POST /rooms" do
    let(:room_params) { attributes_for(:room) }
    let(:invalid_room_params) { attributes_for(:room, title: "   ") }

    context "when authenticated user" do
      before do
        sign_in user
      end

      context "with valid room_params" do
        it "responds successfully" do
          post rooms_path, params: { room: room_params }
          expect(response).to have_http_status 302
        end

        it "redirect to home page" do
          post rooms_path, params: { room: room_params }
          expect(response).to redirect_to room_path(Room.last)
        end

        it "create room" do
          expect {
            post rooms_path, params: { room: room_params }
          }.to change(Room, :count).by(1)
        end

        it "define @room" do
          post rooms_path, params: { room: room_params }
          variable = controller.instance_variable_get("@room")
          expect(variable).to be_present
        end

        it "define flash" do
          post rooms_path, params: { room: room_params }
          expect(flash[:notice]).to eq "ルームを作成しました。"
        end
      end

      context "with invalid room_params" do
        it "responds successfully" do
          post rooms_path, params: { room: invalid_room_params }
          expect(response).to have_http_status 200
        end

        it "render template :new" do
          post rooms_path, params: { room: invalid_room_params }
          expect(response).to render_template :new
        end

        it "render partial users/shared/error_messages" do
          post rooms_path, params: { room: invalid_room_params }
          expect(response).to render_template partial: "rooms/shared/_error_messages"
        end

        it "does not create room" do
          expect {
            post rooms_path, params: { room: invalid_room_params }
          }.to_not change(Room, :count)
        end

        it "define @room" do
          post rooms_path, params: { room: invalid_room_params }
          variable = controller.instance_variable_get("@room")
          variable.valid?
          expect(variable.errors[:title]).to include "を入力してください"
        end
      end
    end

    context "when guest" do
      it "responds successfully" do
        post rooms_path, params: { room: room_params }
        expect(response).to have_http_status 302
      end

      it "redirect to login page" do
        post rooms_path, params: { room: room_params }
        expect(response).to redirect_to new_user_session_path
      end

      it "does not create room" do
        expect {
          post rooms_path(user), params: { room: room_params }
        }.to_not change(Room, :count)
      end
    end
  end

  # Rooms#edit
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

      it "define @room" do
        variable = controller.instance_variable_get("@room")
        expect(variable).to eq room
      end
    end

    context "when unauthenticated user" do
      let(:other_user) { create(:user) }

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

      it "define flash" do
        expect(flash[:alert]).to eq "このページにはアクセスできません。"
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
        get edit_room_path(1000)
      end

      it "responds successfully" do
        expect(response).to have_http_status 302
      end

      it "redirect to home page" do
        expect(response).to redirect_to root_path
      end

      it "define @room as nil" do
        variable = controller.instance_variable_get("@room")
        expect(variable).to be_nil
      end

      it "define flash" do
        expect(flash[:alert]).to eq "ルームを見つけることができませんでした。"
      end
    end
  end

  # Rooms#update
  describe "PATCH /rooms/:id" do
    context "when authenticated user" do
      before do
        sign_in user
        patch room_path(room), params: { room: { content: "new content!" } }
      end

      it "responds successfully" do
        expect(response).to have_http_status 302
      end

      it "redirect to rooms/show" do
        expect(response).to redirect_to room_path(room)
      end

      it "update room attributes" do
        room.reload
        expect(room.content).to eq "new content!"
      end

      it "define @room" do
        variable = controller.instance_variable_get("@room")
        expect(variable).to eq room
      end

      it "define flash" do
        expect(flash[:notice]).to eq "ルームを編集しました！"
      end
    end

    context "when unauthenticated user" do
      let(:other_user) { create(:user) }

      before do
        sign_in other_user
        patch room_path(room), params: { room: { content: "new content!" } }
      end

      it "responds successfully" do
        expect(response).to have_http_status 302
      end

      it "redirect to home page" do
        expect(response).to redirect_to root_path
      end

      it "does not update room attributes" do
        room.reload
        expect(room.content).to eq "This is test room."
      end

      it "difine flash" do
        expect(flash[:alert]).to eq "このページにはアクセスできません。"
      end
    end

    context "when guest" do
      before do
        patch room_path(room), params: { room: { content: "new content!" } }
      end

      it "responds successfully" do
        expect(response).to have_http_status 302
      end

      it "redirect to login page" do
        expect(response).to redirect_to new_user_session_path
      end

      it "does not update room attributes" do
        room.reload
        expect(room.content).to eq "This is test room."
      end
    end

    context "when room is not found" do
      before do
        sign_in user
        patch room_path(1000), params: { room: { content: "new content!" } }
      end

      it "responds successfully" do
        expect(response).to have_http_status 302
      end

      it "redirect to home page" do
        expect(response).to redirect_to root_path
      end

      it "define @room as nil" do
        variable = controller.instance_variable_get("@room")
        expect(variable).to be_nil
      end
    end
  end

  # Rooms#destroy
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

      it "define @room" do
        delete room_path(room)
        variable = controller.instance_variable_get("@room")
        expect(variable).to eq room
      end

      it "define flash" do
        delete room_path(room)
        expect(flash[:notice]).to eq "ルームは削除されました。"
      end
    end

    context "when unauthenticated user" do
      let(:other_user) { create(:user) }

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

      it "define flash" do
        delete room_path(room)
        expect(flash[:alert]).to eq "このページにはアクセスできません。"
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
        delete room_path(1000)
      end

      it "responds successfully" do
        expect(response).to have_http_status 302
      end

      it "redirect to home page" do
        expect(response).to redirect_to root_path
      end

      it "define room as nil" do
        variable = controller.instance_variable_get("@room")
        expect(variable).to be_nil
      end

      it "define flash" do
        expect(flash[:alert]).to eq "ルームを見つけることができませんでした。"
      end
    end
  end

  # Rooms#join
  describe "GET /rooms/:room_id/join" do
    context "when authenticated user" do
      let(:other_user) { create(:user) }

      before do
        sign_in other_user
      end

      it "responds successfully" do
        get join_room_path(room)
        expect(response).to have_http_status 302
      end

      it "redirect to home page" do
        get join_room_path(room)
        expect(response).to redirect_to joining_user_path(other_user)
      end

      it "create member" do
        expect {
          get join_room_path(room)
        }.to change(Member, :count).by(1)
      end

      it "room has members" do
        get join_room_path(room)
        expect(room.members).to include other_user
      end

      it "user join the room" do
        get join_room_path(room)
        expect(other_user.joining).to include room
      end

      it "define @room" do
        get join_room_path(room)
        variable = controller.instance_variable_get("@room")
        expect(variable).to eq room
      end

      it "define flash" do
        get join_room_path(room)
        expect(flash[:notice]).to eq "ルームに参加しました！"
      end
    end

    context "when room's owner" do
      before do
        sign_in user
      end

      it "responds successfully" do
        get join_room_path(room)
        expect(response).to have_http_status 302
      end

      it "redirect to home page" do
        get join_room_path(room)
        expect(response).to redirect_to joining_user_path(user)
      end

      it "does not create member" do
        expect {
          get join_room_path(room)
        }.to_not change(Member, :count)
      end

      it "room does not have members" do
        get join_room_path(room)
        expect(room.members).to_not include user
      end

      it "user does not join the room" do
        get join_room_path(room)
        expect(user.joining).to_not include room
      end

      it "define flash" do
        get join_room_path(room)
        expect(flash[:alert]).to eq "ルームマスターは部屋に参加できません。"
      end
    end

    context "when guest" do
      it "responds successfully" do
        get join_room_path(room)
        expect(response).to have_http_status 302
      end

      it "redirect to log in page" do
        get join_room_path(room)
        expect(response).to redirect_to new_user_session_path
      end

      it "does not create member" do
        expect {
          get join_room_path(room)
        }.to_not change(Member, :count)
      end
    end

    context "when room is not found" do
      before do
        sign_in user
        get join_room_path(room.id + 1000)
      end

      it "responds successfully" do
        expect(response).to have_http_status 302
      end

      it "redirect to home page" do
        expect(response).to redirect_to root_path
      end
    end
  end

  # Rooms#search
  describe "GET /rooms/search" do
    let!(:room1) { create(:room, content: "engineer only!") }
    let!(:room2) { create(:room, content: "this is test room.") }

    before do
      get search_rooms_path, params: { keyword: "engineer" }
    end

    it "responds successfully" do
      expect(response).to have_http_status 200
    end

    it "render template :search" do
      expect(response).to render_template :index
    end

    it "define @rooms" do
      variable = controller.instance_variable_get("@rooms")
      expect(variable).to include room1
    end

    it "@rooms does not include rooms that do not match term" do
      variable = controller.instance_variable_get("@rooms")
      expect(variable).to_not include room2
    end
  end

  # Rooms#exit
  describe "GET /rooms/:id/exit" do
    context "when authenticated user" do
      let(:other_user) { create(:user) }

      before do
        sign_in other_user
      end

      context "when user is a member" do
        before do
          other_user.join room
        end

        it "responds successfully" do
          get exit_room_path(room)
          expect(response).to have_http_status 302
        end

        it "redirect to room page" do
          get exit_room_path(room)
          expect(response).to redirect_to room_path(room)
        end

        it "exit the room" do
          expect {
            get exit_room_path(room)
          }.to change(Member, :count).by(-1)
        end

        it "define @room" do
          get exit_room_path(room)
          variable = controller.instance_variable_get("@room")
          expect(variable).to eq room
        end

        it "define flash" do
          get exit_room_path(room)
          expect(flash[:notice]).to eq "ルームを退出しました。"
        end
      end

      context "when user is not a member" do
        it "does not exit room" do
          expect {
            get exit_room_path(room)
          }.to_not change(Member, :count)
        end

        it "define flash" do
          get exit_room_path(room)
          expect(flash[:alert]).to eq "あなたはこのルームのメンバーではありません。"
        end
      end
    end

    context "when guest" do
      it "responds successfully" do
        get exit_room_path(room)
        expect(response).to have_http_status 302
      end

      it "redirect to login page" do
        get exit_room_path(room)
        expect(response).to redirect_to new_user_session_path
      end

      it "does not exit the room" do
        expect {
          get exit_room_path(room)
        }.to_not change(Member, :count)
      end
    end
  end
end
