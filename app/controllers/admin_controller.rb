class AdminController < ApplicationController

  def index
    @users = User.all
    @purchases = Purchase.all
    @trips = Trip.all
    @posts = Post.all
  end

end
