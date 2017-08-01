class SessionsController < ApplicationController
  def new
    # Do something here
  end

  def create
    @user = User.find_by email: params[:session][:email].downcase
    if @user && @user.authenticate(params[:session][:password])
      log_in @user
      remember_or_not @user
      redirect_back_or @user
    else
      flash.now[:danger] = I18n.t "users.new.login_message"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def remember_or_not user
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
  end
end
