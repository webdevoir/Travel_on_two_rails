class Api::V1::FollowedBlogsController < Api::V1::BaseController

  api :post, "users/:user_id/followed_blogs"
  def create
    current_user = User.find(1)
    @user = User.find(params[:user_id])
    @followed_blog = FollowedBlog.new(blog_owner_id: @user.id, user_id: current_user.id)
    if @followed_blog.save
      render(json: {:success => "success"}.to_json)
    else
      render(json: {:success => "error"}.to_json)
    end
  end

  api :delete, "users/:user_id/followed_blogs/:id"
  def destroy
    @followed_blog = FollowedBlog.find(params[:id])
    if @followed_blog.destroy
      render(json: {:success => "success"}.to_json)
    else
      render(json: {:success => "error"}.to_json)
    end
  end

end
