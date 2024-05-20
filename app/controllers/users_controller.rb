class UsersController < ApplicationController
  before_action(
    :logged_in_user,
    only: [:destroy, :edit, :following, :followers, :index, :update]
  )
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = "Please check your email for the account activation link"
      redirect_to root_url
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'User deleted'
    redirect_to users_url, status: :see_other
  end

  def edit
    @user = User.find(params[:id])
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'relationships_index', status: :unprocessable_entity
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'relationships_index', status: :unprocessable_entity
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  private

    def admin_user
      redirect_to(root_url, status: :see_other) unless current_user.admin?
    end

    def user_params
      params.require(:user).permit(
        :name, :email, :password, :password_confirmation
      )
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url, status: :see_other) unless current_user?(@user)
    end
end
