class RoomsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :join, :exit]
  before_action :set_room, only: [:show, :edit, :update, :destroy, :join, :exit]
  before_action :room_owner?, only: [:edit, :update, :destroy]

  def index
    @rooms = Room.all
  end

  def show
    @members = @room.members
  end

  def new
    @room = current_user.rooms.build
  end

  def create
    @room = current_user.rooms.build(room_params)
    @room.save ? redirect_to(room_path(@room), notice: "room was successfully created.") : render(:new)
  end

  def edit
  end

  def update
    @room.update(room_params) ? redirect_to(room_path(@room), notice: "room was updated.") : render(:edit)
  end

  def destroy
    @room.destroy ? redirect_to(root_path, notice: "room was successfully destroyed.") : redirect_to(root_path, alert: "something went wrong.")
  end

  # GET /rooms/search_shop
  def search_shop
    term = params[:keyword]
    data = search_shops(term)
    @shops = parse_json(data)
    respond_to do |format|
      format.json { render "index", json: @shops }
    end
  end

  # GET /rooms/:id/join
  def join
    redirect_to(root_path, alert: "this room is full.") && return if @room.limited?

    message = {}
    current_user.join(@room) ? message[:notice] = "you joined the room." : message[:alert] = "you can not join the room because you are the room owner."
    redirect_to root_path, message
  end

  # GET /rooms/search
  def search
    term = params[:keyword]
    @rooms = Room.search(term)
  end

  # GET /rooms/:id/exit
  def exit
    current_user.exit(@room) ? redirect_to(room_path(@room), notice: "you exited the room.") : redirect_to(room_path(@room), alert: "you has already exited the room.")
  end

  private

  def room_params
    params.require(:room).permit(:title, :content, :limit, :shop_name)
  end

  def set_room
    @room = Room.find_by(id: params[:id]) || redirect_to(root_path, alert: "room was not found.") && return
  end

  def room_owner?
    redirect_to(root_path, alert: "you can't access this page.") and return unless @room.owner?(current_user)
  end
end
