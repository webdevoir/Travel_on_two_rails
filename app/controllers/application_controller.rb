class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  helper_method :current_user

  def after_sign_in_path_for(resource)
    user_path(current_user)
  end

  def after_sign_up_path_for(resource)
    user_path(current_user)
  end

  def follows(current_user, user)
    if current_user == user
      return false
    else
       followed_blog = FollowedBlog.where(user_id: current_user.id, blog_owner_id: user.id)
       if followed_blog.length == nil
         return false
       else
         return true
       end
    end
  end

end
