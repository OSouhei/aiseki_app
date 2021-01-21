class RoomsController < ApplicationController
  before_action :set_user, only: [:show, :new, :create]
  before_action :set_room, only: [:show, :edit, :update]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]
  before_action :correct_user?, only: [:new, :create]
  before_action :room_owner?, only: [:edit, :update]

  def index
    @rooms = Room.all
  end

  def show
  end

  def new
    @room = @user.rooms.build
  end

  def create
    @room = @user.rooms.build(room_params)
    if @room.save
      redirect_to user_room_path(current_user, @room), notice: "room was successfully created."
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

  def search_shop
    term = params[:keyword]
    data = search_shops(term)
    @shops = parse_json(data)
    respond_to do |format|
      format.json { render "index", json: @shops }
    end
  end

  private

  def room_params
    params.require(:room).permit(:conditions, :date, :people_limit, :shop_name)
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
end
