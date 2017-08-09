class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = I18n.t "users.account.success_activate"
      redirect_to user
    else
      flash[:danger] = I18n.t "users.account.fail_activate"
      redirect_to root_url
    end
  end
end
