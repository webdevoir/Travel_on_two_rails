class HomeController < ApplicationController
  def index
    if current_user
      @user_id = current_user.id
    end
  end
end
