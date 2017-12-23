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
