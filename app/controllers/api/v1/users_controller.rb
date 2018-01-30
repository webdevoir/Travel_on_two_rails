class Api::V1::UsersController < Api::V1::BaseController

  api :get, "users/:id"
  param :current_user_id, String, :desc => "Current user id"
  def show
    user = User.find(params[:id])
    result = UserSerializer.new(user)
    current_user = User.find(params[:current_user_id])
    following, followed_blog = follows(current_user, user)
    render(json: { success: true, user: result, following: following, followed_blog: followed_blog }.to_json)
  end

  private
  def follows(current_user, user)
    if current_user == user || current_user == nil
      return false
    else
       followed_blog = FollowedBlog.where(user_id: current_user.id, blog_owner_id: user.id)
       if followed_blog.length == 0
         return false
       else
         return true, followed_blog[0]
       end
    end
  end
end
