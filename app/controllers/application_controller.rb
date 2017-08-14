class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = I18n.t "users.new.filter_login"
    redirect_to login_url
  end

  # Confirm the correct user when user trying to modify a profile
  def correct_user
    @user = User.find params[:id]
    redirect_to root_url unless current_user? @user
  end

  # Confirm user is admin
  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
