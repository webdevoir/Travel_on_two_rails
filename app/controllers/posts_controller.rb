class PostsController < ApplicationController

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)

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
end
