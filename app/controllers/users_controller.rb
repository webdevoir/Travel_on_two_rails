class UsersController < ApplicationController
    before_filter :require_permission, only: :update

  def new
    @user = User.new
  end

  def create
    raise 'hti'
    @user = User.new(user_params)
    @user.terms_accepted_at = Time.now
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
    @trips = @user.trips.sort_by {|obj| obj.updated_at}.reverse
    @follows = follows(current_user, @user)
    if @follows == true
      @followed_blog = FollowedBlog.find_by(user_id: current_user.id, blog_owner_id: @user.id)
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def verification
    @user = User.find(params[:user_id])
    @user.verified = true
    if @user.save
      flash[:notice] = "You have been successfully verified"
      redirect_to user_path(@user)
    else
      flash[:notice] = "Something went wrong, please try again or contact staff"
      redirect_to user_path(@user)
    end
  end

  def unsubscribe
    @user = User.find(params[:user_id])
    @user.email_subscribe = false
    if @user.save
      flash[:notice] = "You have unsubscribed"
      redirect_to user_path(@user)
    else
      flash[:notice] = "Something went wrong, please try again or contact staff"
      redirect_to user_path(@user)
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar, :cover, :description, :country, :province, :city)
  end

  def require_permission
    if current_user != User.find(params[:id])
      redirect_to root_path
    end
  end

end
