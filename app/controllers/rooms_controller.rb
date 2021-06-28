class RoomsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy, :join, :exit]
  before_action :set_room, only: [:show, :update, :destroy, :join, :exit]
  before_action :room_owner?, only: [:update, :destroy]

  # GET /rooms
  def index
    @rooms = Room.all.page(params[:page]).per(9)
  end

  # GET /rooms/:id
  def show
    @members = @room.members
  end

  # POST /rooms
  def create
    @room = current_user.rooms.build(room_params)
    if @room.save
      render json: {
        result: {
          room: @room
        }
      }
    else
      render json: {
        errors: @room.errors.full_messages
      }
    end
  end

  # PATCH /rooms/:id
  def update
    @room.update(room_params) ? redirect_to(room_path(@room), notice: "ルームを編集しました！") : render(:edit)
  end

  # DELETE /rooms/:id
  def destroy
    @room.destroy ? redirect_to(root_path, notice: "ルームは削除されました。") : redirect_to(root_path, alert: "ルームが削除できませんでした。")
  end

  # GET /rooms/search_shop
  def search_shop
    term = params[:keyword]
    data = search_shops(term)
    @shops = retrieve_shop_name_from_xml(data)
    render json: {
      shops: @shops
    }
  end

  # GET /rooms/:id/join
  def join
    redirect_to(root_path, alert: "この部屋は満員です。") && return if @room.limited?

    message = {}
    current_user.join(@room) ? message[:notice] = "ルームに参加しました！" : message[:alert] = "ルームマスターは部屋に参加できません。"
    redirect_to joining_user_path(current_user), message
  end

  # GET /rooms/search
  def search
    term = params[:keyword]
    @rooms = Room.search(term).page(params[:page]).per 6
    render :index
  end

  # GET /rooms/:id/exit
  def exit
    current_user.exit(@room) ? redirect_to(room_path(@room), notice: "ルームを退出しました。") : redirect_to(room_path(@room), alert: "あなたはこのルームのメンバーではありません。")
  end

  private

  def room_params
    params.require(:room).permit(:title, :content, :limit, :shop_name, :shop_url, :date)
  end

  def set_room
    @room = Room.find_by(id: params[:id]) || redirect_to(root_path, alert: "ルームを見つけることができませんでした。") && return
  end

  def room_owner?
    redirect_to(root_path, alert: "このページにはアクセスできません。") and return unless @room.owner?(current_user)
  end
end
