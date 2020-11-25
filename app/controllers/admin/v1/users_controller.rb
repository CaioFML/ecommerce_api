class Admin::V1::UsersController < Admin::V1::ApiController
  before_action :load_user, only: %i[update destroy]

  def index
    @users = User.all
  end

  def create
    @user = User.new(user_params)
    save_user!
  end

  def update
    @user.attributes = user_params
    save_user!
  end

  def destroy
    @user.destroy!
  rescue StandardError
    render_error(fields: @user.errors.messages)
  end

  private

  def load_user
    @user = User.find(params[:id])
  end

  def user_params
    return {} unless params.key?(:user)

    params.require(:user).permit(:id, :name, :profile, :email, :password, :password_confirmation)
  end

  def save_user!
    @user.save!
    render :show
  rescue StandardError
    render_error(fields: @user.errors.messages)
  end
end
