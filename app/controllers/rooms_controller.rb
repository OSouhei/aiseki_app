class RoomsController < ApplicationController
  before_action :set_user, only: [:show, :new, :create]
  before_action :set_room, only: [:show, :edit, :update]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]
  before_action :correct_user?, only: [:new, :create]
  before_action :room_owner?, only: [:edit, :update]
  before_action :parse_params, only: [:create]

  def index
    @rooms = Room.all
  end

  def show
  end

  def new
    @room = @user.rooms.build
  end

  def create
    @room = @user.rooms.build(conditions: @conditions, date: @date, people_limit: @people_limit)
    if @room.save
      redirect_to root_path, notice: "room was successfully created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @room.update(room_params)
      redirect_to user_room_path(@room.user, @room), notice: "room was updated."
    else
      render :edit
    end
  end

  private

  def room_params
    params.require(:room).permit(:conditions, :date, :people_limit)
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_room
    @room = Room.find(params[:id])
  end

  def correct_user?
    redirect_to(root_path, warning: "you can't access this page.") and return unless current_user? @user
  end

  def room_owner?
    redirect_to root_path and return unless @room.user == current_user
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
