# require 'rails_helper'

# RSpec.describe "Bookmarks", type: :request do
#   let(:user) { create(:user) }
#   let(:room) { create(:room) }

#   # Bookmarks#index
#   describe "GET /bookmarks" do
#     context "when authenticated user" do
#       before do
#         sign_in user
#         create(:bookmark, user: user, room: room)
#         get bookmarks_path
#       end

#       it "responds successfully" do
#         expect(response).to have_http_status 200
#       end

#       it "render template :index" do
#         expect(response).to render_template :index
#       end

#       it "define @bookmarks" do
#         variable = controller.instance_variable_get("@bookmarks")
#         expect(variable).to include room
#       end
#     end

#     context "when guest" do
#       before do
#         get bookmarks_path
#       end

#       it "responds successfully" do
#         expect(response).to have_http_status 302
#       end

#       it "redirect to login page" do
#         expect(response).to redirect_to new_user_session_path
#       end
#     end
#   end

#   # Bookmarks#create
#   describe "POST /rooms/:id/bookmark" do
#     context "when authenticated user" do
#       before do
#         sign_in user
#       end

#       it "responds successfully" do
#         post bookmark_room_path(room), xhr: true
#         expect(response).to have_http_status 200
#       end

#       it "render template bookmarks/create.js.erb" do
#         post bookmark_room_path(room), xhr: true
#         expect(response).to render_template "bookmarks/create"
#       end

#       it "render partial" do
#         post bookmark_room_path(room), xhr: true
#         expect(response).to render_template partial: "bookmarks/_bookmark_icon"
#       end

#       it "create bookmark" do
#         expect {
#           post bookmark_room_path(room), xhr: true
#         }.to change(Bookmark, :count).by(1)
#       end

#       it "define @room" do
#         post bookmark_room_path(room), xhr: true
#         variable = controller.instance_variable_get("@room")
#         expect(variable).to eq room
#       end

#       context "when room is not found by params" do
#         before do
#           post bookmark_room_path(1000), xhr: true
#         end

#         it "define instance variable as nil" do
#           variable = controller.instance_variable_get("@room")
#           expect(variable).to be_nil
#         end

#         it "redirect to previous url" do
#           expect(response).to redirect_to root_path
#         end

#         it "define flash" do
#           expect(flash[:alert]).to eq "Room is not found."
#         end
#       end
#     end

#     context "when guest" do
#       it "redirect to login page" do
#         post bookmark_room_path(room), xhr: true
#         expect(response).to redirect_to new_user_session_path
#       end

#       it "does not create bookmark" do
#         expect {
#           post bookmark_room_path(room), xhr: true
#         }.to_not change(Bookmark, :count)
#       end

#       it "does not define @room" do
#         variable = controller.instance_variable_get("@room")
#         expect(variable).to be_nil
#       end
#     end
#   end

#   # Bookmarks#destroy
#   describe "DELETE /bookmarks/:id" do
#     context "when authenticated user" do
#       before do
#         sign_in user
#       end

#       it "responds successfully" do
#         delete bookmark_path(room), xhr: true
#         expect(response).to have_http_status 200
#       end

#       it "render template bookmarks/destroy.js.erb" do
#         delete bookmark_path(room), xhr: true
#         expect(response).to render_template "bookmarks/destroy"
#       end

#       it "render partial" do
#         delete bookmark_path(room), xhr: true
#         expect(response).to render_template partial: "bookmarks/_bookmark_icon"
#       end

#       it "destroy bookmark" do
#         create(:bookmark, user: user, room: room)
#         expect {
#           delete bookmark_path(room), xhr: true
#         }.to change(Bookmark, :count).by(-1)
#       end

#       it "define @room" do
#         delete bookmark_path(room), xhr: true
#         variable = controller.instance_variable_get("@room")
#         expect(variable).to eq room
#       end

#       context "when room is not found by params" do
#         it "define @room as nil" do
#           delete bookmark_path(1000), xhr: true
#           variable = controller.instance_variable_get("@room")
#           expect(variable).to be_nil
#         end

#         it "redirect to previous url" do
#           get room_path(room)
#           delete bookmark_path(1000), xhr: true
#           expect(response).to redirect_to room_path(room)
#         end

#         it "define flash" do
#           delete bookmark_path(1000), xhr: true
#           expect(flash[:alert]).to eq "Room is not found."
#         end
#       end
#     end

#     context "when guest" do
#       it "redirect to new_user_session_path" do
#         delete bookmark_path(room), xhr: true
#         expect(response).to redirect_to new_user_session_path
#       end

#       it "does not destroy bookmark" do
#         expect {
#           delete bookmark_path(room), xhr: true
#         }.to_not change(Bookmark, :count)
#       end
#     end
#   end
# end
