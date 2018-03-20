class ClapsController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    @trip = @post.trip
    @clap = Clap.new({
      post_id: @post.id,
      user_id: @current_user.id
    })
    if !(already_clapped?(@post))
      if @clap.save
        render(json: {:success => true}.to_json)
      else
        render(json: {:success => false}.to_json)
      end
    else
      render(json: {:success => false, :msg => "Already Clapped"}.to_json)
    end
  end

  private
  def already_clapped?(post)
    check = false
    @current_user.claps.each do |clap|
      if clap.post_id == post.id
        check = true
      end
    end
    return check
  end

end
