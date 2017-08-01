class UsersController < ApplicationController
  before_action :load_user, only: [:show, :destroy]
  before_action :logged_in_user, except: [:show, :new, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.get_all_user.paginate page: params[:page]
  end

  def show
    return if @user
    flash[:danger] = I18n.t "users.new.no_user"
    redirect_to root_url
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = I18n.t "users.account.active_account"
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
      flash[:success] = I18n.t "users.new.update_success"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    if @user.destroyed?
      flash[:success] = I18n.t "users.admin.success_delete"
    else
      flash[:success] = I18n.t "users.admin.fail_delete"
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
    flash[:danger] = I18n.t "users.new.user_no_found"
    redirect_to root_path
  end
end
