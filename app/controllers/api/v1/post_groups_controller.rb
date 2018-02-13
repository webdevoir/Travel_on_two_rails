class Api::V1::PostGroupsController < Api::V1::BaseController

  api :get, "trips/:trip_id/post_groups/:id"
  def show
    post_group = PostGroup.find(params[:id])
    result = PostGroupSerializer.new(post_group)
    render(json: result.to_json)
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

end
