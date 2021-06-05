class Api::UsersController < ApiController
  before_action :set_user, only: [:show]

  # エラーを拾えなかった場合は、500 internal server errorを応答
  rescue_from Exception, with: :render_status_500

  # レコードが見つからなかった場合は、404 not foundを応答
  rescue_from ActiveRecord::RecordNotFound, with: :render_status_404

  # GET /api/users
  def index
    users = User.all
    render json: users
  end

  # GET /api/users/:id
  def show
    render json: @user
  end

  # POST /api/users
  def create
    user = User.new(user_params)
    if user.save
      render json: user, status: 201
    else
      render json: { errors: user.errors.full_messages }, status: 422
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def render_status_400(exception)
    render json: { errors: [exception] }, status: 400
  end

  def render_status_404(exception)
    render json: { errors: [exception] }, status: 404
  end

  def render_status_500(exception)
    render json: { errors: [exception] }, status: 500
  end
end
