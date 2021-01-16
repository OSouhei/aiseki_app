class RoomsController < ApplicationController
  before_action :set_user, only: [:new, :create]
  before_action :authenticate_user!, only: [:new, :create]
  before_action :correct_user?, only: [:new, :create]
  before_action :parse_params, only: [:create]

  def index
    @rooms = Room.all
  end

  def show
    @room = Room.find(params[:id])
  end

  def new
    @room = @user.rooms.build
  end

  def create
    @room = @user.rooms.build(
      conditions: @conditions,
      date: @date,
      people_limit: @people_limit
    )
    if @room.save
      flash[:notice] = "room was successfully created."
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def correct_user?
    redirect_to root_path and return unless current_user? @user
  end

  def parse_params
    room_params = params[:room]
    @conditions = room_params[:conditions]
    @people_limit = room_params[:people_limit]
    @date = room_params[:date]
    @date = Time.zone.local(
      room_params["date(1i)"],
      room_params["date(2i)"],
      room_params["date(3i)"],
      room_params["date(4i)"],
      room_params["date(5i)"]
    )
  end
end
