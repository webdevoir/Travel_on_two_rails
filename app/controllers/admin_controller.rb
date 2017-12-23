class AdminController < ApplicationController

  before_filter :check_admin

  def index
    @users = User.all
    @purchases = Purchase.all
    @trips = Trip.all
    @posts = Post.all
    @total_raised = total_raised(@purchases)
  end

  def flagged_messages
    @flagged_messages = Message.where(flagged: true)
  end

  def pardon
    @user = User.find(params[:user_id])
    @message = Message.find(params[:message_id])
    if current_user.admin
      @user.offense_count -= 1
      @user.open_offense = false
      if @user.save
        flash[:notice] = "Pardon'd user"
        SendPardonUserEmailJob.set(wait: 20.seconds).perform_later(@user, @message)
        redirect_to flagged_messages_path
      else
        flash[:error] = "Something went wrong"
        redirect_to '/admin'
      end
    else
      flash[:error] = "Need to be admin."
      redirect_to '/'
    end
  end

  def warn
    @user = User.find(params[:user_id])
    @message = Message.find(params[:message_id])
    if current_user.admin
      @user.open_offense = false
      if @user.save
        flash[:notice] = "Warned User"
        SendWarnUserEmailJob.set(wait: 20.seconds).perform_later(@user, @message)
        redirect_to flagged_messages_path
      else
        flash[:error] = "Something went wrong"
        redirect_to '/admin'
      end
    else
      flash[:error] = "Need to be admin."
      redirect_to '/'
    end
  end

  def ban
    @user = User.find(params[:user_id])
    @message = Message.find(params[:message_id])
    if current_user.admin
      @user.open_offense = false
      @user,ban
      if @user.save
        flash[:notice] = "Banned User"
        SendBannedUserEmailJob.set(wait: 20.seconds).perform_later(@user, @message)
        # TODO: Add email to user that he has been banned
        redirect_to flagged_messages_path
      else
        flash[:error] = "Something went wrong"
        redirect_to '/admin'
      end
    else
      flash[:error] = "Need to be admin."
      redirect_to '/'
    end
  end

  private
  def total_raised(purchases)
    total = 0
    purchases.each do |purchase|
      total += purchase.stripe_charge.to_i
    end
    return total
  end

  def check_admin
    if !(@current_user.admin)
      redirect_to root_url
    end
  end

end
