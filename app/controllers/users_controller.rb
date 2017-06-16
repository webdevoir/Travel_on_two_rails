class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to new_blog_url, notice: "Signed Up!"
    else
      render "new"
      flash[:notice] = "Form is invalid"
    end
  end

  def update
    @user = current_user
    if @user.update_attributes(user_params)
      redirect_to user_path(@user)
    else
      flash[:error] = "Something went wrong"
      redirect_to user_path(@user)
    end
  end

  def show
    @user = User.find(params[:id])
    @trips = @user.trips
  end


  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar, :cover, :description, :country, :province, :city)
  end
end
