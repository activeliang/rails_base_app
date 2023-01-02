class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: %i[ show update destroy ]
  before_action :authorize_access_request!, except: [:reset_password]
  before_action :require_admin, except: [:reset_password]

# GET /users
  # GET /users.json
  def index
    page = params[:page] || 1
    per_page = params[:per_page] || 20

    binding.pry
    @accounts = User.order(id: :desc).paginate( :page => page, per_page: per_page )
    render json: { code: 0, data: @accounts, paginate: paginate_data(@accounts) }
  end

  # GET /users/1
  # GET /users/1.json 
  def show

  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    puts "\033[42;30mregister: #{user_params}\033[0m"
    if @user.save
      render json: { code: 0, msg: 'ok' }, status: :created
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def reset_password
    user = User.find_by_id params[:id]
    if !user.present?
      render json: { name: ['用户不存在，请联系管理员'] }, status: :unprocessable_entity
      return
    end
    if !user.authenticate(params[:old_password]&.gsub(/\s*/, ''))
      render json: { old_password: ['输入的原密码不正确'] }, status: :unprocessable_entity
      return
    end
    if params[:password]&.gsub(/\s*/, '') != params[:password_confirmation]&.gsub(/\s*/, '')
      render json: { password: ['两次输入密码不一致'] }, status: :unprocessable_entity
      return
    end
    if user.update password: params[:password]
      render json: { code: 0 }, status: :ok
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @user.update(user_params)
      render json: { code: 0, msg: 'ok' }, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions. 
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.permit(:name, :password, :password_confirmation, :mark, :is_freeze)
    end
end
