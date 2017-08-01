class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = I18n.t "users.password.email_info"
      redirect_to root_url
    else
      flash.now[:danger] = I18n.t "users.password.invalid_email"
      render :new
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add :password, I18n.t("users.password.password_empty")
      render :edit
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = I18n.t "users.password.password_reseted"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def get_user
    @user = User.find_by email: params[:email]
    return if @user
    flash[:danger] = I18n.t "users.new.user_no_found"
    redirect_to login_url
  end

  # Confirm a valid user
  def valid_user
    redirect_to root_url unless is_valid?
  end

  def is_valid?
    @user && @user.activated? && @user.authenticated?(:reset, params[:id])
  end

  # Check expiration of reset token
  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = I18n.t "users.password.password_expired"
      redirect_to new_password_reset_url
    end
  end
end
