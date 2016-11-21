class PostsController < ApplicationController
  before_action :load_blog


  def new
    @post = Post.new
  end

  def create
    @post = @blog.posts.build(post_params)

    if @post.save
      redirect_to blogs_url
    else
      render :new
    end
  end

  private
  def post_params
    params.require(:post).permit(:post_title, :post_content)
  end

  def load_blog
    @blog = Blog.find(params[:blog_id])
  end
end
