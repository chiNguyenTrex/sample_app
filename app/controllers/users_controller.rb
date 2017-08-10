class UsersController < ApplicationController
  before_action :load_user, only: %i(show destroy followers following)
  before_action :logged_in_user, except: %i(show new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def following
    @title = t "follows.view.following_title"
    @users = @user.following.paginate page: params[:page]
    render :show_follow
  end

  def followers
    @title = t "follows.view.follower_title"
    @users = @user.followers.paginate page: params[:page]
    render :show_follow
  end

  def index
    @users = User.get_all_user.paginate page: params[:page]
  end

  def show
    return (@microposts = microposts_of_user) if @user
    flash[:danger] = t "users.new.no_user"
    redirect_to root_url
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "users.account.active_account"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit
    # Do something here
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "users.new.update_success"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    if @user.destroyed?
      flash[:success] = t "users.admin.success_delete"
    else
      flash[:danger] = t "users.admin.fail_delete"
    end
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end

  # Catch id from request and read user from DB by the id
  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "users.new.user_no_found"
    redirect_to root_path
  end

  def microposts_of_user
    @user.microposts.paginate page: params[:page]
  end
end
