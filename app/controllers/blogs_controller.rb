class BlogsController < ApplicationController

  def index
    @blogs = Blog.all
  end

  def show
    @blog = Blog.find(params[:id])
  end

  def create
    @blog = Blog.new(blog_params)

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
