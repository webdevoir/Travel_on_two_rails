class ClapsController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    @trip = @post.trip
    @clap = Clap.new({
      post_id: @post.id,
      user_id: @current_user.id
    })
    if @clap.save
      flash[:success] = ""
      redirect_to trip_post_group_path(@trip, @post.post_group)
    else
      flash[:error] = ""
      redirect_to trip_post_group_path(@trip, @post.post_group)
    end
  end

end
