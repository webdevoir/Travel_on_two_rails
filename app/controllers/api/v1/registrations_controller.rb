class Api::V1::RegistrationsController < Api::V1::BaseController

  respond_to :json
  api :post, "users"
  param :users, Hash do
    param :email, String
    param :password, String
  end
  def create
    user = User.new(user_params)
    binding.pry
    if user.save
      render :json=> {:success=>true, :email=>user.email, :user_id=>user.id, :user => user}
      return
    else
      binding.pry
      render :json=> user.errors, :status=>422
    end
  end

  private
  def user_params
    params.require(:registration).permit(:name, :email, :password)
  end

end
