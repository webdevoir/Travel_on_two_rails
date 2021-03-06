class Api::V1::BaseController < ApplicationController
  protect_from_forgery with: :null_session

  before_action :destroy_session
  skip_before_action :verify_authenticity_token

  # before_filter :restrict_access

  rescue_from ActiveRecord::RecordNotFound, with: :not_found!

  def destroy_session
    request.session_options[:skip] = true
  end

  def not_found!
    return render(json: {:status=>404, :errors=>"Not found"}.to_json)
  end

  # def restrict_access
  #   authenticate_or_request_with_http_token do |token, options|
  #     ApiKey.exists?(access_token: token)
  #   end
  # end

  def read_nav_check
    if current_user
      @conversations = current_user.conversations
      @read = false
      @conversations.each do |conversation|
        if conversation.read?(conversation, current_user)
          @read = true
        end
      end
    end
  end

end
