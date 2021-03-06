class StaticPagesController < ApplicationController
  def home
    return unless logged_in?
    @micropost = current_user.microposts.build
    @feed_items = User.feed(current_user).paginate page: params[:page]
  end

  def help
    # Do some thing here
  end

  def about
    # Do some thing here
  end

  def contact
    # Do some thing here
  end
end
