class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  helper_method :current_user
end
