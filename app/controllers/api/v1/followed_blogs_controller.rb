class Api::V1::FollowedBlogsController < Api::V1::BaseController

  api :get, "users/:user_id/followed_blogs"
  def index

    followed_blogs = User.find(params[:user_id]).followed_blogs

    results = []

    followed_blogs.each do |followed_blog|
      result = FollowedBlogSerializer.new(followed_blog)
      results << result
    end

    render(json: { success: true, followed_blogs: results }.to_json)
  end

  api :post, "users/:user_id/followed_blogs"
  param :current_user_id, Integer, :desc => "Current User Id"
  def create
    current_user = User.find(params[:current_user_id])
    @user = User.find(params[:user_id])
    @followed_blog = FollowedBlog.new(blog_owner_id: @user.id, user_id: current_user.id)
    if @followed_blog.save
      render(json: {:success => true}.to_json)
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
