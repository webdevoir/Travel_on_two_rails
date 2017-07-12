class FollowedBlogsController < ApplicationController

  def index
    @followed_blogs = current_user.followed_blogs
  end

  def create
    @user = User.find(params[:user_id])
    @followed_blog = FollowedBlog.new(blog_owner_id: @user.id, user_id: current_user.id)
    if @followed_blog.save
      redirect_to user_followed_blogs_path(current_user)
    else
      redirect_to user_followed_blogs_path(current_user)
      flash[:error] = "Something went wrong"
    end
  end

  def destroy
    @followed_blog = FollowedBlog.find(params[:id])
    if @followed_blog.destroy
      redirect_to user_followed_blogs_path(current_user)
    else
      flash[:error] = "Something went wrong"
    end
  end

end
