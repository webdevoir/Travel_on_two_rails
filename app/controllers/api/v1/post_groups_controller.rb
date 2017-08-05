class Api::V1::PostGroupsController < Api::V1::BaseController

  api :get, "trips/:trip_id/post_groups/:id"
  def show
    post_group = PostGroup.find(params[:id])
    result = PostGroupSerializer.new(post_group)

    render(json: result.to_json)
  end

end
