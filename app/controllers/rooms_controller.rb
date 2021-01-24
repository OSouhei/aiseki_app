class RoomsController < ApplicationController
  before_action :set_user, only: [:new, :create]
  before_action :set_room, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_action :correct_user?, only: [:new, :create]
  before_action :room_owner?, only: [:edit, :update, :destroy]

  # GET /rooms
  def index
    @rooms = Room.all
  end

  # GET /rooms/:id
  def show
  end

  # GET /users/:user_id/rooms/new
  def new
    @room = @user.rooms.build
  end

  # POST /users/:user_id/rooms
  def create
    @room = @user.rooms.build(room_params)
    if @room.save
      redirect_to room_path(@room), notice: "room was successfully created."
    else
      render :new
    end
  end

  # GET /rooms/:id/edit
  def edit
  end

  # PATCH /rooms/:id
  def update
    if @room.update(room_params)
      redirect_to room_path(@room), notice: "room was updated."
    else
      render :edit
    end
  end

  # DELETE /rooms/:id
  def destroy
    @room.destroy
    redirect_to root_path, notice: "room was successfully destroyed."
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

  private

  def room_params
    params.require(:room).permit(:conditions, :date, :people_limit, :shop_name)
  end

  def set_user
    @user = User.find_by(id: params[:user_id])
  end

  def set_room
    @room = Room.find_by(id: params[:id]) || redirect_to(root_path, alert: "room was not found.") and return
  end

  def correct_user?
    redirect_to(root_path, alert: "you can't access this page.") and return unless current_user? @user
  end

  def room_owner?
    redirect_to(root_path, alert: "you can't access this page.") and return unless current_user? @room.user
  end
end
