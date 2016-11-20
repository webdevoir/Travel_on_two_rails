class BlogsController < ApplicationController

  def index
    #code
  end

  def show
    #code
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
