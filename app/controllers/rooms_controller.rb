class RoomsController < ApplicationController
  protect_from_forgery

  before_action :authenticate_user!, only: [:create, :update, :destroy, :join, :exit]
  before_action :set_room, only: [:show, :update, :destroy, :join, :exit]
  before_action :room_owner?, only: [:update, :destroy]

  # エラーを拾えなかった場合は、500 internal server errorを応答
  rescue_from Exception, with: :render_status_500

  # レコードが見つからなかった場合は、404 not foundを応答
  rescue_from ActiveRecord::RecordNotFound, with: :render_status_404

  # GET /rooms
  def index
    @rooms = Room.all
    render json: {
      result: {
        rooms: @rooms
      }
    }
  end

  # GET /rooms/:id
  def show
    render json: {
      result: {
        room: {
          id: @room.id,
          title: @room.title,
          content: @room.content,
          shop_name: @room.shop_name,
          shop_url: @room.shop_url,
          limit: @room.limit,
          owner_id: @room.owner.id,
          owner_name: @room.owner.name
        }
      }
    }
  end

  # POST /rooms
  def create
    @room = current_user.rooms.build(room_params)
    http_status = @room.save ? :ok : :bad_request
    render json: {
      result: {
        room: @room,
        errors: @room.errors.full_messages
      }
    }, status: http_status
  end

  # PATCH /rooms/:id
  def update
    if @room.update(room_params)
      render json: {
        result: {
          room: @room.reload
        }
      }
    else
      render json: {
        errors: @room.errors.full_messages
      }, status: :bad_request
    end
  end

  # DELETE /rooms/:id
  def destroy
    if @room.destroy
      render json: {}, status: :ok
    else
      render json: {
        errors: '未知のエラー'
      }, status: :bad_request
    end
  end

  # GET /rooms/search_shop
  def search_shop
    term = params[:keyword]
    data = search_shops(term)["results"]["shop"]
    return if data.nil?

    @shops = []
    data.each do |shop|
      @shops << { name: shop["name"], url: shop["urls"]["pc"] }
    end
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
    @room = Room.find(params[:id])
  end

  def room_owner?
    redirect_to(root_path, alert: "このページにはアクセスできません。") and return unless @room.owner?(current_user)
  end

  def render_status_404(exception)
    render json: { errors: [exception] }, status: :not_found
  end

  def render_status_500(exception)
    render json: { errors: [exception] }, status: :internal_server_error
  end
end
