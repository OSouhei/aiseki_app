class BookmarksController < ApplicationController
  before_action :authenticate_user!, only: [:create]

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

  def destroy
    @room = Room.find_by(id: params[:id])
    @room ? current_user.booked_rooms.delete(@room) : flash[:alert] = "Room is not found."
  end

  private

  # xhrリクエストの時、フィルターできなかったので、オーバーライド
  def authenticate_user!
    redirect_to new_user_session_path unless current_user
  end
end
