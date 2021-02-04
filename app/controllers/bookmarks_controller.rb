class BookmarksController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  # POST /rooms/:id/bookmark
  def create
    @room = Room.find_by(id: params[:id])
    @room ? current_user.booked_rooms << @room : flash[:alert] = "Room is not found."
  end

  def destroy
    @room = Room.find_by(id: params[:id])
    @room ? current_user.booked_rooms.delete(@room) : flash[:alert] = "Room is not found."
  end
end
