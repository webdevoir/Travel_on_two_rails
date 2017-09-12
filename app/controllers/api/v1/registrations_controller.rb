class Api::V1::RegistrationsController < Api::V1::BaseController

  respond_to :json
  api :post, "users"
  param :users, Hash do
    param :email, String
    param :password, String
  end
  def create

    user = User.new(params[:user])
    if user.save
      render :json=> user.as_json(:email=>user.email), :status=>201
      return
    else
      warden.custom_failure!
      render :json=> user.errors, :status=>422
    end
  end
end
