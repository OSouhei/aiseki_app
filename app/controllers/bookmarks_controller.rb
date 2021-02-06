class BookmarksController < ApplicationController
  before_action :authenticate_user!, only: [:index, :create, :destroy]

  # GET /bookmarks
  def index
    @bookmarks = current_user.booked_rooms
  end

  # POST /rooms/:id/bookmark
  def create
    @room = Room.find_by(id: params[:id])
    if @room
      current_user.book @room
    else
      flash[:alert] = "Room is not found."
      redirect_back
    end
  end

  # DELETE /bookmarks/:id
  # :id は room_id であることに注意!
  def destroy
    @room = Room.find_by(id: params[:id])
    if @room
      current_user.booked_rooms.delete(@room)
    else
      flash[:alert] = "Room is not found."
      redirect_back
    end
  end

  private

  # xhrリクエストの時、フィルターできなかったので、オーバーライド
  def authenticate_user!
    redirect_to new_user_session_path unless current_user
  end
end
