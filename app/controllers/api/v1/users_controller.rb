class Api::V1::UsersController < Api::V1::BaseController

  api :get, "users/:id"
  param :current_user_id, String, :desc => "Current user id"
  def show
    user = User.find(params[:id])
    result = UserSerializer.new(user)
    current_user = User.find(params[:current_user_id])
    following, followed_blog = follows(current_user, user)
    render(json: { success: true, user: result, following: following, followed_blog: followed_blog }.to_json)
  end

  api :put, "users/:id"
  param :user, Hash, :desc => "Params for details of a user" do
    param :name, String
    param :email, String
    param :password, String
    param :password_confirmation, String
    param :avatar, String
    param :cover, String
    param :description, String
    param :country, String
    param :province, String
    param :city, String
  end
  def update
    @user = User.find(params[:id])
    if params[:coverPhoto] == nil
      @user.avatar = params[:file]
    else
      @user.cover = params[:file]
    end
    if @user.save
      result = UserSerializer.new(@user)
      render(json: { success: true, user: result }.to_json)
    else
      flash[:error] = "Something went wrong"
      render(json: { success: false, message: "something went wrong" }.to_json)
    end
  end

  private
  def follows(current_user, user)
    if current_user == user || current_user == nil
      return false
    else
       followed_blog = FollowedBlog.where(user_id: current_user.id, blog_owner_id: user.id)
       if followed_blog.length == 0
         return false
       else
         return true, followed_blog[0]
       end
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar, :cover, :description, :country, :province, :city)
  end
end
