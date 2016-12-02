class BlogsController < ApplicationController

  def index
    @blogs = Blog.all
    @blogs = Blog.search(params[:search])
  end

  def show
    # @blog = Blog.find(params[:id])
    @blog = Blog.find_by(id: params[:id])
    if @blog.blank?
      redirect_to new_blog_url
    end
  end

  def create
    @blog = Blog.new(blog_params)

    if current_user
      @blog.user_id = current_user.id
    end

    if @blog.save
      redirect_to blogs_url
    else
      render :new
    end
  end

  def new
    @blog = Blog.new
  end



  private
  def blog_params
    params.require(:blog).permit(:blog_name)
  end

end
