class Api::UsersController < ApiController
  before_action :set_user, only: [:show]

  # エラーを拾えなかった場合は、500 internal server errorを応答
  rescue_from Exception, with: :render_status_500

  # レコードが見つからなかった場合は、404 not foundを応答
  rescue_from ActiveRecord::RecordNotFound, with: :render_status_404

  # GET /api/users
  def index
    users = User.all
    render json: {
      result: users
    }
  end

  # GET /api/users/:id
  def show
    render json: {
      user: @user
    }
  end

  # GET /api/login_user
  def login_user
    if user_signed_in?
      render json: current_user
    else
      render json: {}
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def render_status_404(exception)
    render json: { errors: [exception] }, status: 404
  end

  def render_status_500(exception)
    render json: { errors: [exception] }, status: 500
  end
end
