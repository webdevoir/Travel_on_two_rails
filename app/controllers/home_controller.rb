class HomeController < ApplicationController
  def index
    @blog_id = current_user.blog.id
  end
end
