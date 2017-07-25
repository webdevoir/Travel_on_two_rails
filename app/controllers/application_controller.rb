class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  after_action :read_nav_check

  private

  helper_method :current_user

  def after_sign_in_path_for(resource)
    user_path(current_user)
  end

  def read_nav_check
    if current_user
      @conversations = current_user.conversations
      @read = false
      @conversations.each do |conversation|
        if conversation.read?(conversation, current_user)
          raise 'hit'
          @read = true
        end
      end
    end
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
