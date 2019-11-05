class StaticPagesController < ApplicationController
  def home
    if logged_in?
    @micropost = current_user.microposts.build  #если пользователь авторизован, то нужно определить(связать?) микропост с определенным пользователем
    @feed_items = current_user.feed.paginate(page: params[:page])#если пользователь авторизован то для current_user из юзер модели найти все микропосты с ним связанные и разделить из по станицам на странице, соответствующей данной вьхе (static_pages/home)
  end
    end

  def help
  end

  def about
  end
end
