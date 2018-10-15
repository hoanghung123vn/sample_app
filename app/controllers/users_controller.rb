class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page], per_page: Settings.per_page)
  end

  def show
    @user = User.find_by id: params[:id]
    @microposts = @user.microposts.paginate(page: params[:page],
      per_page: Settings.per_page)
    return if @user
    flash[:danger] = t "not_found"
    redirect_to login_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "require_check_email"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit
    @user = User.find_by params[:id]
  end

  def update
    @user = User.find_by params[:id]
    if @user.update_attributes(user_params)
      flash[:success] = t "update_success"
      redirect_to @user
    else
      flash[:danger] = t "update_fail"
      render :edit
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = t "delete_success"
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
      :password_confirmation)
  end

  def correct_user
    @user = User.find_by(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
