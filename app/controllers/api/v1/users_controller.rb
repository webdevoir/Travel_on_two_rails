class Api::V1::UsersController < Api::V1::BaseController

  api :get, "users/:id"
  def show
    user = User.find(params[:id])
    result = UserSerializer.new(user)
    render(json: { success: true, user: result }.to_json)
  end

end
