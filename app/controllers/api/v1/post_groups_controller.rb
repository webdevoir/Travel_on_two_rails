class Api::V1::PostGroupsController < Api::V1::BaseController

  api :get, "trips/:trip_id/post_groups/:id"
  def show
    @current_user = User.find(params[:user_id])
    post_group = PostGroup.find(params[:id])
    result = PostGroupSerializer.new(post_group)
    result.object.posts.each do |post|
      already_clapped = already_clapped?(post)
      post.already_clapped = already_clapped
    end
    json_result = JSON.parse({ post_group: result }.to_json)
    json_result["post_group"]["posts"].each do |post_hash|
      post = Post.find(post_hash["id"])
      route = post.route
      clapped = already_clapped?(post)
      post_hash["already_clapped"] = clapped
      post_hash["route"] = route
    end
    render(json: json_result.to_json )
  end


  api :put, "trips/:trip_id/post_groups/:id"
  def update
    @post_group = PostGroup.find(params[:id])
    @post_group.image = params[:file]
    if @post_group.save
      render(json: {:success => true, :trip => @post_group}.to_json)
    else
      render(json: {:success => "error"}.to_json)
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
