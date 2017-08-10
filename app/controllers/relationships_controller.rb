class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    if (@user = User.find params[:followed_id])
      current_user.follow @user
      respond_to do |format|
        format.html{redirect_to @user}
        format.js
      end
    else
      flash[:danger] = I18n.t "users.new.user_no_found"
      redirect_to root_url
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow @user
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end
end
